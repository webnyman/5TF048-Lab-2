/* ============================
   PRACTICELOGGER – USERID AUDIT
   Databas: Lab2
   ============================ */
USE Lab2;
SET NOCOUNT ON;

/* 0) Snabb koll */
SELECT DB_NAME() AS CurrentDb;
SELECT TOP 1 * FROM sys.tables; -- driver cache

/* 1) Kolumn & datatyp */
SELECT 
    t.name  AS TableName,
    c.name  AS ColumnName,
    ty.name AS DataType,
    c.max_length,
    c.is_nullable
FROM sys.columns c
JOIN sys.tables t   ON t.object_id = c.object_id
JOIN sys.types ty   ON ty.user_type_id = c.user_type_id
WHERE t.name = 'PracticeSessions'
  AND c.name IN ('UserId','SessionId','InstrumentId','PracticeDate','Minutes','Intensity','Focus','Comment')
ORDER BY c.column_id;

/* 2) Finns NULL-värden i UserId? */
SELECT 
    TotalRows      = COUNT(*),
    NullUserIdRows = SUM(CASE WHEN UserId IS NULL THEN 1 ELSE 0 END)
FROM dbo.PracticeSessions;

/* 3) Orphans: sessioner vars UserId inte finns i AspNetUsers */
SELECT ps.SessionId, ps.UserId, ps.PracticeDate, ps.Minutes
FROM dbo.PracticeSessions ps
LEFT JOIN dbo.AspNetUsers u ON u.Id = ps.UserId
WHERE u.Id IS NULL;

/* 4) Finns FK från PracticeSessions(UserId) -> AspNetUsers(Id)? */
SELECT 
    fk.name               AS FK_Name,
    ParentTable           = OBJECT_NAME(fk.parent_object_id),
    ParentColumn          = pc.name,
    ReferencedTable       = OBJECT_NAME(fk.referenced_object_id),
    ReferencedColumn      = rc.name,
    fk.delete_referential_action_desc AS OnDelete
FROM sys.foreign_keys fk
JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
JOIN sys.columns pc ON pc.column_id = fkc.parent_column_id AND pc.object_id = fk.parent_object_id
JOIN sys.columns rc ON rc.column_id = fkc.referenced_column_id AND rc.object_id = fk.referenced_object_id
WHERE OBJECT_NAME(fk.parent_object_id) = 'PracticeSessions'
  AND OBJECT_NAME(fk.referenced_object_id) = 'AspNetUsers';

/* 5) Index: finns (UserId) och/eller (UserId, PracticeDate)? */
;WITH Idx AS (
    SELECT 
        i.name, i.is_unique, i.is_primary_key, ic.index_id, i.object_id,
        Cols = STRING_AGG(c.name, ',') WITHIN GROUP (ORDER BY ic.key_ordinal)
    FROM sys.indexes i
    JOIN sys.index_columns ic ON ic.object_id = i.object_id AND ic.index_id = i.index_id
    JOIN sys.columns c ON c.object_id = ic.object_id AND c.column_id = ic.column_id
    WHERE i.object_id = OBJECT_ID('dbo.PracticeSessions') AND i.is_hypothetical = 0
    GROUP BY i.name, i.is_unique, i.is_primary_key, ic.index_id, i.object_id
)
SELECT name AS IndexName, is_unique AS IsUnique, is_primary_key AS IsPrimaryKey, Cols
FROM Idx
ORDER BY IsPrimaryKey DESC, name;

/* 6) CHECK-constraints: Minutes 1..600, Intensity 1..5 (om du vill verifiera) */
SELECT 
    cc.name AS CheckName, t.name AS TableName, cc.definition
FROM sys.check_constraints cc
JOIN sys.tables t ON t.object_id = cc.parent_object_id
WHERE t.name = 'PracticeSessions';

/* 7) Stored Procedures som refererar PracticeSessions */
SELECT 
    s.name   AS SchemaName,
    o.name   AS ProcName,
    m.definition
FROM sys.objects o
JOIN sys.sql_modules m ON m.object_id = o.object_id
JOIN sys.schemas s ON s.schema_id = o.schema_id
WHERE o.type = 'P'
  AND m.definition LIKE '%PracticeSessions%';

/* 7a) SP:ar som nämner PracticeSessions MEN INTE @UserId (heuristik – manuellt granska) */
SELECT 
    s.name   AS SchemaName,
    o.name   AS ProcName
FROM sys.objects o
JOIN sys.sql_modules m ON m.object_id = o.object_id
JOIN sys.schemas s ON s.schema_id = o.schema_id
WHERE o.type = 'P'
  AND m.definition LIKE '%PracticeSessions%'
  AND m.definition NOT LIKE '%@UserId%';

/* 8) Vyer som refererar PracticeSessions (kontrollera att de filtrerar per användare om relevant) */
SELECT 
    v = OBJECT_SCHEMA_NAME(referencing_id) + '.' + OBJECT_NAME(referencing_id),
    referenced_entity_name,
    referenced_id
FROM sys.sql_expression_dependencies
WHERE referenced_id = OBJECT_ID('dbo.PracticeSessions');

/* 9) Snabb-preview på senaste sessions (för ögonkoll) */
SELECT TOP 20 ps.SessionId, ps.UserId, u.Email, ps.PracticeDate, ps.Minutes, ps.Intensity, ps.Focus
FROM dbo.PracticeSessions ps
LEFT JOIN dbo.AspNetUsers u ON u.Id = ps.UserId
ORDER BY ps.SessionId DESC;
