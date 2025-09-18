--- Delete one practice session by its ID
DELETE FROM dbo.PracticeSessions
WHERE SessionId = 2;
-- Verify deletion
SELECT * FROM dbo.PracticeSessions WHERE SessionId = 2;
-- End of script