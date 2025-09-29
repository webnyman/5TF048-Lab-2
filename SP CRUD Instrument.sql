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
  SET NOCOUNT ON;
  INSERT INTO dbo.Instruments(Name, Family) VALUES(@Name, @Family);
  SELECT CAST(SCOPE_IDENTITY() AS int) AS NewInstrumentId;
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
    BEGIN TRAN;

    UPDATE dbo.Instruments
    SET Name = @Name, Family = @Family
    WHERE InstrumentId = @InstrumentId;

    DECLARE @rc INT = @@ROWCOUNT;

    IF @rc = 0
      THROW 50020, 'Instrument not found.', 1;

    COMMIT;

    SELECT @rc AS RowsAffected;
  END TRY
  BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK;
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
    BEGIN TRAN;

    DELETE FROM dbo.Instruments
    WHERE InstrumentId = @InstrumentId;

    DECLARE @rc INT = @@ROWCOUNT;

    IF @rc = 0
      THROW 50021, 'Instrument not found.', 1;

    COMMIT;

    SELECT @rc AS RowsAffected;
  END TRY
  BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK;
    THROW;
  END CATCH
END
GO

