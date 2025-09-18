-- Lägg in en session kopplad till UserId '2222...'
INSERT INTO dbo.PracticeSessions (UserId, InstrumentId, PracticeDate, Minutes, Intensity, Focus)
VALUES ('22222222-2222-2222-2222-222222222222', 1, GETDATE(), 30, 3, N'Testpass');

-- Verifiera att sessionen finns
SELECT * FROM dbo.PracticeSessions WHERE UserId = '22222222-2222-2222-2222-222222222222';

-- Ta bort användaren (Cascade)
DELETE FROM dbo.Users WHERE UserId = '22222222-2222-2222-2222-222222222222';

-- Kontrollera sessionerna (ska vara tomt)
SELECT * FROM dbo.PracticeSessions WHERE UserId = '22222222-2222-2222-2222-222222222222';
