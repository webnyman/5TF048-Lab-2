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
    @UserId = '13392206-460D-4FBA-BB5C-88210BC1437A',
    @InstrumentId = 1,
    @PracticeDate = '2025-09-19',
    @Minutes = 30,
    @Intensity = 4,
    @Focus = N'Skalor',
    @Comment = N'Bra pass',
    @NewSessionId = @NewId OUTPUT;

--- Kontrollera att posten lades till
SELECT @NewId AS NewSessionId;

SELECT * FROM dbo.PracticeSessions WHERE SessionId = @NewId;
