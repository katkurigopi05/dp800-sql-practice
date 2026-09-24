-- This file contains SQL statements that will be executed after the build script.
--DELETE FROM [dbo].[tblTest]
-- id IN (-1,-2);
-- INTO [dbo].[tblTest] (id,Description) values (-1,'This is a Test record');
--INSERT INTO [dbo].[tblTest] (id,Description) values (-2,'This is another test record');
--MERGE INTO [dbo].[tblTest]
-- AS Target
--USING (VALUES (-1, 'This is a Test record'), (-2, 'This is another test record')) AS Source(id, Description) ON Target.id = Source.id
--WHEN MATCHED THEN UPDATE 
--SET Description = Source.Description
--WHEN NOT MATCHED THEN INSERT (
--id,
--Description
--) VALUES (Source.id, Source.Description);
CREATE TABLE [dbo].[tblTest] (
    [id]          INT            NOT NULL PRIMARY KEY,
    [Description] NVARCHAR (100) NOT NULL,
    [Note]        NVARCHAR (100) NULL
);