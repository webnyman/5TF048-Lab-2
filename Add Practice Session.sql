-- Hämta en user + instrument
SELECT TOP 1 UserId FROM dbo.Users;
SELECT TOP 1 InstrumentId FROM dbo.Instruments;

-- Lägg till en övningssession
INSERT INTO dbo.PracticeSessions (UserId, InstrumentId, PracticeDate, Minutes, Intensity, Focus, Comment)
VALUES ('22222222-2222-2222-2222-222222222222', 1, '2025-09-17', 45, 4, 'Teknik', 'Bra Fokus');
