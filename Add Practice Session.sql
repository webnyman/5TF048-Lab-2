-- Hämta en user + instrument
SELECT TOP 1 UserId FROM dbo.Users;
SELECT TOP 1 InstrumentId FROM dbo.Instruments;

-- Lägg till en övningssession
INSERT INTO dbo.PracticeSessions (UserId, InstrumentId, PracticeDate, Minutes, Intensity, Focus, Comment)
VALUES ('8F534638-6E25-4310-81CA-AB284F796E59', 1, '2025-09-16', 45, 4, 'Skalor och etyder', 'Bra fokus idag!');
