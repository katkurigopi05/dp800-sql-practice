CREATE TABLE [dbo].[tblTest] (
    [id]          INT            NOT NULL PRIMARY KEY,
    [Description] NVARCHAR (101) NOT NULL,
    [DateEntry] DATETIME NULL,
    [IsCurrent] BIT NULL
);

SELECT *
FROM   [dbo].[tblTest];

ALTER TABLE dbo.tblTest
    ADD Notes NVARCHAR (100) NULL;

ALTER TABLE dbo.tblTest ALTER COLUMN Description NVARCHAR (200) NULL;
