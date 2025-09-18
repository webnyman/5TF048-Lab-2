--- Uppgift 9
SELECT ProductName,
       UnitPrice,
       UnitsInStock,
       UnitPrice * UnitsInStock AS [Lager_värde]
FROM Products;

