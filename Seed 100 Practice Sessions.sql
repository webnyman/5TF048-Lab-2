-- === PARAMETRAR ==========================================================
DECLARE @UserEmail NVARCHAR(256) = N'info@trumpet.se';   -- <-- BYT VID BEHOV
DECLARE @DaysBack  INT           = 100;                  -- antal dagar bakåt att sprida ut passen

SET NOCOUNT ON;

-- === HÄMTA USERID FRÅN ASP.NET IDENTITY ================================
DECLARE @UserId UNIQUEIDENTIFIER =
(
    SELECT TOP 1 CAST(Id AS UNIQUEIDENTIFIER)
    FROM dbo.AspNetUsers
    WHERE NormalizedEmail = UPPER(@UserEmail)
);

IF @UserId IS NULL
BEGIN
    RAISERROR('Hittar ingen användare med e-post %s i AspNetUsers.', 16, 1, @UserEmail);
    RETURN;
END

-- === SÄKERSTÄLL TRUMPET-INSTRUMENT =====================================
DECLARE @InstrumentId INT =
(
    SELECT InstrumentId FROM dbo.Instruments WHERE Name = N'Trumpet'
);

IF @InstrumentId IS NULL
BEGIN
    INSERT INTO dbo.Instruments(Name, Family) VALUES (N'Trumpet', N'Brass');
    SET @InstrumentId = SCOPE_IDENTITY();
END

-- (Valfritt) Rensa tidigare seedade trumpet-pass för just denna användare:
-- DELETE dbo.PracticeSessions WHERE UserId = @UserId AND InstrumentId = @InstrumentId;

-- === GENERERA 1..@DaysBack RADER MED LÄTT FRAMSTEG ======================
;WITH N AS
(
    SELECT TOP (@DaysBack) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
),
R AS
(
    SELECT
        n,
        ABS(CHECKSUM(NEWID())) AS r1,
        ABS(CHECKSUM(NEWID())) AS r2,
        ABS(CHECKSUM(NEWID())) AS r3
    FROM N
),
P AS
(
    SELECT
        n,
        CAST(DATEADD(DAY, -(@DaysBack - n), CAST(GETDATE() AS date)) AS date)   AS PracticeDate,
        15 + (r1 % 50) + (n % 10)                                              AS Minutes,
        CAST(CASE WHEN (1 + ((n-1)/25) + (r1 % 2)) > 5 THEN 5 ELSE (1 + ((n-1)/25) + (r1 % 2)) END AS TINYINT) AS Intensity,

        CASE (r1 % 6)
            WHEN 0 THEN N'Uppvärmning'
            WHEN 1 THEN N'Teknik'
            WHEN 2 THEN N'Skalor'
            WHEN 3 THEN N'Etyder'
            WHEN 4 THEN N'Repertoar'
            ELSE N'Övrigt'
        END                                                                     AS Focus,
        CAST(((r1 % 6) + 1) AS TINYINT)                                        AS PracticeType,

        CAST(70 + (n/2) + (r2 % 6) AS SMALLINT)                                 AS TempoStartRaw,
        CAST(70 + (n/2) + (r2 % 6) + 5 + (n % 6) AS SMALLINT)                   AS TempoEndRaw,

        CASE WHEN n > (@DaysBack*2/3) THEN 1
             WHEN n > (@DaysBack/3)  THEN CASE WHEN (r2 % 3) <> 0 THEN 1 ELSE 0 END
             ELSE CASE WHEN (r2 % 4) = 0 THEN 1 ELSE 0 END
        END                                                                     AS Achieved,

        CASE WHEN (r3 % 10) < 7 THEN 1 ELSE 0 END                               AS Metronome,
        CAST(4 + (n % 20) + (r3 % 5) AS SMALLINT)                               AS Reps,

        CAST(
            CASE 
              WHEN (6 - (n/18) + (r1 % 2)) < 0 THEN 0 
              ELSE  (6 - (n/18) + (r1 % 2))
            END AS SMALLINT)                                                    AS Errors,

        CAST(CASE WHEN (2 + (n/30) + (r1 % 3)) > 5 THEN 5 ELSE (2 + (n/30) + (r1 % 3)) END AS TINYINT) AS Mood,
        CAST(CASE WHEN (2 + (n/28) + (r2 % 3)) > 5 THEN 5 ELSE (2 + (n/28) + (r2 % 3)) END AS TINYINT) AS Energy,
        CAST(CASE WHEN (2 + (n/26) + (r3 % 3)) > 5 THEN 5 ELSE (2 + (n/26) + (r3 % 3)) END AS TINYINT) AS FocusScore
    FROM R
)
INSERT INTO dbo.PracticeSessions
(
    UserId, InstrumentId, PracticeDate, Minutes, Intensity,
    Focus, Comment, PracticeType, Goal, Achieved,
    Mood, Energy, FocusScore, TempoStart, TempoEnd, Metronome,
    Reps, Errors
)
SELECT
    @UserId,
    @InstrumentId,
    p.PracticeDate,
    p.Minutes,
    p.Intensity,
    p.Focus,
    NULL AS Comment,
    p.PracticeType,
    CASE 
        WHEN p.TempoStartRaw IS NOT NULL 
             THEN N'Öka C-dur från ' + CAST(p.TempoStartRaw AS NVARCHAR(10)) + N'→' + CAST(p.TempoEndRaw AS NVARCHAR(10)) + N' bpm'
        ELSE N'Fokusera på ' + p.Focus
    END AS Goal,
    CAST(p.Achieved AS BIT),
    p.Mood,
    p.Energy,
    p.FocusScore,
    -- ersättning för LEAST/GREATEST:
    CAST(CASE WHEN p.TempoStartRaw < 60 THEN 60 WHEN p.TempoStartRaw > 200 THEN 200 ELSE p.TempoStartRaw END AS SMALLINT) AS TempoStart,
    CAST(CASE WHEN p.TempoEndRaw   < 60 THEN 60 WHEN p.TempoEndRaw   > 200 THEN 200 ELSE p.TempoEndRaw   END AS SMALLINT) AS TempoEnd,
    CAST(p.Metronome AS BIT),
    p.Reps,
    p.Errors
FROM P p;

-- === KONTROLL ============================================================
SELECT COUNT(*) AS SeededTrumpetRowsForUser
FROM dbo.PracticeSessions
WHERE UserId=@UserId AND InstrumentId=@InstrumentId;

SELECT TOP 10 SessionId, PracticeDate, Minutes, Intensity, TempoStart, TempoEnd, Achieved, Reps, Errors
FROM dbo.PracticeSessions
WHERE UserId=@UserId AND InstrumentId=@InstrumentId
ORDER BY PracticeDate DESC, SessionId DESC;
