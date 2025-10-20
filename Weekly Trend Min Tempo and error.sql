DECLARE @UserEmail NVARCHAR(256) = N'info@trumpet.se';

;WITH U AS (
  SELECT TOP 1 CAST(Id AS UNIQUEIDENTIFIER) AS UserId
  FROM dbo.AspNetUsers
  WHERE NormalizedEmail = UPPER(@UserEmail)
),
B AS (
  SELECT
      ps.PracticeDate
    , DATEADD(week, DATEDIFF(week, 0, ps.PracticeDate), 0) AS WeekStart  -- måndag kl 00:00
    , ps.Minutes
    , ps.Errors
    , ps.TempoStart
    , ps.TempoEnd
    , CAST(CASE WHEN ps.TempoStart IS NOT NULL AND ps.TempoEnd IS NOT NULL
                THEN ps.TempoEnd - ps.TempoStart END AS INT) AS DeltaTempo
  FROM dbo.PracticeSessions ps
  CROSS JOIN U
  JOIN dbo.Instruments i ON i.InstrumentId = ps.InstrumentId
  WHERE ps.UserId = U.UserId
    AND i.Name = N'Trumpet'
),
W AS (
  SELECT
      WeekStart
    , COUNT(*)                      AS Pass
    , SUM(Minutes)                  AS MinutesTotal
    , AVG(CAST(Minutes AS FLOAT))   AS MinutesAvg
    , AVG(CAST(Errors  AS FLOAT))   AS ErrorsAvg
    , AVG(CAST(DeltaTempo AS FLOAT)) AS DeltaTempoAvg
  FROM B
  GROUP BY WeekStart
)
SELECT
    WeekStart,
    Pass,
    MinutesTotal,
    MinutesAvg,
    ErrorsAvg,
    DeltaTempoAvg,
    -- rullande 4-veckors snitt (trend)
    AVG(MinutesAvg)    OVER (ORDER BY WeekStart ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS MinutesAvg_Roll4,
    AVG(ErrorsAvg)     OVER (ORDER BY WeekStart ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS ErrorsAvg_Roll4,
    AVG(DeltaTempoAvg) OVER (ORDER BY WeekStart ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS DeltaTempoAvg_Roll4
FROM W
ORDER BY WeekStart;
