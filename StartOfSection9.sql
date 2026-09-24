DROP TABLE IF EXISTS School.Scores;


GO
DROP TABLE IF EXISTS School.Pupils;

DROP TABLE IF EXISTS School.Scores
GO 

DROP SCHEMA IF EXISTS School
GO

CREATE SCHEMA School
GO

CREATE TABLE School.Scores
(PupilID INT NOT NULL,
Score SMALLINT NOT NULL,
SetType VARCHAR(10),
DateTaken DATE NULL
)
ALTER TABLE School.Scores
ALTER COLUMN SetType VARCHAR(10) NOT NULL;

INSERT INTO [School].[Scores] (PupilID, SetType, Score, DateTaken)
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
(3, 'Science',80, '2032-11-02')
ALTER TABLE School.Scores
    ADD ScoresID INT IDENTITY NOT NULL ;

CREATE TABLE School.Pupils (
    PupilID   INT          ,
    FirstName VARCHAR (50),
    LastName  VARCHAR (50),
    ClassID   INT         
);

INSERT  INTO School.Pupils (
    PupilID,
    FirstName,
    LastName,
    ClassID
)
VALUES                    (1, 'Alice', 'Jones', 1),
(2, 'Bob', 'Taylor', 1),
(3, 'Charlie', 'Evans', 1),
(4, 'Daisy', 'Wilson', 2),
(5, 'Ethan', 'Thomas', 2),
(8, 'Fiona', 'Roberts', 3);

--views
UPDATE School.Scores
SET    Maximum = COALESCE(Maximum, 100),
       DateRecorded = COALESCE(DateRecorded, SYSDATETIME())
WHERE  Maximum IS NULL
    OR DateRecorded IS NULL;

SELECT *
FROM   [School].[Scores];

DROP VIEW IF EXISTS [School].[vScoresMath];


GO
CREATE OR ALTER VIEW [School].[vScoresMath]
AS
SELECT *
FROM   [School].[Scores]
WHERE  SetType = 'Math';


GO
SELECT *
FROM   [School].[Scores];


GO
SELECT *
FROM   [School].[vScoresMath] AS GI;

SELECT *
FROM   [School].[Scores];

DROP VIEW IF EXISTS [School].[vScoresMath];


GO
CREATE OR ALTER VIEW [School].[vScoresMath]
AS
--SELECT *
SELECT *,
       Score * 100.0 / Maximum AS Percentage
FROM   [School].[Scores]
WHERE  SetType = 'Math';


GO
SELECT *
FROM   [School].[Scores];


GO
INSERT  INTO [School].[vScoresMath] (
    PupilID,
    Score,
    SetType,
    DateTaken,
    Maximum
)
VALUES                             (90, 90, 'Math', '2024-06-01', 100);

DELETE [School].[vScoresMath]
WHERE  pupilID = 90;

SELECT *
FROM   [School].[vScoresMath];

-- System views
SELECT *
FROM   sys.views;

SELECT *
FROM   sys.columns
WHERE  object_id = OBJECT_ID('School.vScoresMath');

SELECT *
FROM   sys.syscomments
WHERE  id = OBJECT_ID('School.vScoresMath');

SELECT *
FROM   sys.sql_expression_dependencies AS sed
WHERE  referencing_id = OBJECT_ID('School.vScoresMath');

SELECT *
FROM   [School].[Scores];

DROP VIEW IF EXISTS [School].[vScoresMath];


GO
CREATE OR ALTER VIEW [School].[vScoresMath]
AS
SELECT PupilID,
       Score,
       SetType,
       DateTaken,
       Maximum,
       DateRecorded
FROM   [School].[Scores]
WHERE  SetType = 'Math';


GO
SELECT   *
FROM     [School].[vScoresMath]
ORDER BY PupilID;

UPDATE School.Scores
SET    Maximum      = 100,
       DateRecorded = SYSDATETIME()
WHERE  Maximum IS NULL;


CREATE OR ALTER VIEW [School].[vScoresMath]
--WITH ENCRYPTION
--WITH SCHEMABINDING
--WITH VIEW_METADATA
AS 
SELECT * 
FROM [School].[Scores]
WHERE SetType = 'Math'
WITH CHECK OPTION 
GO

SELECT * 
FROM  [School].[vScoresMath] 

