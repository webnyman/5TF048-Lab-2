CREATE OR ALTER VIEW dbo.v_DailyTotals AS
SELECT
  ps.UserId,
  ps.PracticeDate,
  SUM(ps.Minutes) AS TotalMinutes,
  AVG(CAST(ps.Intensity AS float)) AS AvgIntensity
FROM dbo.PracticeSessions ps
GROUP BY ps.UserId, ps.PracticeDate;
