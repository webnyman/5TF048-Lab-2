CREATE TABLE Instruments (
    InstrumentId INT IDENTITY(1,1) NOT NULL,   -- Auto-increment
    Name NVARCHAR(100) NOT NULL,               -- Instrumentnamn
    Family NVARCHAR(100) NULL,                 -- T.ex. Brass, Träblås, Slagverk

    CONSTRAINT PK_Instruments PRIMARY KEY (InstrumentId),
    CONSTRAINT UQ_Instruments_Name UNIQUE (Name)  -- Unikt namn per instrument
);
