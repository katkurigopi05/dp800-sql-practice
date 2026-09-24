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

SELECT *
FROM School.Pupils
WHERE PupilID IN(3,4,5)

SELECT  * 
FROM School.Pupils
WHERE PupilID IN(1,2,3)

--Write common table expressions (CTEs) - non-recursive
SELECT TOP 7 Score,SetType,ROW_NUMBER() OVER (ORDER BY Score) AS RowNum
FROM School.Scores
ORDER BY Score DESC;

WITH CTE_Scores AS 
(SELECT Score,SetType,ROW_NUMBER() OVER (ORDER BY Score) AS RowNum
FROM School.Scores)
SELECT * FROM CTE_Scores
WHERE RowNum BETWEEN 3 AND 7
ORDER BY RowNum


WITH CTE_Scores AS 
(SELECT Score,SetType,ROW_NUMBER() OVER (ORDER BY Score) AS RowNum
FROM School.Scores),
CTE_ScoresBetween3and7(Score,SetType,RowNumber) AS
(SELECT * FROM CTE_Scores
WHERE RowNum BETWEEN 3 AND 7)
SELECT * FROM CTE_ScoresBetween3and7
ORDER BY RowNumber 
GO

SELECT Score,SetType,ROW_NUMBER() OVER (ORDER BY Score) AS RowNum
FROM School.Scores
ORDER BY RowNum
OFFSET 2 ROWS FETCH NEXT 5 ROWS ONLY

--UNION, UNION ALL, EXCEPT and INTERSECT operators

SELECT PupilID AS PupilNum, FirstName,LastName,ClassID
FROM School.Pupils
WHERE PupilID IN(3,4,5)
--UNION
--UNION ALL
--INTERSECT
--EXCEPT
SELECT PupilID,FirstName,LastName,ClassID
FROM School.Pupils
WHERE PupilID IN(1,2,3);


SELECT PupilID,FirstName,LastName,ClassID
FROM School.Pupils
WHERE PupilID IN(1,2,3)
EXCEPT
SELECT PupilID AS PupilNum, FirstName,LastName,ClassID * 2
FROM School.Pupils
WHERE PupilID IN(3,4,5)

--12. Write common table expressions (CTEs) - recursive

SELECT *
FROM [School].[Pupils]

DROP TABLE IF EXISTS School.PupilFriends
GO
CREATE TABLE School.PupilFriends
(PupilID int,
FriendID int,
PRIMARY KEY (PupilID,FriendID)
, FOREIGN KEY (PupilID) REFERENCES School.Pupils(PupilID),
FOREIGN KEY (FriendID) REFERENCES School.Pupils(PupilID)
)

INSERT INTO School.PupilFriends

VALUES (1,2),(1,3),
(2,5),
(3,4),
(4,5),
(5,8)

SELECT * FROM School.PupilFriends;
--Longhand CTE to find all friends of friends for PupilID = 1
WITH 
L0 AS
(
    --Level 0: Start pupil (the anchor row)
    SELECT pf.PupilID,pf.PupilID AS FriendID,0 AS LevelRemoved
    FROM School.PupilFriends AS pf
    WHERE pf.PupilID = 1),
L1 AS
(
--level 1: direct friends of start pupil
    SELECT pf.PupilID, pf.FriendID, 0+ 1 AS LevelRemoved
    FROM School.PupilFriends AS pf
    WHERE pf.PupilID = 1
),
L2 AS
(
    --level 2: friends of level 1
    SELECT pf.PupilID, pf.FriendID, 1+ 1 AS LevelRemoved
    FROM School.PupilFriends pf
    JOIN L1
    ON pf.PupilID = L1.FriendID

),
L3 AS
(
    --level 3: friends of level 2
    SELECT pf.PupilID, pf.FriendID, 2+ 1 AS LevelRemoved
    FROM School.PupilFriends pf
    JOIN L2
    ON pf.PupilID = L2.FriendID
),
L4 AS
(
    --level 4: friends of level 3
    SELECT pf.PupilID, pf.FriendID, 3+ 1 AS LevelRemoved
    FROM School.PupilFriends pf
    JOIN L3
    ON pf.PupilID = L3.FriendID
),
AllLevels AS
(
    SELECT * FROM L0
    UNION ALL
    SELECT * FROM L1
    UNION ALL
    SELECT * FROM L2
    UNION ALL
    SELECT * FROM L3
    UNION ALL
    SELECT * FROM L4
)
SELECT FriendID,MIN(LevelRemoved) AS LevelsRemoved,(SELECT FirstName from School.Pupils WHERE PupilID = FriendID) AS FirstName      
FROM AllLevels
GROUP BY FriendID
ORDER BY LevelsRemoved,FriendID;

 --CTE to find all friends for PupilDI =1
 WITH RecursiveFreinds AS 
 (
    --Anchor (level 0 = the starting pupil)
    SELECT PupiLID, PupilID AS FriendID,0 AS LevelRemoved
    FROM School.PupilFriends
    WHERE PupiLID =1
    UNION ALL
    --Recursive (add 1 level each step) - we go 4 levels deep
    SELECT pf.PupiLID, pf.FriendID, RF.LevelRemoved + 1 
    FROM School.PupilFriends pf
    JOIN RecursiveFreinds RF
    ON pf.PupilID = RF.FriendID
    WHERE RF.LevelRemoved < 4 -- prevents infinite recursion
)
SELECT FriendID, MIN(LevelRemoved) AS LevelsRemoved
, (SELECT FirstName from School.Pupils WHERE PupilID = FriendID) AS FirstName
FROM RecursiveFreinds
GROUP BY FriendID
ORDER BY LevelsRemoved,FriendID
GO