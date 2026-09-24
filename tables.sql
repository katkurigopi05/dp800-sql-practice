
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

SELECT * FROM [School].[Scores]
WHERE Score > 80;


-- DROP TABLE School.Scores;   -- disabled: this dropped the table, so every
--                              -- statement below failed with "Invalid object name".

ALTER TABLE School.Scores
ADD Gender CHAR(1) NULL;

UPDATE School.Scores
SET Gender = 'M'
WHERE PupilID = 4;

UPDATE School.Scores
SET Gender = 'F'
WHERE PupilID = 3;



UPDATE School.Scores
SET Gender = 'F'
WHERE PupilID = 1;


UPDATE School.Scores
SET Gender = 'F'
WHERE PupilID = 2;


UPDATE School.Scores
SET Gender = 'M'
WHERE PupilID = 5;

UPDATE School.Scores
SET Gender = 'M'
WHERE PupilID = 6;

UPDATE School.Scores
SET Gender = 'M'
WHERE PupilID = 7;



SELECT * FROM [School].[Scores]
WHERE Score > 80;

ALTER TABLE School.Scores
ALTER COLUMN SetType NVARCHAR(20) NOT NULL;


ALTER TABLE School.Scores
DROP COLUMN Gender;

SELECT * FROM School.Scores;

SELECT PupilID
FROM [School].[Scores]

--data Definition language (DDL) statements are used to define and modify database structures, Such as Tables, schemas, columns, data types, and indexes.   


ALTER TABLE School.Scores
ALTER COLUMN SetType NVARCHAR(15) NOT NULL;
GO

SELECT * FROM [School].[Scores];

INSERT INTO [School].[Scores] (PupilID, SetType, Score, DateTaken)
VALUES (8, 'Math', 85, '2032-10-01'),
(9, 'Math', 90, '2032-10-01'),
(10, 'Math', 78, '2032-10-01'),
(11, 'Science', 92, '2032-10-01'),
(12, 'Science', 88, '2032-10-01'),
(13, 'Science', 80, '2032-10-01'),
(14, 'Math', 70, '2032-11-02'),
(15, 'Math',76, '2032-11-02'),
(16, 'Math',91, '2032-11-02'),
(17, 'Science',42, '2032-11-02'),
(18, 'Science',18, '2032-11-02'),
(19, 'Science',80, '2032-11-02');

ALTER TABLE [School].[Scores]
DROP COLUMN DateTaken;

SELECT * FROM [School].[Scores];

ALTER TABLE [School].[Scores]
ADD DateTaken DATE NULL;

UPDATE [School].[Scores]
SET DateTaken ='2032-10-01'
WHERE PupilID =1;



UPDATE [School].[Scores]
SET DateTaken = '2032-10-01'
WHERE PupilID IN (2, 3, 7);


/* ---------------------------------------------------------------------
   Enforcing uniqueness two ways: a unique index, then the equivalent
   table constraint. Only one UQ_Scores can exist at a time, so each is
   dropped before the next is created.
   --------------------------------------------------------------------- */

-- Clean up whichever form a previous run left behind, so this section
-- can be re-run without "there is already an object named UQ_Scores".
IF EXISTS (SELECT 1
           FROM sys.key_constraints
           WHERE name = 'UQ_Scores'
             AND parent_object_id = OBJECT_ID('School.Scores'))
    ALTER TABLE [School].[Scores] DROP CONSTRAINT UQ_Scores;
GO

DROP INDEX IF EXISTS UQ_Scores ON [School].[Scores];
GO

-- Option 1: a unique index.
CREATE UNIQUE INDEX UQ_Scores
    ON [School].[Scores] (PupilID, Score, SetType, DateTaken);
GO

-- DROP INDEX works here because UQ_Scores is a standalone index.
DROP INDEX IF EXISTS UQ_Scores ON [School].[Scores];
GO

-- Option 2: the same rule as a table constraint.
ALTER TABLE [School].[Scores]
ADD CONSTRAINT UQ_Scores UNIQUE NONCLUSTERED (PupilID, Score, SetType, DateTaken);
GO

SELECT * FROM [School].[Scores];
GO


ALTER TABLE [School].[Scores]
ADD CONSTRAINT Ck_Scores CHECK(Score BETWEEN 0 AND 100)

