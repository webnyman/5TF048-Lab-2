-- Description: Query to retrieve practice sessions with their associated instruments and tags

SELECT ps.SessionId, ps.PracticeDate, i.Name AS Instrument, t.Name AS Tag
FROM dbo.PracticeSessions ps
JOIN dbo.Instruments i ON i.InstrumentId = ps.InstrumentId
LEFT JOIN dbo.PracticeSessionTag pst ON pst.SessionId = ps.SessionId
LEFT JOIN dbo.Tag t ON t.TagId = pst.TagId
ORDER BY ps.SessionId, t.Name;
