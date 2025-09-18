--- Uppgift 10
SELECT ProductName,
       UnitsInStock,
       ReorderLevel
FROM Products
WHERE UnitsInStock < ReorderLevel;

