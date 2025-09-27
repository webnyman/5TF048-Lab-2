CREATE OR ALTER PROCEDURE dbo.usp_SearchPracticeSessions
  @Query NVARCHAR(200) = NULL,      -- sök i Focus
  @InstrumentId INT = NULL,         -- filtrera på instrument
  @Sort NVARCHAR(20) = 'date',      -- 'date' | 'minutes' | 'intensity'
  @Desc BIT = 1,                    -- fallande?
  @Page INT = 1,
  @PageSize INT = 10
AS
BEGIN
  SET NOCOUNT ON;

  -- välj fält att sortera på (whitelist för säkerhet)
  DECLARE @OrderBy NVARCHAR(50) =
    CASE LOWER(@Sort)
      WHEN 'minutes' THEN 'ps.Minutes'
      WHEN 'intensity' THEN 'ps.Intensity'
      ELSE 'PracticeDate'
    END + CASE WHEN @Desc=1 THEN ' DESC' ELSE ' ASC' END;

  ;WITH base AS (
    SELECT ps.SessionId, ps.PracticeDate, ps.Minutes, ps.Intensity, ps.Focus,
           i.InstrumentId, i.Name AS InstrumentName
    FROM dbo.PracticeSessions ps
    JOIN dbo.Instruments i ON i.InstrumentId = ps.InstrumentId
    WHERE (@Query IS NULL OR ps.Focus LIKE '%' + @Query + '%')
      AND (@InstrumentId IS NULL OR ps.InstrumentId = @InstrumentId)
  ),
  ranked AS (
    SELECT *, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn_dummy -- placeholder
    FROM base
  )
  -- smart trick: bygg dynamisk ORDER BY via temp-tabell
  SELECT TOP (@PageSize) *
  FROM base
  ORDER BY
    CASE WHEN @OrderBy LIKE 'PracticeDate%' THEN PracticeDate END,
    CASE WHEN @OrderBy LIKE 'Minutes%'      THEN Minutes      END,
    CASE WHEN @OrderBy LIKE 'Intensity%'    THEN Intensity    END;

  -- total count
  SELECT COUNT(*) FROM base;
END
