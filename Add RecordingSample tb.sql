CREATE TABLE RecordingSample (
    RecordingSampleId INT IDENTITY(1,1) PRIMARY KEY,
    RecordingSessionId INT NOT NULL,
    SampleUtc DATETIME2 NOT NULL,
    Temperature DECIMAL(5,2) NULL,
    Humidity DECIMAL(5,2) NULL,
    SoundMean INT NULL,
    SoundMax INT NULL,

    CONSTRAINT FK_RecordingSample_RecordingSession
        FOREIGN KEY (RecordingSessionId)
        REFERENCES RecordingSession (RecordingSessionId)
        ON DELETE CASCADE
);
