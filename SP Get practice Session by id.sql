CREATE OR ALTER PROCEDURE dbo.usp_GetPracticeSessionById
  @SessionId INT
AS
BEGIN
  SET NOCOUNT ON;
  SELECT SessionId, InstrumentId, PracticeDate, Minutes, Intensity, Focus, Comment
  FROM dbo.PracticeSessions
  WHERE SessionId = @SessionId;
END
