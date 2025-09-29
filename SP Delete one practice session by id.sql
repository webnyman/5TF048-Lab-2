CREATE OR ALTER PROCEDURE dbo.usp_PracticeSession_Delete
  @SessionId INT,
  @UserId UNIQUEIDENTIFIER
AS
BEGIN
  SET NOCOUNT ON;
  SET XACT_ABORT ON;

  BEGIN TRY
    BEGIN TRAN;

      DELETE FROM dbo.PracticeSessions
      WHERE SessionId = @SessionId
        AND UserId    = @UserId;

      DECLARE @rc INT = @@ROWCOUNT;

      IF @rc = 0
        THROW 50001, 'PracticeSession not found or not owned by user.', 1;

    COMMIT;

    SELECT @rc AS RowsAffected;  -- 👈 DAL kan läsa via ExecuteScalar
  END TRY
  BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK;
    THROW;
  END CATCH
END
GO
