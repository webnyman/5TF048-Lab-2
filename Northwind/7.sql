--- Uppgift 7
SELECT LastName, FirstName, Extension
FROM Employees
WHERE Title LIKE '%Vice%'
   OR Title LIKE '%President%'
   OR Title LIKE '%Manager%';

