DROP TABLE IF EXISTS School.Scores
GO 

DROP TABLE IF EXISTS School.Pupils
GO 

DROP SCHEMA IF EXISTS School
GO

CREATE SCHEMA School
GO

CREATE TABLE School.Scores
(PupilID INT NOT NULL,
Score SMALLINT NOT NULL,
SetType VARCHAR(10),
DateTaken DATE NULL,
Maximum SMALLINT NULL,
DateRecorded DATETIME2(7) NULL
)
GO

INSERT INTO School.Scores(PupilID, SetType, Score, DateTaken)
VALUES (1, 'Math', 85, '2032-10-01'),
(2, 'Math', 90, '2032-10-01'),
(3, 'Math', 78, '2032-10-01'),
(4, 'Science', 92, '2032-10-01'),
(5, 'Science', 88, '2032-10-01'),
(6, 'Science', 80, '2032-10-01'),
(4, 'Math', 70, '2032-11-02'),
(5, 'Math',76, '2032-11-02'),
(7, 'Math',91, '2032-11-02'),
(1, 'Science',42, '2032-11-02'),
(2, 'Science',18, '2032-11-02'),
(3, 'Science',80, '2032-11-02');

ALTER TABLE School.Scores
ADD ScoresID int NOT NULL PRIMARY KEY IDENTITY

CREATE TABLE School.Pupils
(
    PupilID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    ClassID INT
);

INSERT INTO School.Pupils (PupilID, FirstName, LastName, ClassID)
VALUES
(1, 'Alice', 'Jones', 1),
(2, 'Bob', 'Taylor', 1),
(3, 'Charlie', 'Evans', 1),
(4, 'Daisy', 'Wilson', 2),
(5, 'Ethan', 'Thomas', 2),
(8, 'Fiona', 'Roberts', 3);
--Introducing the JSON data type


DECLARE @jsonDocument JSON = '{"Given name":"Gopi Krishna Reddy","Family name":"Katkuri","Eye color":"Brown","Skills":["SQL","PowerBI","Python"]}'
SELECT @jsonDocument AS JSONDocument


DECLARE @jsonDocument2 JSON ='{"Given name":"Jane","Middle name":"anne","Family name":"Doe"}'
SELECT @jsonDocument2 as JsonDocument


--14a-c. The JSON_OBJECT, JSON_ARRAY and JSON_ARRAYAGG functions
SELECT JSON_OBJECT('Given name':'Gopi Krishna Reddy','Family name':'Katkuri')
SELECT JSON_OBJECT('Given name':'Gopi Krishna Reddy','Family name':'Katkuri' RETURNING json)
SELECT JSON_OBJECT('Given name':'Gopi Krishna Reddy','Middle name': NULL,'Family name':'Katkuri' NULL ON NULL)
SELECT JSON_OBJECT('Given name':'Gopi Krishna Reddy','Middle name': NULL,'Family name':'Katkuri' ABSENT ON NULL)

DECLARE @jsondocument json =JSON_OBJECT('Given name':'Gopi Krishna Reddy','Family name':'Katkuri')
SELECT @jsondocument;


DECLARE @jsondocument json=JSON_ARRAY(JSON_OBJECT('Given name':'Gopi Krishna Reddy','Family name':'Katkuri'),JSON_OBJECT('Given name':'Jane','Family name':'Smith'))
SELECT @jsondocument;

SELECT PupilID,JSON_ARRAYAGG(SetType ORDER BY SetType) AS SetTypes
FROM School.Scores as S
GROUP BY PupilID
-- 14d. The JSON_CONTAINS function
DECLARE @jsondocument json = JSON_OBJECT('Given name':'Gopi Krishna Reddy','Family name':'Katkuri','Skills':JSON_ARRAY('SQL','Python','PowerBI'))
SELECT @jsondocument
SELECT JSON_CONTAINS(@jsondocument,'Gopi%','$."Given name"',1)

DECLARE @jsondocument2 json = JSON_OBJECT('Name': JSON_OBJECT('Given name':'Gopi Krishna Reddy','Family name':'Katkuri'))
SELECT @jsondocument2;
SELECT JSON_CONTAINS(@jsondocument2,'Gopi Krishna Reddy','$.Name."Given name"')

