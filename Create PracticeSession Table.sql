CREATE TABLE PracticeSessions (
    SessionId INT IDENTITY(1,1) NOT NULL,      -- Auto-increment PK
    UserId UNIQUEIDENTIFIER NOT NULL,          -- FK till Users
    InstrumentId INT NOT NULL,                 -- FK till Instruments
    PracticeDate DATE NOT NULL,                -- Datum för övning
    Minutes INT NOT NULL,                      -- Övningstid
    Intensity TINYINT NOT NULL,                -- 1–5
    Focus NVARCHAR(200) NOT NULL,              -- Vad man övade på
    Comment NVARCHAR(MAX) NULL,                -- Valfritt fält

    CONSTRAINT PK_PracticeSessions PRIMARY KEY (SessionId),

    -- Foreign Keys
    CONSTRAINT FK_PracticeSessions_Users FOREIGN KEY (UserId)
        REFERENCES Users(UserId) ON DELETE CASCADE,

    CONSTRAINT FK_PracticeSessions_Instruments FOREIGN KEY (InstrumentId)
        REFERENCES Instruments(InstrumentId),

    -- Check constraints för dataintegritet
    CONSTRAINT CK_PracticeSessions_Minutes CHECK (Minutes BETWEEN 1 AND 600),
    CONSTRAINT CK_PracticeSessions_Intensity CHECK (Intensity BETWEEN 1 AND 5)
);
