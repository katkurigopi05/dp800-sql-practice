-- confirm which server you're on
SELECT @@VERSION AS [Version],
       DB_NAME() AS [Database],
       SUSER_NAME() AS [LoginAs];

-- top products by price
SELECT   TOP 10 Name,
                ProductNumber,
                ListPrice
FROM     SalesLT.Product
ORDER BY ListPrice DESC;

SELECT @@SERVERNAME AS ServerName,
       DB_NAME() AS CurrentDatabase;

SELECT   SCHEMA_NAME(schema_id) AS SchemaName,
         name AS TableName
FROM     sys.tables
ORDER BY SchemaName, TableName;

SELECT TOP (10) *
FROM   SalesLT.Customer;

SELECT TOP (10) *
FROM   School.Scores;

SELECT DB_NAME() AS CurrentDatabase;



SELECT DB_NAME() AS CurrentDatabase;

SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
ORDER BY TABLE_SCHEMA, TABLE_NAME;

SELECT TOP (100) *
FROM SalesLT.Customer;