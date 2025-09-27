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
  @Name NVARCHAR(100),
  @Family NVARCHAR(50)
AS
BEGIN
  SET NOCOUNT ON;
  UPDATE dbo.Instruments SET Name=@Name, Family=@Family WHERE InstrumentId=@InstrumentId;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_Instruments_Delete
  @InstrumentId INT
AS
BEGIN
  SET NOCOUNT ON;
  DELETE FROM dbo.Instruments WHERE InstrumentId=@InstrumentId;
END
GO
