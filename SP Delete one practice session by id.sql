CREATE OR ALTER PROCEDURE dbo.usp_PracticeSession_Delete
  @SessionId INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON; -- gör att transaktionen rullas tillbaka automatiskt vid fel

    BEGIN TRY
        BEGIN TRAN;

        DELETE FROM dbo.PracticeSessions
        WHERE SessionId = @SessionId;

        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        THROW; -- bubbla upp felet så du ser varför det misslyckades
    END CATCH
END
GO

usp_PracticeSession_Delete 1