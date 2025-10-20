IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_PracticeSessions_UserId' AND object_id=OBJECT_ID('dbo.PracticeSessions'))
  CREATE INDEX IX_PracticeSessions_UserId ON dbo.PracticeSessions(UserId);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_PracticeSessions_UserId_PracticeDate' AND object_id=OBJECT_ID('dbo.PracticeSessions'))
  CREATE INDEX IX_PracticeSessions_UserId_PracticeDate ON dbo.PracticeSessions(UserId, PracticeDate);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_PracticeSessions_InstrumentId' AND object_id=OBJECT_ID('dbo.PracticeSessions'))
  CREATE INDEX IX_PracticeSessions_InstrumentId ON dbo.PracticeSessions(InstrumentId);
