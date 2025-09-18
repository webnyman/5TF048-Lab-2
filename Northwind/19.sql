--- Uppgift 19
SELECT ProductID,
       ProductName,
       UnitPrice AS [Gamla priset],
       UnitPrice * 1.20 AS [Nya priset]
FROM Products
WHERE CategoryID = 4;
