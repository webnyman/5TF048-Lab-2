DECLARE @UserEmail NVARCHAR(256) = N'info@trumpet.se';

;WITH U AS (
  SELECT TOP 1 CAST(Id AS UNIQUEIDENTIFIER) AS UserId
  FROM dbo.AspNetUsers
  WHERE NormalizedEmail = UPPER(@UserEmail)
),
B AS (
  SELECT
      CAST(ps.TempoEnd - ps.TempoStart AS FLOAT) AS x,   -- DeltaTempo
      CAST(ps.Errors AS FLOAT)                   AS y
  FROM dbo.PracticeSessions ps
  CROSS JOIN U
  JOIN dbo.Instruments i ON i.InstrumentId = ps.InstrumentId
  WHERE ps.UserId = U.UserId
    AND i.Name = N'Trumpet'
    AND ps.TempoStart IS NOT NULL
    AND ps.TempoEnd   IS NOT NULL
    AND ps.Errors     IS NOT NULL
),
S AS (
  SELECT
      COUNT(*)               AS n,
      SUM(x)                 AS sumx,
      SUM(y)                 AS sumy,
      SUM(x*y)               AS sumxy,
      SUM(x*x)               AS sumx2,
      SUM(y*y)               AS sumy2
  FROM B
)
SELECT
    CASE 
      WHEN n < 2 THEN NULL
      ELSE (n*sumxy - sumx*sumy) / NULLIF(SQRT((n*sumx2 - sumx*sumx)*(n*sumy2 - sumy*sumy)),0)
    END AS PearsonR_DeltaTempo_vs_Errors
FROM S;
