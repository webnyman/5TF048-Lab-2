CREATE OR ALTER PROCEDURE dbo.usp_PracticeSession_Update
  @SessionId     INT,
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
      WHERE SessionId  = @SessionId;

      IF @@ROWCOUNT = 0
      BEGIN
        -- Hittade inte posten
        ;THROW 50000, 'PracticeSession not found.', 1;
      END

    COMMIT;
  END TRY
  BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK;
    THROW;
  END CATCH
END
GO
--- Test av SP
EXEC dbo.usp_PracticeSession_Update
  @SessionId=3, @InstrumentId=2, @PracticeDate='2025-09-17',
  @Minutes=50, @Intensity=4, @Focus=N'Etyder', @Comment=N'Uppdaterad';

SELECT * FROM dbo.PracticeSessions WHERE SessionId=3;
