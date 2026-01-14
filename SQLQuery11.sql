SELECT
    c.name,
    t.name AS Type
FROM sys.columns c
JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('dbo.RecordingSession')
  AND c.name = 'UserId';
