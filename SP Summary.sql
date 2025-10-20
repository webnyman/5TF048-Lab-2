CREATE OR ALTER PROCEDURE dbo.usp_PracticeSessions_Summary
  @InstrumentId INT = NULL
AS
BEGIN
  SET NOCOUNT ON;

  CREATE TABLE #Base
  (
    SessionId      INT         NOT NULL,
    PracticeDate   DATE        NOT NULL,
    Minutes        INT         NOT NULL,
    Intensity      TINYINT     NOT NULL,
    InstrumentName NVARCHAR(100) NOT NULL
  );

  INSERT INTO #Base (SessionId, PracticeDate, Minutes, Intensity, InstrumentName)
  SELECT ps.SessionId, ps.PracticeDate, ps.Minutes, ps.Intensity, i.Name
  FROM dbo.PracticeSessions ps
  JOIN dbo.Instruments i ON i.InstrumentId = ps.InstrumentId
  WHERE (@InstrumentId IS NULL OR ps.InstrumentId = @InstrumentId);

  -- 1) totals
  SELECT
    COALESCE(SUM(Minutes), 0)                AS TotalMinutes,
    COALESCE(COUNT(DISTINCT PracticeDate),0) AS DistinctDays,
    COALESCE(COUNT(*), 0)                    AS EntriesCount
  FROM #Base;

  -- 2) minuter per instrument
  SELECT InstrumentName, SUM(Minutes) AS Minutes
  FROM #Base
  GROUP BY InstrumentName
  ORDER BY Minutes DESC, InstrumentName;

  -- 3) minuter per intensitet
  SELECT Intensity, SUM(Minutes) AS Minutes
  FROM #Base
  GROUP BY Intensity;
END
GO
