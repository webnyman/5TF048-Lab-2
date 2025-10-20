CREATE OR ALTER PROCEDURE dbo.usp_PracticeSession_Update
  @SessionId     INT,
  @UserId        UNIQUEIDENTIFIER,
  @InstrumentId  INT,
  @PracticeDate  DATE,
  @Minutes       INT,
  @Intensity     TINYINT,
  @Focus         NVARCHAR(200),
  @Comment       NVARCHAR(MAX) = NULL,
  @PracticeType  TINYINT = NULL,
  @Goal          NVARCHAR(200) = NULL,
  @Achieved      BIT = NULL,
  @Mood          TINYINT = NULL,
  @Energy        TINYINT = NULL,
  @FocusScore    TINYINT = NULL,
  @TempoStart    SMALLINT = NULL,
  @TempoEnd      SMALLINT = NULL,
  @Metronome     BIT = NULL,
  @Reps          SMALLINT = NULL,
  @Errors        SMALLINT = NULL
AS
BEGIN
  SET NOCOUNT ON; SET XACT_ABORT ON;
  BEGIN TRY
    BEGIN TRAN;
      UPDATE dbo.PracticeSessions
      SET InstrumentId = @InstrumentId,
          PracticeDate = @PracticeDate,
          Minutes      = @Minutes,
          Intensity    = @Intensity,
          Focus        = @Focus,
          Comment      = @Comment,
          PracticeType = @PracticeType,
          Goal         = @Goal,
          Achieved     = @Achieved,
          Mood         = @Mood,
          Energy       = @Energy,
          FocusScore   = @FocusScore,
          TempoStart   = @TempoStart,
          TempoEnd     = @TempoEnd,
          Metronome    = @Metronome,
          Reps         = @Reps,
          Errors       = @Errors
      WHERE SessionId = @SessionId AND UserId = @UserId;

      DECLARE @rc int = @@ROWCOUNT;
      IF @rc = 0 THROW 50000, 'PracticeSession not found or not owned by user.', 1;

      SELECT @rc AS RowsAffected;
    COMMIT;
  END TRY
  BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK; THROW;
  END CATCH
END