DECLARE @jsondocument3 json = JSON_ARRAY(
    JSON_OBJECT('Given name':'Gopi Krishna Reddy','Family name':'Katkuri'),
    JSON_OBJECT('Given name':'Jane','Family name':'Smith'))
SELECT @jsondocument3;
SELECT
JSON_CONTAINS(@jsondocument3,'Jane','$[*]."Given name"') AS ContainsGivenName;
--14e. The OPENJSON table-valued function
DECLARE @jsondocument json = JSON_OBJECT('Given name':'Gopi Krishna Reddy','Family name':'Katkuri')
SELECT @jsondocument
SELECT * FROM OPENJSON(@jsondocument)
GO
DECLARE @jsondocument json = JSON_ARRAY(JSON_OBJECT('Given name':'Gopi Krishna Reddy','Family name':'Katkuri'),JSON_OBJECT('Given name':'Jane','Family name':'Smith')
)
SELECT @jsondocument
SELECT * FROM OPENJSON(@jsondocument)
SELECT * FROM OPENJSON(@jsondocument) 
WITH (
    [Given name] nvarchar(100) '$."Given name"',
    [Family name] nvarchar(100) '$."Family name"'
)

--14f. The JSON_VALUE function

DECLARE @jsondocument json =JSON_OBJECT('Given name':'Gopi Krishna Reddy','Family name':'Katkuri','Height':186,'DOB':'2002-05-05'
)
SELECT @jsondocument
SELECT JSON_VALUE(@jsondocument,'$."Given name"')
SELECT JSON_VALUE(@jsondocument,'$."Height"')
SELECT JSON_VALUE(@jsondocument,'$."DOB"')
GO
DECLARE @jsondocument json =JSON_ARRAY(
    JSON_OBJECT('Given name':'Gopi Krishna Reddy','Family name':'Katkuri'),
    JSON_OBJECT('Given name':'Jane','Family name':'Smith')
)
SELECT @jsondocument
SELECT JSON_VALUE(@jsondocument,'$[0]."Given name"')


--Implementing JSON columns and indexes

DROP TABLE IF EXISTS [School].[PupilsCopy2]

CREATE TABLE [School].[PupilsCopy2] 
(
    [PupilID] INT NOT NULL PRIMARY KEY,
    [FirstName] NVARCHAR(50) NULL,
    [LastName] NVARCHAR(50) NULL,
    [ClassID] INT NULL
)
GO
INSERT INTO [School].[PupilsCopy2]
SELECT PupilID,FirstName,LastName,ClassID
FROM [School].[Pupils]
GO
SELECT * FROM [School].[PupilsCopy2]

ALTER TABLE [School].[PupilsCopy2]
ADD JSONNames JSON;
GO

UPDATE [School].[PupilsCopy2]
SET JSONNames=JSON_OBJECT('Given name':FirstName,'Family name':LastName);
GO
SELECT * FROM [School].[PupilsCopy2]
WHERE JSON_CONTAINS(JSONNames,'Fiona','$.*') = 1;
SELECT * FROM [School].[PupilsCopy2]
--WHERE JSON_VALUE(JSONNames,'$."Given name"')='Fiona';
WHERE JSON_VALUE(JSONNames,'$."Given name"')LIKE '%i%';

CREATE JSON INDEX idx_JSONNames on [School].[PupilsCopy2](JSONNames) -- SQL server 2025 onwards
SELECT JSON_VALUE(JSONNames,'$."Given name"')
FROM [School].[PupilsCopy2]

ALTER TABLE [School].[PupilsCopy2]
ADD GivenNameFromJson AS JSON_VALUE(JSONNames,'$."Given name"') PERSISTED
GO

CREATE INDEX idx_GivenName ON [School].[PupilsCopy2](GivenNameFromJson)

DROP INDEX idx_GivenName ON [School].[PupilsCopy2];
ALTER TABLE [School].[PupilsCopy2]
DROP COLUMN GivenNameFromJson;


ALTER TABLE [School].[PupilsCopy2]
ADD GivenNameFromJson AS  CAST(JSON_VALUE(JSONNames,'$."Given name"') AS NVARCHAR(50)) PERSISTED
GO

CREATE INDEX idx_GivenName ON [School].[PupilsCopy2](GivenNameFromJson)