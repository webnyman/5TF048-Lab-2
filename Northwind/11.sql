--- Uppgift 11
SELECT ProductName,
       UnitsInStock,
       UnitsOnOrder,
       ReorderLevel
FROM Products
WHERE (UnitsInStock + UnitsOnOrder) < ReorderLevel;
