--- Delete one User from the database
DELETE FROM Users
WHERE UserId = '22222222-2222-2222-2222-222222222222';
-- Verify the deletion
SELECT * FROM Users
WHERE UserId = '22222222-2222-2222-2222-222222222222'

