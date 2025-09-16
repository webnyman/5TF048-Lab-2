CREATE TABLE Users (
    UserId UNIQUEIDENTIFIER NOT NULL 
        DEFAULT NEWID(),           -- Genererar GUID automatiskt
    Email NVARCHAR(256) NOT NULL, -- Unik e-post
    DisplayName NVARCHAR(128) NOT NULL,
    CreatedAt DATETIME2 NOT NULL 
        DEFAULT SYSUTCDATETIME(), -- Timestamp

    CONSTRAINT PK_Users PRIMARY KEY (UserId),
    CONSTRAINT UQ_Users_Email UNIQUE (Email)
);
