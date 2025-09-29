CREATE OR ALTER PROCEDURE dbo.usp_PracticeSession_Update
  @SessionId     INT,
  @UserId        UNIQUEIDENTIFIER,
  @InstrumentId  INT,
  @PracticeDate  DATE,
  @Minutes       INT,
  @Intensity     TINYINT,
  @Focus         NVARCHAR(200),
  @Comment       NVARCHAR(MAX) = NULL
AS
BEGIN
  SET NOCOUNT ON;
  SET XACT_ABORT ON;

  BEGIN TRY
    BEGIN TRAN;

      UPDATE dbo.PracticeSessions
      SET InstrumentId = @InstrumentId,
          PracticeDate = @PracticeDate,
          Minutes      = @Minutes,
          Intensity    = @Intensity,
          Focus        = @Focus,
          Comment      = @Comment
      WHERE SessionId = @SessionId
        AND UserId    = @UserId;

      DECLARE @rc INT = @@ROWCOUNT;

      IF @rc = 0
      BEGIN
        -- Ingen rad uppdaterades: fel SessionId eller fel UserId (”inte ägare”)
        ;THROW 50000, 'PracticeSession not found or not owned by user.', 1;
      END

    COMMIT;

    -- retur till C#: ExecuteScalar -> @rc
    SELECT @rc AS RowsAffected;
  END TRY
  BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK;
    THROW;
  END CATCH
END
GO
