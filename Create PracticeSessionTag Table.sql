CREATE TABLE dbo.PracticeSessionTag (
    SessionId INT NOT NULL,
    TagId     INT NOT NULL,

    CONSTRAINT PK_PracticeSessionTag PRIMARY KEY (SessionId, TagId),

    CONSTRAINT FK_PST_PracticeSessions
        FOREIGN KEY (SessionId) REFERENCES dbo.PracticeSessions(SessionId)
        ON DELETE CASCADE,

    CONSTRAINT FK_PST_Tag
        FOREIGN KEY (TagId) REFERENCES dbo.Tag(TagId)
        ON DELETE CASCADE
);
