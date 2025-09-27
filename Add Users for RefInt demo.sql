-- Skapa två testusers
INSERT INTO dbo.Users (UserId, DisplayName, Email, CreatedAt)
VALUES
  ('11111111-1111-1111-1111-111111111111', 'NoFK', 'nofk@test.com', SYSDATETIME()),
  ('22222222-2222-2222-2222-222222222222', 'Cascade', 'cascade@test.com', SYSDATETIME());

