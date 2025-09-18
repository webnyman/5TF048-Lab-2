--- Uppgift 12
SELECT p.ProductName,
       c.CategoryID,
       c.CategoryName
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE p.ProductName = 'Lakkalikööri';
