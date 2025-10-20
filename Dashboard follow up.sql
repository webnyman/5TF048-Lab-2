DECLARE @UserEmail NVARCHAR(256) = N'info@trumpet.se';

;WITH U AS (
  SELECT TOP 1 CAST(Id AS UNIQUEIDENTIFIER) AS UserId
  FROM dbo.AspNetUsers
  WHERE NormalizedEmail = UPPER(@UserEmail)
),
B AS (
  SELECT
      ps.*
  FROM dbo.PracticeSessions ps
  CROSS JOIN U
  JOIN dbo.Instruments i ON i.InstrumentId = ps.InstrumentId
  WHERE ps.UserId = U.UserId
    AND i.Name = N'Trumpet'
)
SELECT
    COUNT(*)                                         AS Pass,
    SUM(Minutes)                                     AS MinutesTotal,
    AVG(CAST(Minutes AS FLOAT))                      AS MinutesAvg,
    AVG(CAST(Errors AS FLOAT))                       AS ErrorsAvg,
    SUM(CASE WHEN Achieved = 1 THEN 1 ELSE 0 END)    AS GoalsAchieved,
    CAST(100.0 * SUM(CASE WHEN Achieved = 1 THEN 1 ELSE 0 END) / NULLIF(COUNT(*),0) AS DECIMAL(5,2)) AS GoalsAchievedPct,
    AVG(CAST(Mood AS FLOAT))                         AS MoodAvg,
    AVG(CAST(Energy AS FLOAT))                       AS EnergyAvg,
    AVG(CAST(FocusScore AS FLOAT))                   AS FocusScoreAvg
FROM B;

-- Fördelning per intensitet (1–5)
SELECT Intensity, COUNT(*) AS Pass, AVG(CAST(Minutes AS FLOAT)) AS MinutesAvg
FROM B
GROUP BY Intensity
ORDER BY Intensity;

-- Tempoökning per vecka (endast pass med tempo)
SELECT
    DATEADD(week, DATEDIFF(week, 0, PracticeDate), 0) AS WeekStart,
    AVG(CAST(TempoEnd - TempoStart AS FLOAT)) AS AvgDeltaTempo,
    COUNT(*) AS PassWithTempo
FROM B
WHERE TempoStart IS NOT NULL AND TempoEnd IS NOT NULL
GROUP BY DATEADD(week, DATEDIFF(week, 0, PracticeDate), 0)
ORDER BY WeekStart;