INSERT INTO [School].[Scores](PupilID, Score,SetType,DateTaken)
VALUES(20, 105, 'Math', '2032-10-03');

DELETE FROM [School].[Scores] WHERE DateTaken ='2032-10-03';
GO

DROP TABLE IF EXISTS [School].[Scores3]
GO

DROP TABLE IF EXISTS [School].[Scores4]
GO


-- Constraints
CREATE TABLE [School].[Scores3] (
[PupilID][int] NOT NULL,
[Score][smallint] NOT NULL,
[SetType][nvarchar](10) NOT NULL,
[DateTaken][date] NULL,
CONSTRAINT UQ_Scores3 UNIQUE NONCLUSTERED (PupilID, SetType, DateTaken),
CONSTRAINT CK_SCORES3_Score CHECK (Score BETWEEN 0 AND 100) 
)
GO


--inline Constraints
CREATE TABLE [School].[Scores4]
(
    [PupilID] [int] NOT NULL,
    [Score][smallint] NOT NULL CHECK (Score BETWEEN 0 AND 100),
    [SetType][varchar](10) NOT NULL,
    [DateTaken][date] NULL UNIQUE NONCLUSTERED
    
    )
    GO



SELECT * FROM [School].[Scores];
ALTER TABLE [School].[Scores]
ADD CONSTRAINT ck2_Scores CHECK (Score BETWEEN 0 AND Maximum OR Score IS NULL);


ALTER TABLE [School].[Scores]
ADD Maximum smallint;

ALTER TABLE [School].[Scores]
NOCHECK CONSTRAINT CK2_Scores



UPDATE  [School].[Scores]
SET Maximum = 100;

INSERT INTO [School].[Scores](PupilID, Score, SetType, DateTaken)
VALUES(1,190,'Math','2032-10-03');



-- Note: now that UQ_Scores is a *constraint*, DROP INDEX no longer works on
-- it (error 3723 - the index enforces a UNIQUE KEY constraint). Remove it with:
-- ALTER TABLE [School].[Scores] DROP CONSTRAINT UQ_Scores;
SELECT * FROM[School].[Scores]
GO


---PRIMARY KEY is used as unique identifier for each record in a table and NOT NULL 


DROP TABLE IF EXISTS [School].[Scores3]
GO

CREATE TABLE [School].[Scores3]
(
    [PupilID][int] NOT NULL,
    [Score][smallint] NOT NULL,
    [SetType][varchar](10) NOT NULL,
    [DateTaken][date] NULL,
    ScoresID int NOT NULL,
    )
    GO


ALTER TABLE School.Scores3
ADD CONSTRAINT PK_Scores3 PRIMARY KEY CLUSTERED (ScoresID)
GO
INSERT INTO School.Scores3 (PupilID,SetType,Score,DateTaken,ScoresID)

VALUES(1,'Math',85,'2032-10-01',1),
      --(1,'Math',85,'2032-10-01',11), Violation of PRIMARY KEY constraint 'PK_Scores3'. Cannot insert duplicate key in object 'School.Scores3'. The duplicate key value is (11).
      (2,'Math',90,'2032-10-01',2),
      (3,'Math',78,'2032-10-01',3),
      (4,'Science',92,'2032-10-01',4),
      (5,'Science',88,'2032-10-01',5),
      (6,'Science',80,'2032-10-01',6),
      (4,'Math',70,'2032-11-02',7),
      (5,'Math',76,'2032-11-02',8),
      (7,'Math',91,'2032-11-02',9),
      (1,'Science',42,'2032-11-02',10),
      (2,'Science',18,'2032-11-02',11),
      (3,'Science',80,'2032-11-02',12)
      GO


SELECT * FROM[School].[Scores3]
GO

DROP TABLE IF EXISTS [School].[Scores3]
GO

CREATE TABLE [School].[Scores3]
(
    PupilID int NOT NULL,
    Score smallint NOT NULL,
    SetType varchar(10) NOT NULL,
    DateTaken date NULL,
    ScoresID int NOT NULL PRIMARY KEY,
    DateRecorded datetime2 NULL
)

GO

