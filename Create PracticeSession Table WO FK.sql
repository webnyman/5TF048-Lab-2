-- Skapa tabell utan FK
CREATE TABLE dbo.PracticeSessions_NoFK (
    SessionId INT IDENTITY(1,1) PRIMARY KEY,
    UserId UNIQUEIDENTIFIER NOT NULL,
    InstrumentId INT NOT NULL,
    PracticeDate DATE NOT NULL,
    Minutes INT NOT NULL
);

-- Lägg in en session kopplad till UserId '1111...'
INSERT INTO dbo.PracticeSessions_NoFK (UserId, InstrumentId, PracticeDate, Minutes)
VALUES ('11111111-1111-1111-1111-111111111111', 1, GETDATE(), 45);

-- Ta bort användaren (NoFK)
DELETE FROM dbo.Users WHERE UserId = '11111111-1111-1111-1111-111111111111';

-- Kontrollera sessionerna (UserId finns inte längre i Users!)
SELECT * FROM dbo.PracticeSessions_NoFK;
