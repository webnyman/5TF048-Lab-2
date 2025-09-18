RESTORE DATABASE Northwind
FROM DISK = 'C:\Northwind\Northwinddatabasen\Northwind.bak'
WITH MOVE 'Northwind' TO 'C:\Northwind\Northwinddatabasen\Northwind.mdf',
	 MOVE 'Northwind_Log' TO 'C:\Northwind\Northwinddatabasen\Northwind_log.ldf';
