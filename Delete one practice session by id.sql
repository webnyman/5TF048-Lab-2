--- Delete one practice session by its ID
DELETE FROM dbo.PracticeSessions
WHERE SessionId = 1;
-- Verify deletion
SELECT * FROM dbo.PracticeSessions WHERE SessionId = 1;
-- End of script