--7. Problems with INSERTing data into more complicated views
CREATE OR ALTER VIEW [School].[vScoresMath]
AS 
SELECT PupilID ,Score,SetType,DateTaken,Maximum,DateRecorded,ScoresID
FROM [School].[Scores]
WHERE SetType = 'Math'
WITH CHECK OPTION
GO
SELECT * FROM [School].[vScoresMath]
ORDER BY PupilID
GO


INSERT INTO[School].[vScoresMath](PupilID,Score,SetType,DateTaken,Maximum)
VALUES(90,90,'Math','2032-10-01',100)
GO


CREATE OR ALTER VIEW [School].[vScoresMath]
AS 
SELECT ISNULL(S.PupilID,P.PupilID)AS PupilID,--P.PupilID AS PupilIDFromPupils,S.PupilID AS PupilIDFromScores,
Score,SetType,DateTaken,Maximum,DateRecorded,ScoresID
FirstName,LastName,ClassID
FROM [School].[Scores] AS S
FULL JOIN [School].[Pupils] AS P
ON S.PupilID = P.PupilID
WHERE SetType = 'Math'
--WITH CHECK OPTION
GO
SELECT * FROM [School].[vScoresMath]
ORDER BY PupilID
GO

INSERT INTO[School].[vScoresMath](PupilIDFromScores,Score,SetType,DateTaken,Maximum,PupilIDFromPupils,FirstName,LastName,ClassID)
VALUES(90,90,'Math','2032-10-01',100,90,'Gopi','Reddy',6)
GO
--11. Creating an Instead of Insert Trigger

SELECT * FROM [School].[Pupils]
SELECT * FROM [School].[Scores]
SELECT * FROM [School].[PupilsCopy]

DROP TABLE[School].[PupilsCopy]
SELECT *
INTO[School].[PupilsCopy]
FROM School.Pupils;
SELECT * FROM School.PupilsCopy
GO
DELETE FROM [School].[Scores]
WHERE PupilID = 90
GO

CREATE OR ALTER VIEW[School].[vScoresMath]
AS
SELECT COALESCE(P.PupilID,S.PupilID) AS PupilID
Score, SetType,DateTaken,Maximum,DateRecorded,FirstName,LastName,ClassID
FROM [School].[Scores] AS S
FULL JOIN [School].[Pupils] AS P
ON S.PupilID = P.PupilID
WHERE SetType = 'Math'
GO
INSERT INTO [School].[vScoresMath]
(PupilID,Score,SetType,DateTaken,Maximum)
VALUES(90,90,'Math','2024-06-01',100,90)
UPDATE[School][vScoresMath]
SET Score = 95, FirstName='Jane',Lastname= 'Smith',ClassID =998
WHERE PupilID = 90
GO


SELECT * FROM[School].[vScoresMath]


CREATE OR ALTER TRIGGER School.trgInsertScoresMath
ON[School].[vScoresMath]
INSTEAD OF INSERT --,UPDATE,DELETE
AS
BEGIN
INSERT INTO School.Pupils(PupilID,FirstName,LastName,ClassID)
SELECT PupilID,FirstName,LastName,ClassID
FROM inserted
END
---Creating an Instead of Update Trigger
SELECT * FROM School.Pupils
GO
SELECT * FROM School.Scores
GO
DROP TABLE [School].[PupilsCopy]
SELECT * 
INTO [School].[PupilsCopy]
FROM School.Pupils
GO
SELECT * FROM School.PupilsCopy
DELETE FROM [School].[Scores] WHERE PupilID = 90
DELETE FROM [School].[Pupils] WHERE PupilID = 90
GO

CREATE OR ALTER VIEW[School].[vScoresMath]
AS
SELECT COALESCE(P.PupilID,S.PupilID) AS PupilID
Score, SetType,DateTaken,Maximum,DateRecorded,FirstName,LastName,ClassID
FROM [School].[Scores] AS S
FULL JOIN [School].[Pupils] AS P
ON S.PupilID = P.PupilID
WHERE SetType = 'Math'
GO

INSERT INTO [School].[vScoresMath](PupilId,Score,SetType,DateTaken,Maximum,FirstName,LastName,ClassID)
VALUES(90,90,'Math','2034-06-01',100,'John','Doe',999)

