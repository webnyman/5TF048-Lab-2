CREATE OR ALTER PROCEDURE dbo.usp_SearchPracticeSessions
  @Query       NVARCHAR(200) = NULL,    -- sök i Focus
  @InstrumentId INT          = NULL,    -- filtrera på instrument
  @Sort        NVARCHAR(20)  = 'date',  -- 'date' | 'minutes' | 'intensity'
  @Desc        BIT           = 1,       -- fallande?
  @Page        INT           = 1,
  @PageSize    INT           = 10
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH base AS (
      SELECT ps.SessionId, ps.PracticeDate, ps.Minutes, ps.Intensity, ps.Focus,
             i.InstrumentId, i.Name AS InstrumentName
      FROM dbo.PracticeSessions ps      -- OBS: matcha ditt verkliga tabellnamn
      JOIN dbo.Instruments i ON i.InstrumentId = ps.InstrumentId
      WHERE (@Query IS NULL OR ps.Focus LIKE N'%' + @Query + N'%')
        AND (@InstrumentId IS NULL OR ps.InstrumentId = @InstrumentId)
  )
  SELECT TOP (@PageSize)
         SessionId, PracticeDate, Minutes, Intensity, Focus, InstrumentId, InstrumentName
  FROM base
  ORDER BY
    CASE WHEN @Sort='minutes'   AND @Desc=0 THEN Minutes      END ASC,
    CASE WHEN @Sort='minutes'   AND @Desc=1 THEN Minutes      END DESC,
    CASE WHEN @Sort='intensity' AND @Desc=0 THEN Intensity    END ASC,
    CASE WHEN @Sort='intensity' AND @Desc=1 THEN Intensity    END DESC,
    CASE WHEN (@Sort IS NULL OR @Sort='date') AND @Desc=0 THEN PracticeDate END ASC,
    CASE WHEN (@Sort IS NULL OR @Sort='date') AND @Desc=1 THEN PracticeDate END DESC,
    SessionId DESC; -- stabil sekundär sort
END
GO
