CREATE OR ALTER PROCEDURE dbo.usp_PracticeSession_Create
    @UserId UNIQUEIDENTIFIER,
    @InstrumentId INT,
    @PracticeDate DATE,
    @Minutes INT,
    @Intensity TINYINT,
    @Focus NVARCHAR(200),
    @Comment NVARCHAR(MAX) = NULL,
    @NewSessionId INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRAN;

        INSERT INTO dbo.PracticeSessions
            (UserId, InstrumentId, PracticeDate, Minutes, Intensity, Focus, Comment)
        VALUES
            (@UserId, @InstrumentId, @PracticeDate, @Minutes, @Intensity, @Focus, @Comment);

        SET @NewSessionId = SCOPE_IDENTITY();

        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        THROW;
    END CATCH
END;

--- Test av SP, lägg till en ny practice session
DECLARE @NewId INT;

EXEC dbo.usp_PracticeSession_Create
    @UserId = '8F534638-6E25-4310-81CA-AB284F796E59',
    @InstrumentId = 1,
    @PracticeDate = '2025-09-17',
    @Minutes = 30,
    @Intensity = 4,
    @Focus = N'Skalor',
    @Comment = N'Bra pass',
    @NewSessionId = @NewId OUTPUT;

--- Kontrollera att posten lades till
SELECT @NewId AS NewSessionId;

SELECT * FROM dbo.PracticeSessions WHERE SessionId = @NewId;
