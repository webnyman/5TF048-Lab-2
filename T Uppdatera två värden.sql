DECLARE @SessionId INT = 2;  -- byt till en existerande session

BEGIN TRY
    BEGIN TRAN;

    -- 1) Uppdatera antalet minuter
    UPDATE dbo.PracticeSessions
    SET Minutes = Minutes + 15
    WHERE SessionId = @SessionId;

    -- 2) Försök sätta en ogiltig intensitet (bryter CHECK: måste vara 1–5)
    UPDATE dbo.PracticeSessions
    SET Intensity = 6
    WHERE SessionId = @SessionId;

    COMMIT; -- når vi bara om båda lyckas
    PRINT 'Transaktion COMMIT: båda uppdateringar sparade';
END TRY
BEGIN CATCH
    ROLLBACK; -- återställ om något fel inträffar
    PRINT 'Transaktion ROLLBACK: inga uppdateringar sparade';
END CATCH;

-- Kontrollera att värdena inte ändrats om rollback triggades
SELECT SessionId, Minutes, Intensity
FROM dbo.PracticeSessions
WHERE SessionId = @SessionId;
