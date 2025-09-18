-- Skapa två testusers
INSERT INTO dbo.Users (UserId, DisplayName, Email, CreatedAt)
VALUES
  ('11111111-1111-1111-1111-111111111111', 'NoFK', 'nofk@test.com', SYSDATETIME()),
  ('22222222-2222-2222-2222-222222222222', 'Cascade', 'cascade@test.com', SYSDATETIME());

-- Lägg till ett instrument om du inte har ett
INSERT INTO dbo.Instruments (Name, Family) VALUES (N'Flygelhorn', 'Brass');

-- Hämta instrument-id:t
SELECT * FROM dbo.Instruments;
