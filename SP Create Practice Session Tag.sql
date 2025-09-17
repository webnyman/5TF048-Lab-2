CREATE OR ALTER PROCEDURE dbo.usp_Tag_Create
    @Name NVARCHAR(100),
    @NewTagId INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRAN;

        -- Kolla om taggen redan finns
        SELECT @NewTagId = TagId
        FROM dbo.Tag
        WHERE Name = @Name;

        IF @NewTagId IS NULL
        BEGIN
            INSERT INTO dbo.Tag (Name) VALUES (@Name);
            SET @NewTagId = SCOPE_IDENTITY();
        END

        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        THROW;
    END CATCH
END;

--- Test av SP, lägg till en ny tag
DECLARE @NewTagId INT;
EXEC dbo.usp_Tag_Create
    @Name = N'Artikulation',
    @NewTagId = @NewTagId OUTPUT;
SELECT @NewTagId AS NewTagId;
-- Kontrollera att taggen lades till
SELECT * FROM dbo.Tag WHERE TagId = @NewTagId;


