CREATE OR ALTER VIEW dbo.v_PracticeSessions_Expanded AS
SELECT
  ps.SessionId,
  ps.UserId,
  u.DisplayName,
  ps.InstrumentId,
  i.Name AS Instrument,
  ps.PracticeDate,
  ps.Minutes,
  ps.Intensity,
  ps.Focus,
  ps.Comment
FROM dbo.PracticeSessions ps
JOIN dbo.Users u       ON u.UserId       = ps.UserId
JOIN dbo.Instruments i ON i.InstrumentId = ps.InstrumentId;