ALTER TABLE[School].[Scores3]
ADD CONSTRAINT DF_DateRecorded DEFAULT (GETDATE()) FOR DateRecorded
GO
INSERT INTO [School].[Scores3](PupilID,SetType,Score,DateTaken, ScoresID)
VALUES(1,'Math',85,'2032-10-01',1),
      (2,'Math',90,'2032-10-01',2),
      (3,'Math',78,'2032-10-01',3),
      (4,'Science',92,'2032-10-01',4),
      (5,'Science',88,'2032-10-01',5),
      (6,'Science',80,'2032-10-01',6),
      (4,'Math',70,'2032-11-02',7),
      (5,'Math',76,'2032-11-02',8),
      (7,'Math',91,'2032-11-02',9),
      (1,'Science',42,'2032-11-02',10),
      (2,'Science',18,'2032-11-02',11),
      (3,'Science',80,'2032-11-02',12)
      GO


SELECT * FROM [School].[Scores3]



DROP TABLE IF EXISTS [School].[Scores3]
GO
CREATE TABLE [School].[Scores3]
(
    PupilID int NOT NULL,
    Score Smallint NOT NULL,
    SetType varchar(10) NOT NULL,
    DateTaken date NULL,
    ScoresID int NOT NULL PRIMARY KEY,-- identity(1,1) --auto increment
    DateRecorded datetime2 NULL , --DEFAULT GETDATE ()
    
)
GO
ALTER TABLE [School].[Scores3]
ADD CONSTRAINT DF_DateRecorded DEFAULT (GETDATE()) FOR DateRecorded --DEFAULT ((GETDATE)) will get current date and time when the row is inserted (NOT WHEN THE ROW IS UPDATED)
GO
INSERT INTO [School].[Scores3](PupilID,SetType,Score,DateTaken, ScoresID)
VALUES(1,'Math',85,'2032-10-01',1),
      (2,'Math',90,'2032-10-01',2),
      (3,'Math',78,'2032-10-01',3),
      (4,'Science',92,'2032-10-01',4),
      (5,'Science',88,'2032-10-01',5),
      (6,'Science',80,'2032-10-01',6),
      (4,'Math',70,'2032-11-02',7),
      (5,'Math',76,'2032-11-02',8),
      (7,'Math',91,'2032-11-02',9),
      (1,'Science',42,'2032-11-02',10),
      (2,'Science',18,'2032-11-02',11),
      (3,'Science',80,'2032-11-02',12)
      
      GO
      SELECT * FROM [School].[Scores3]
      GO

      ---Sequence objects can be used to generate values for columns that require unique sequential numbers,  They are independent of tables and can be used by multiple tables.
      ---Sequence objects are created and managed using the CREATE SEQUENCE, ALTER SEQUENCE, and DROP SEQUENCE statements.  


DROP TABLE IF EXISTS School.Scores3
GO

DROP SEQUENCE IF EXISTS seqScoresID
GO

CREATE SEQUENCE seqScoresID AS INT
START WITH 1
INCREMENT BY 1
MINVALUE 1 
MAXVALUE 3
CYCLE 
CACHE 50

   
CREATE TABLE School.Scores3(
    PupilID int NOT NULL,
    Score smallint NOT NULL,
    SetType varchar(10) NOT NULL,
    DateTaken date NULL,
    ScoresID int NOT NULL CONSTRAINT DF_ScoresID DEFAULT NEXT VALUE FOR seqScoresID,--inline constaraint 
    DateRecorded datetime2 NULL DEFAULT GETDATE()
)

GO
CREATE TABLE School.Scores3
(
    PupilID int NOT NULL,
    Score smallint NOT NULL,
    SetType varchar(10) NOT NULL,
    DateTaken date NULL,
    ScoresID int NOT NULL,
    DateRecorded datetime2  DEFAULT GETDATE()
)
GO


ALTER TABLE School.Scores3
ADD CONSTRAINT DF_ScoresID DEFAULT NEXT VALUE FOR seqScoresID FOR ScoresID --or after creating a table we can create default constaraint using ALTER TABLE
GO



INSERT INTO [School].[Scores3](PupilID,SetType,Score,DateTaken, ScoresID)
VALUES(1,'Math',85,'2032-10-01',1),
      (2,'Math',90,'2032-10-01',2),
      (3,'Math',78,'2032-10-01',3),
      (4,'Science',92,'2032-10-01',4),
      (5,'Science',88,'2032-10-01',5),
      (6,'Science',80,'2032-10-01',6),
      (4,'Math',70,'2032-11-02',7),
      (5,'Math',76,'2032-11-02',8),
      (7,'Math',91,'2032-11-02',9),
      (1,'Science',42,'2032-11-02',10),
      (2,'Science',18,'2032-11-02',11),
      (3,'Science',80,'2032-11-02',12)
      
      GO

