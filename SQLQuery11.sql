CREATE OR ALTER PROCEDURE dbo.usp_PracticeSessions_SummaryByIds
  @UserId UNIQUEIDENTIFIER,
  @Ids    dbo.IntIdList READONLY
AS
BEGIN
  SET NOCOUNT ON;

  CREATE TABLE #Base
  (
    SessionId      INT           NOT NULL,
    PracticeDate   DATE          NOT NULL,
    Minutes        INT           NOT NULL,
    Intensity      TINYINT       NOT NULL,
    InstrumentName NVARCHAR(100) NOT NULL,
    TempoStart     SMALLINT      NULL,
    TempoEnd       SMALLINT      NULL,
    Mood           TINYINT       NULL,
    Energy         TINYINT       NULL
  );

  INSERT INTO #Base (SessionId, PracticeDate, Minutes, Intensity, InstrumentName, TempoStart, TempoEnd, Mood, Energy)
  SELECT ps.SessionId, ps.PracticeDate, ps.Minutes, ps.Intensity, i.Name, ps.TempoStart, ps.TempoEnd, ps.Mood, ps.Energy
  FROM dbo.PracticeSessions ps
  JOIN dbo.Instruments i ON i.InstrumentId = ps.InstrumentId
  JOIN @Ids sel ON sel.Id = ps.SessionId
  WHERE ps.UserId = @UserId;

  -- Samma 1..6-resultset som i den vanliga summary-SP:n
END
