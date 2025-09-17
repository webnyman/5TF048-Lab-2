CREATE OR ALTER VIEW dbo.v_MinutesByInstrument AS
SELECT
  ps.UserId,
  i.Name AS Instrument,
  SUM(ps.Minutes) AS TotalMinutes
FROM dbo.PracticeSessions ps
JOIN dbo.Instruments i ON i.InstrumentId = ps.InstrumentId
GROUP BY ps.UserId, i.Name;
