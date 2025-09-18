--- Uppgift 16
-- Totalsumma för alla ordrar 1996-12-12
SELECT SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS [Total ordersumma]
FROM Orders o
JOIN [Order Details] od ON od.OrderID = o.OrderID
WHERE CONVERT(date, o.OrderDate) = '1996-12-12';
