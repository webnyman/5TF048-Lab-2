CREATE OR ALTER PROCEDURE dbo.usp_PracticeSessions_Summary
  @InstrumentId INT = NULL  -- valfritt filter
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH base AS (
    SELECT ps.SessionId, ps.PracticeDate, ps.Minutes, ps.Intensity,
           i.Name AS InstrumentName
    FROM dbo.PracticeSessions ps
    JOIN dbo.Instruments i ON i.InstrumentId = ps.InstrumentId
    WHERE (@InstrumentId IS NULL OR ps.InstrumentId = @InstrumentId)
  )
  -- 1) totals: total minuter, distinkta dagar, antal pass
  SELECT
    SUM(b.Minutes)                      AS TotalMinutes,
    COUNT(DISTINCT b.PracticeDate)      AS DistinctDays,
    COUNT(*)                             AS EntriesCount
  FROM base b;

  -- 2) minuter per instrument (namn)
  SELECT b.InstrumentName, SUM(b.Minutes) AS Minutes
  FROM base b
  GROUP BY b.InstrumentName
  ORDER BY Minutes DESC, InstrumentName;

  -- 3) minuter per intensitet (1–5)
  SELECT b.Intensity, SUM(b.Minutes) AS Minutes
  FROM base b
  GROUP BY b.Intensity;
END
GO
