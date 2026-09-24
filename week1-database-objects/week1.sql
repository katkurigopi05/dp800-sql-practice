-- ====================================================
-- WEEK 1: Design & implement database objects
--=====================================================
--1. Create a practice database (seperater from master)
CREATE DATABASE DP800Practice;
GO

USE DP800Practice;
GO

--2. Basic table with data types,constraints, and a Sequence
CREATE SEQUENCE OrderNumberSeq
start with 1000
increment by 1;
GO
create table Customers (
CustomerId INT PRIMARY KEY IDENTITY(1,1),
Email NVARCHAR(255) NOT NULL UNIQUE,
FULLNAME   NVARCHAR(100) not null,
LoyaltyTier NVARCHAR(20) DEFAULT 'Standard',
CreditLimit DECIMAL(10,2) CHECK(CreditLimit>=0),
CreatedAt DATETIME2 DEFAULT SYSDATETIME()
);
GO
CREATE TABLE Orders (
    OrderId         INT             PRIMARY KEY DEFAULT (NEXT VALUE FOR OrderNumberSeq),
    CustomerId      INT             NOT NULL FOREIGN KEY REFERENCES Customers(CustomerId),
    OrderTotal      DECIMAL(10,2)   NOT NULL,
    OrderDate       DATETIME2       DEFAULT SYSDATETIME()
);
GO


    
    
    -- Insert some test data
    INSERT INTO Customers(Email,FULLNAME,CreditLimit)
    VALUES
    ('Gopi@example.com','Gopi Krishna Reddy Katkuri',5000.00),
    ('jane@example.com','Jane Doe',3000.00);
    INSERT INTO Orders(CustomerId,OrderTotal)
    VALUES(1,149.99),(1,89.50),(2,220.00);
    Select * from Customers;
    select * from orders;
    Go

    -- 3. Indexes: nonclustered index on a frequently filtered column
CREATE NONCLUSTERED INDEX IX_Orders_CustomerId
    ON Orders (CustomerId);
GO
-- 4.JSON column Practice
ALTER TABLE Customers ADD Preferences NVARCHAR(MAX);
GO

UPDATE Customers
SET Preferences = N'{"newsletter": true, "theme": "dark", "notifications": ["email", "sms"]}'
WHERE CustomerId = 1;
GO
--Query into the JSON
SELECT
CustomerId,
JSON_VALUE(Preferences,'$.theme') as 'Theme',
JSON_QUERY(Preferences,'$.notifications') as 'Notifications'
FROM Customers
WHERE Preferences IS NOT NULL;
GO

-- 5. Temporal table (system-versioned) — tracks history automatically
CREATE TABLE Products (
    ProductId       INT             PRIMARY KEY IDENTITY(1,1),
    ProductName     NVARCHAR(100)   NOT NULL,
    Price           DECIMAL(10,2)   NOT NULL,
    ValidFrom       DATETIME2       GENERATED ALWAYS AS ROW START,
    ValidTo         DATETIME2       GENERATED ALWAYS AS ROW END,
    PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.ProductsHistory));
GO
INSERT INTO Products (ProductName, Price) VALUES ('Widget', 19.99);
GO


-- Change the price — old value gets archived automatically
UPDATE Products SET Price = 24.99 WHERE ProductId = 1;
GO


-- See current vs historical state
SELECT * FROM Products;                          -- current
SELECT * FROM Products FOR SYSTEM_TIME ALL;       -- current + history
GO


-- =====================================================
-- WEEK 1 / DAY 1 — Part 2: Specialized tables & constraints
-- (Continues from your Customers/Orders/JSON/Temporal setup)
-- =====================================================
USE DP800Practice;
GO
--=============================================
--6. LEDGER TABLE - tamper-evident,append-only
--=============================================
Create Table Auditlog (
LogId INT PRIMARY KEY IDENTITY(1,1),
ActionType NVARCHAR(50) NOT NULL,
PerformedBy NVARCHAR(100) not null,
ActionTime DATETIME2 DEFAULT SYSDATETIME()
)
with (ledger = on (append_only = on));
GO

INSERT INTO AuditLog (ActionType, PerformedBy)
VALUES ('LOGIN', 'gopi@example.com'), ('EXPORT_REPORT', 'jane@example.com');
GO
SELECT * FROM AuditLog;
GO


-- Try this — it should FAIL, proving append-only enforcement:
-- DELETE FROM AuditLog WHERE LogId = 1;

-- View the underlying ledger verification tables SQL Server generates:
SELECT * FROM sys.database_ledger_transactions;
GO




-- =========================================
-- 7. GRAPH TABLES — nodes and edges
-- =========================================
CREATE TABLE Person (
    PersonId    INT PRIMARY KEY,
    PersonName  NVARCHAR(100)
) AS NODE;
GO

CREATE TABLE Follows AS EDGE;
GO

INSERT INTO Person VALUES (1, 'Gopi'), (2, 'Jane'), (3, 'Alex');
GO

INSERT INTO Follows
SELECT $node_id FROM Person WHERE PersonId = 1,
       $node_id FROM Person WHERE PersonId = 2;

INSERT INTO Follows
SELECT $node_id FROM Person WHERE PersonId = 2,
       $node_id FROM Person WHERE PersonId = 3;
GO

-- MATCH query: who does Gopi follow, transitively?
SELECT Person2.PersonName AS Follows
FROM Person Person1, Follows, Person Person2
WHERE MATCH(Person1-(Follows)->Person2)
  AND Person1.PersonName = 'Gopi';
GO

-- =========================================
-- 8. CONSTRAINTS deep dive — test each one breaking
-- =========================================
CREATE TABLE ConstraintPractice (
    Id          INT PRIMARY KEY,
    Email       NVARCHAR(100) UNIQUE,
    Age         INT CHECK (Age >= 18),
    Status      NVARCHAR(20) DEFAULT 'Active',
    CategoryId  INT
);
GO

INSERT INTO ConstraintPractice (Id, Email, Age) VALUES (1, 'a@test.com', 25);
GO

-- Try each of these ONE AT A TIME and read the error message:
-- INSERT INTO ConstraintPractice (Id, Email, Age) VALUES (1, 'b@test.com', 30);      -- PK violation
-- INSERT INTO ConstraintPractice (Id, Email, Age) VALUES (2, 'a@test.com', 30);      -- UNIQUE violation
-- INSERT INTO ConstraintPractice (Id, Email, Age) VALUES (3, 'c@test.com', 15);      -- CHECK violation

-- Confirm DEFAULT worked without specifying Status:
SELECT * FROM ConstraintPractice;
GO


-- =========================================
-- 9. PARTITIONING — split a table by date range
-- =========================================
CREATE PARTITION FUNCTION OrderDateRangePF (DATETIME2)
AS RANGE RIGHT FOR VALUES ('2025-01-01', '2026-01-01');
GO

CREATE PARTITION SCHEME OrderDatePS
AS PARTITION OrderDateRangePF ALL TO ([PRIMARY]);
GO

CREATE TABLE OrdersPartitioned (
    OrderId     INT             NOT NULL,
    OrderDate   DATETIME2       NOT NULL,
    OrderTotal  DECIMAL(10,2)
) ON OrderDatePS (OrderDate);
GO

INSERT INTO OrdersPartitioned VALUES
    (1, '2024-06-15', 99.99),
    (2, '2025-06-15', 149.99),
    (3, '2026-06-15', 79.99);
GO

-- See which partition each row landed in:
SELECT
    OrderId, OrderDate,
    $PARTITION.OrderDateRangePF(OrderDate) AS PartitionNumber
FROM OrdersPartitioned;
GO
