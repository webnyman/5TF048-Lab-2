--- Uppgift 13
SELECT s.SupplierID,
       s.CompanyName,
       p.ProductName
FROM Products p
JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE p.ProductName = 'Gravad lax';

