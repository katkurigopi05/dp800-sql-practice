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


--1d creating indexes


SELECT * FROM School.Pupils
SELECT * FROM School.Scores

SELECT P.FirstName,P.LastName,S.Score,S.SetType
FROM School.Pupils AS P
JOIN School.Scores AS S ON P.PupilID = S.PupilID
WHERE FirstName BETWEEN'D' AND 'G'

/**** Object : Index [PK_Scores__2F] Script date 9/21/26 ***/

SELECT * FROM School.Pupils
SELECT DISTINCT DateTaken,SetType FROM School.Scores
ORDER BY DateTaken,SetType


SELECT P.FirstName,P.LastName,S.Score,S.SetType
FROM School.Pupils AS P
INNER JOIN School.Scores AS S ON P.PupilID = S.PupilID

CREATE INDEX IDX_Scores_PupilID ON School.Scores(PupilID)
WITH (PAD_INDEX = ON , FILLFACTOR =50, DROP_EXISTING = ON)

ALTER INDEX IDX_Scores_PupilID ON School.Scores REBUILD 
WITH (PAD_INDEX = ON , FILLFACTOR =50)



ALTER INDEX IDX_Scores_PupilID ON School.Scores REBUILD 
WITH (ONLINE = ON)

ALTER INDEX IDX_Scores_PupilID ON School.Scores REORGANIZE

--1d. Developing additional indexes
SELECT Score,DateTaken
FROM School.Scores
WHERE PUpilID =1
AND SetType ='Math'
ORDER BY DateTaken DESC;


CREATE NONCLUSTERED INDEX IX_Scores_PupilID_SetType_DateTaken
ON School.Scores(PupilID,SetType,DateTaken DESC)
INCLUDE(Score);




--
SELECT PupilID,DateTaken,SetType,Score,Maximum
FROM School.Scores
WHERE PUpilID =1
AND SetType ='Science'
ORDER BY DateTaken DESC;


CREATE NONCLUSTERED INDEX IX_Scores_PupilID_SetType
ON School.Scores(PupilID,SetType)
INCLUDE(DateTaken,Score, Maximum);

--
SELECT PupilID,FirstName,LastName
FROM School.Pupils
WHERE LastName = 'Jones'



CREATE NONCLUSTERED INDEX IX_Pupils_LastName_FirstName
ON School.Pupils(LastName)
INCLUDE(FirstName)

SELECT PupilID,SetType
FROM School.Scores
WHERE DateRecorded IS NULL;

CREATE NONCLUSTERED INDEX IX_Scores_DateRecorded
ON School.Scores(DateRecorded)
WHERE DateRecorded IS NULL;


ALTER INDEX IX_Scores_DateRecorded ON School.Scores DISABLE;


--Implement partitioning
--CREATE a partiiton function that divides data into four partitions based on integer value ranges

CREATE PARTITION FUNCTION PF_ScoresRange (INT)
AS RANGE LEFT FOR VALUES (10,20,30);



-- Create a partition schema that assigns all four paratitions to the PRIMARY FILEGROUP

CREATE PARTITION SCHEME PS_ScoresRange
AS PARTITION PF_ScoresRange
TO ([PRIMARY],[PRIMARY],[PRIMARY],[PRIMARY]);

--create a partitioned table on the partition schema using the number column as the partitioning key

CREATE TABLE School.Numbers
(Number int)
ON PFNumbers(Number)
-- Populate the table with sequential row numbers and a NULL
INSERT INTO School.Numbers
SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL))
FROM School.Pupils
CROSS JOIN School.Scores

INSERT INTO School.Numbers
VALUES(NULL)


--Display all records with their assigned partition number
SELECT *, $PARTITION.PFNumbers(Number) AS PartitionNumber
FROM School.Numbers
ORDER BY Number;

SELECT $PARTITION.PFNumbers(Number) AS PartitionNumber, MIN(Number) AS SmallestNumber, MAX(Number) AS BiggestNumber
FROM School.Numbers
GROUP BY $PARTITION.PFNumbers(Number);


--Remove the partitioned table for cleanup
DROP TABLE IF EXISTS School.Numbers
DROP PARTITION SCHEME PFNumbers
DROP PARTITION FUNCTION PFNumbers

-- Columnstore indexes

CREATE NONCLUSTERED COLUMNSTORE INDEX IX_ScoresCopy
ON School.ScoresCopy (PupilID)
ORDER (PupilID)

DROP INDEX IX_ScoresCopy ON School.ScoresCopy

--