SELECT * FROM [School].[Scores3]
GO

SELECT * FROM sys.sequences
GO


UPDATE School.Scores3
SET ScoresID = NEXT VALUE FOR seqScoresID. --dont forget to run this performing above commands


SELECT PupilID, Score,SetType
FROM School.Scores3
WHERE PupilID = 2
GO

--joins 

DROP TABLE IF EXISTS School.Scores2
DROP TABLE IF EXISTS School.Scores3
DROP TABLE IF EXISTS School.ScoresCopy

CREATE TABLE School.Pupils
(
    PupilID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    ClassID INT

)
GO

INSERT INTO School.Pupils (PupilID, FirstName,LastName,ClassID)
VALUES(1,'John','Doe',101),
      (2,'Jane','Doe',101),
      (3,'Bob','Doe',101),
      (4,'Alice','Doe',102),
      (5,'Mike','Doe',102),
      (6,'Sara','Doe',102),
      (7,'Tom','Doe',103),
      (8,'Lily','Doe',103),
      (9,'Jack','Doe',103),
      (10,'Emma','Doe',104),
      (11,'Olivia','Doe',104),
      (12,'Noah','Doe',104)
GO
SELECT * FROM School.Scores
SELECT * FROM School.Pupils


SELECT * FROM School.Scores
JOIN School.Pupils ON School.Scores.PupilID = School.Pupils.PupilID
GO


--easy way of writing the above query using aliases:

SELECT * 
FROM School.Scores AS S
JOIN School.Pupils AS P
ON S.PupilID = P.PupilID
GO


SELECT S. * ,P.PupilID, P.FirstName,P.LastName
FROM School.Scores AS S
JOIN School.Pupils AS P --JOIN IS DEFAULT INNER JOIN
ON S.PupilID = P.PupilID
GO



SELECT S. * , P.PupilID, P.FirstName, P.LastName
FROM School.Scores AS S LEFT JOIN School.Pupils AS P ON S.PupilID =P.PupilID  -- LEFT JOIN (includes all columns from the left table and matching columns from the right table)
GO

SELECT S. * , P.PupilID, P.FirstName, P.LastName
FROM School.Scores AS S RIGHT JOIN School.Pupils AS P ON S.PupilID =P.PupilID  -- RIGHT JOIN (includes all columns from the right table and matching columns from the left table)


SELECT S. *, P.PupilID, P.FirstName, P.LastName
FROM School.Scores AS S FULL OUTER JOIN School.Pupils AS P ON S.PupilID =P.PupilID  -- FULL OUTER JOIN (includes all columns from both tables)

SELECT *
FROM School.Scores AS S CROSS JOIN School.Pupils AS P --CROSS JOIN (includes all columns from both tables and combinations) dont use cross join unless the table have less rows and join condition will be ignored'
GO


-- Using NULLs in the results of a query which uses a JOIN
SELECT COALESCE(S.PupilID,P.PupilID) AS PupilID, S.score,S.SetType,S.DateTaken,S.Maximum,P.FirstName,P.LastName
FROM School.Scores AS S
FULL JOIN School.Pupils AS P 
ON S.PupilID = P.PupilID
GO


SELECT ISNULL(S.PupilID,P.PupilID) AS PupilID, S.score,S.SetType,S.DateTaken,S.Maximum,P.FirstName,P.LastName
FROM School.Scores AS S
LEFT JOIN School.Pupils AS P 
ON S.PupilID = P.PupilID
GO



--to find mssing data
SELECT S.*,P.PupilID,P.FirstName,P.LastName
FROM School.Scores AS S
RIGHT JOIN School.Pupils AS P
ON S.PupilID = P.PupilID
WHERE P.PupilID IS NULL
GO

SELECT * FROM School.Pupils
GO

-- Creating a FOREIGN KEY constraint
DROP TABLE IF EXISTS School.ScoresCopy
DROP TABLE IF EXISTS School.PupilsCopy

CREATE TABLE School.ScoresCopy(

    PupilID int NULl,
    Score smallint NOT NULL,
    SetType varchar(10)NOT NULL,
    DateTaken date NULL,
    ScoreID int NULL,
    DateRecorded datetime2 NULL DEFAULT GETDATE()

)
GO
CREATE TABLE School.PupilsCopy (
    PupilID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    ClassID INT
    )
