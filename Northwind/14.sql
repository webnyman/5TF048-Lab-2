--- Uppgift 14
SELECT DISTINCT s.SupplierID,
       s.CompanyName,
       p.ProductID,
       p.ProductName
FROM [Order Details] od
JOIN Products p ON od.ProductID = p.ProductID
JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE od.OrderID = 10249;
