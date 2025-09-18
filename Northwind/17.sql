--- Uppgift 17
SELECT p.ProductID,
       p.ProductName,
       c.CategoryName,
       SUM(od.Quantity) AS [Totalt_sålt]
FROM [Order Details] od
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY p.ProductID, p.ProductName, c.CategoryName
ORDER BY c.CategoryName, p.ProductName;
