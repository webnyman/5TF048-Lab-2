--- Uppgift 20
SELECT ProductID,
       ProductName,
       CategoryID,
       UnitPrice AS [Gamla priset],
       UnitPrice * 1.05 AS [Nya priset]
FROM Products
WHERE CategoryID <> 4;
