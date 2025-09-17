CREATE OR ALTER PROCEDURE dbo.usp_Tag_Update
  @TagId INT,
  @Name  NVARCHAR(100)
AS
BEGIN
  SET NOCOUNT ON;
  SET XACT_ABORT ON;

  BEGIN TRY
    BEGIN TRAN;

      UPDATE dbo.Tag
      SET Name = @Name
      WHERE TagId = @TagId;

      IF @@ROWCOUNT = 0
      BEGIN
        ;THROW 50002, 'Tag not found.', 1;
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
EXEC dbo.usp_Tag_Update @TagId=1, @Name=N'Teknisk träning';
SELECT * FROM dbo.Tag WHERE TagId=1;

