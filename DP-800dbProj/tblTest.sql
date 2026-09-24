CREATE TABLE [dbo].[tblTest] (
    [id]          INT            NOT NULL PRIMARY KEY,
    [Description] NVARCHAR (200) NULL,
    [DateStart]   DATETIME       NULL,
    [IsCurrent]   BIT            NULL,
    [Notes]       NVARCHAR (100) NULL
);
