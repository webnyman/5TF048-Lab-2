CREATE OR ALTER PROCEDURE dbo.usp_Instruments_GetAll
  @Query NVARCHAR(100) = NULL
AS
BEGIN
  SET NOCOUNT ON;
  SELECT InstrumentId, Name, Family
  FROM dbo.Instruments
  WHERE (@Query IS NULL OR Name LIKE '%'+@Query+'%' OR Family LIKE '%'+@Query+'%')
  ORDER BY Name;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_Instruments_GetById
  @InstrumentId INT
AS
BEGIN
  SET NOCOUNT ON;
  SELECT InstrumentId, Name, Family
  FROM dbo.Instruments
  WHERE InstrumentId = @InstrumentId;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_Instruments_Create
  @Name NVARCHAR(100),
  @Family NVARCHAR(50)
AS
BEGIN
  SET NOCOUNT ON; SET XACT_ABORT ON;
  BEGIN TRY
    INSERT INTO dbo.Instruments(Name, Family)
    VALUES(@Name, @Family);

    SELECT CAST(SCOPE_IDENTITY() AS NewInstrumentId
  END TRY
  BEGIN CATCH
    IF ERROR_NUMBER() = 2627  -- Unique constraint violation
    BEGIN
      ;THROW 50030, 'Instrument already exists.', 1;
    END
    ELSE
      THROW;
  END CATCH
END
GO


CREATE OR ALTER PROCEDURE dbo.usp_Instruments_Update
  @InstrumentId INT,
  @Name         NVARCHAR(100),
  @Family       NVARCHAR(50)
AS
BEGIN
  SET NOCOUNT ON; SET XACT_ABORT ON;

  BEGIN TRY
    UPDATE dbo.Instruments
    SET Name = @Name,
        Family = @Family
    WHERE InstrumentId = @InstrumentId;

    DECLARE @rc INT = @@ROWCOUNT;

    IF @rc = 0
      THROW 50040, 'Instrument not found.', 1;

    SELECT @rc AS RowsAffected;
  END TRY
  BEGIN CATCH
    IF ERROR_NUMBER() IN (2627,2601)
      THROW 50041, 'Instrument name must be unique.', 1;
    THROW;
  END CATCH
END
GO


CREATE OR ALTER PROCEDURE dbo.usp_Instruments_Delete
  @InstrumentId INT
AS
BEGIN
  SET NOCOUNT ON; SET XACT_ABORT ON;

  BEGIN TRY
    DELETE FROM dbo.Instruments
    WHERE InstrumentId = @InstrumentId;

    DECLARE @rc INT = @@ROWCOUNT;

    IF @rc = 0
      THROW 50042, 'Instrument not found.', 1;

    SELECT @rc AS RowsAffected;
  END TRY
  BEGIN CATCH
    -- FK-krock (instrumentet används i PracticeSessions)
    IF ERROR_NUMBER() IN (547)
      THROW 50043, 'Instrument is referenced by practice sessions.', 1;
    THROW;
  END CATCH
END
GO