UPDATE [School].[vScoresMath]
SET Score = 95, FirstName='Jane',Lastname= 'Smith',ClassID =998
WHERE PupilID = 90
GO
SELECT * FROM [School].[vScoresMath]
GO
CREATE OR ALTER TRIGGER School.trgInsertScoresMath
ON [School].[vScoresMath]
INSTEAD OF INSERT
--WITH ENCRYPTION
AS
BEGIN
INSERT INTO School.Pupils(PupilID,FirstName,LastName,ClassID)
SELECT PupilID,FirstName,LastName,ClassID
FROM inserted
WHERE PupilID NOT IN(SELECT PupilID FROM School.Pupils);
INSERT INTO School.Scores(PupilID,Score,SetType,DateTaken,Maximum,DateRecorded)
SELECT PupilID,Score,SetType,DateTaken,Maximum,GETDATE()
FROM inserted
WHERE PupilID IS NOT NULL
END
CREATE OR ALTER TRIGGER School.trgUpdateScoresMath
ON [School].[vScoresMath]
INSTEAD OF UPDATE
AS
BEGIN
UPDATE P
SELECT P.FirstName=inserted.FirstName,
FROM inserted
END 
GO
CREATE OR ALTER TRIGGER School.trgDeletedScoresMath
ON [School].[vScoresMath]
INSTEAD OF DELETE 
AS
BEGIN
DELETE FROM School.Scores
WHERE PupilID IN (SELECT PupilID FROM deleted)
END


--Derived table
CREATE OR ALTER VIEW[School].[vScoresMath] AS
SELECT * FROM[School].[Scores]
WHERE SetType ='Math'
GO
SELECT * FROM [School].[Pupils]
SELECT * FROM [School].[vScoresMath]

--the FROM Clause
SELECT *
FROM School.Pupils AS P
--LEFT JOIN School.vScoresMath AS S
LEFT JOIN(SELECT * FROM [School].[Scores]--derived table from view
WHERE SetType ='Math') AS S
ON P.PupilID = S.PupilID

SELECT *
FROM School.Pupils AS P
WHERE PupilID IN(SELECT  FROM[School].[Scores]WHERE SetType='Math')
--The SELECT and WHERE Clauses
SELECT *, (SELECT AVG(Score) AS AverageScore --SUB QUERY requires SELECT STATEMENT
--SELECT AVG(Score) AS AverageScore
FROM[School].[Scores] AS S
WHERE SetType='Math') AS AverageScore
--WHERE SetType ='Math'
--FROM School.Pupils AS P
FROM [School].[vScoresMath] AS S
--WHERE Score > 81
WHERE Score > (SELECT AVG(Score) AS AverageScore--   
FROM [School].[Scores] AS S
WHERE SetType ='Math')



--Correlated subquery in the SELECT clause
CREATE OR ALTER VIEW[School].[vScoresMath] AS
SELECT * FROM [School].[Scores]
WHERE SetType ='Math'
GO
SELECT * FROM [School].[vScoresMath]
SELECT P.*,AVG(Score) AS AverageScore
FROM [School].Pupils AS P
LEFT JOIN [School].[vScoresMath] AS S
ON P.PupilID = S.PupilID 
GROUP BY P.PupilID,P.FirstName,P.LastName,P.ClassID      

SELECT *, (SELECT AVG(Score) FROM School.vScoresMath AS S  WHERE P.PupilID=S.PupilID) AS AverageScore
FROM [School].Pupils AS P


--Correlated column in the WHERE  
SELECT P.*
FROM [School].Pupils AS P
LEFT JOIN[School].[vScoresMath] AS S
ON P.PupilID =S.PupilID
WHERE S.Score>80

--WRITING SAME QUERY WITHOUT USING LEFT JOIN but using sub query with EXISTS statement correlated sub query in the WHERE  clause
SELECT *
FROM School.Pupils AS P
WHERE EXISTS(SELECT 1 FROM School.vScoresMath AS S WHERE P.PupilID = S.PupilID AND S.Score>80)

--Correlated column in the WHERE  
SELECT P.*
FROM [School].Pupils AS P
LEFT JOIN[School].[vScoresMath] AS S
ON P.PupilID =S.PupilID
WHERE S.Score>80

--WRITING SAME QUERY WITHOUT USING LEFT JOIN but using sub query with EXISTS statement correlated sub query in the WHERE  clause
SELECT *
FROM School.Pupils AS P
WHERE PupilID IN(SELECT PupilID FROM School.vScoresMath AS S WHERE  S.Score>80)