GO  

INSERT INTO School.ScoresCopy (PupilID,SetType,Score,DateTaken)
VALUES
(1,'Math',85,'2032-10-01'),
(2,'Math',90,'2032-10-01'),
(3,'Math',78,'2032-10-01'),
(4,'Science',92,'2032-10-01'),
(5,'Science',88,'2032-10-01'),
(6,'Science',80,'2032-10-01'),
(4,'Math',70,'2032-11-02'),
(5,'Math',76,'2032-11-02'),
(7,'Math',91,'2032-11-02'),
(1,'Science',42,'2032-11-02'),
(2,'Science',18,'2032-11-02'),
(3,'Science',80,'2032-11-02')
GO

INSERT INTO School.PupilsCopy (PupilID,FirstName,LastName,ClassID)
VALUES
(1,'Alice','Jones',1),
(2,'Bob','Taylor',1),
(3,'Charlie','Evans',1),
(4,'Daisy','Wilson',2),
(5,'Ethan','Thomas',2),
(8,'Fiona','Roberts',3)
GO


SELECT * FROM School.ScoresCopy
SELECT * FROM School.PupilsCopy
GO
UPDATE School.ScoresCopy
SET PupilID = 8
WHERE PupilID = 7
GO

UPDATE School.ScoresCopy
SET PupilID = 7
WHERE PupilID = 8
GO

UPDATE School.PupilsCopy
SET PupilID = 7
WHERE PupilID = 8
GO

UPDATE School.PupilsCopy
SET PupilID = 8
WHERE PupilID = 7
GO

DELETE FROM School.PupilsCopy
WHERE PupilID =2

---Creating a foreign key constratint:

ALTER TABLE School.ScoresCopy WITH NOCHECK
ADD CONSTRAINT FK_ScoresCopy_PupilsCopy FOREIGN KEY (PupilID) REFERENCES School.PupilsCopy(PupilID)
GO

SELECT * FROM School.ScoresCopy 

ALTER TABLE School.ScoresCopy
DROP CONSTRAINT FK_ScoresCopy_PupilsCopy
GO

ALTER TABLE School.ScoresCopy
NOCHECK CONSTRAINT FK_ScoresCopy_PupilsCopy

ALTER TABLE School.ScoresCopy
WITH CHECK CHECK CONSTRAINT FK_ScoresCopy_PupilsCopy
GO

ALTER TABLE School.ScoresCopy
WITH NOCHECK CHECK CONSTRAINT FK_ScoresCopy_PupilsCopy
GO

ALTER TABLE School.ScoresCopy
DROP CONSTRAINT FK_ScoresCopy_PupilsCopy
GO



--Expanding our FOREIGN KEY constraint



-- Using CASCADE for updating and deleting on all refered tables
ALTER TABLE school.ScoresCopy
WITH NOCHECK
ADD CONSTRAINT FK_ScoresCopy_PupilsCopy FOREIGN KEY (PupilID)REFERENCES School.PupilsCopy(PupilID) ON UPDATE CASCADE ON DELETE CASCADE
GO

ALTER TABLE School.ScoresCopy
DROP CONSTRAINT FK_ScoresCopy_PupilsCopy
GO

--USING SET NULL
ALTER TABLE School.ScoresCopy WITH NOCHECK
ADD CONSTRAINT FK_ScoresCopy_PupilCopy FOREIGN KEY (PupilID) REFERENCES School.PupilsCopy(PupilID) ON UPDATE SET NULL ON DELETE SET NULL
GO

--Using SET DEFAULT
 INSERT INTO School.pupilsCopy (PupilID,FirstName,LastName,ClassID)
 VALUES(999,'UNKNOWN','UNKNOWN',0)
 ALTER TABLE School.ScoresCopy
 ADD CONSTRAINT DK_ScoresCopy_PupilID DEFAULT 999 FOR PupilID

 ALTER TABLE School.ScoresCopy WITH NOCHECK
 ADD CONSTRAINT FK_ScoresCopy_PupilsCopy FOREIGN KEY (PupilID)
 REFERENCES School.PupilsCopy(PupilID)
 ON UPDATE SET DEFAULT
 ON DELETE SET DEFAULT 



