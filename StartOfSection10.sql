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


--Window Functions
--ROW_NUMBER, RANK, DENSE_RANK and NTILE

SELECT * 
FROM School.Scores
ORDER BY Score;

SELECT Score,SetType, ROW_NUMBER() OVER (PARTITION BY SetType ORDER BY Score DESC) AS RowNum
FROM School.Scores
ORDER BY SetType,Score DESC;

SELECT Score,SetType, 
ROW_NUMBER() OVER (PARTITION BY SetType ORDER BY Score DESC) AS RowNum,
RANK() OVER (PARTITION BY SetType ORDER BY Score) AS RankNum,
DENSE_RANK() OVER (PARTITION BY SetType ORDER BY Score) AS DenseRankNum,
NTILE(4) OVER (PARTITION BY SetType ORDER BY Score) AS Quartile
FROM School.Scores
ORDER BY SetType,Score;


SELECT Score,SetType, 
ROW_NUMBER() OVER w AS RowNum,
RANK() OVER w AS RankNum,
DENSE_RANK() OVER w AS DenseRankNum,
NTILE(4) OVER w AS Quartile
FROM School.Scores 
WINDOW w AS (PARTITION BY SetType ORDER BY Score) 
ORDER BY SetType,Score;

--13. LAG and LEAD
SELECT Score,SetType,LAG(Score,2,0) OVER(ORDER BY Score)AS PreviousScore
,LEAD(Score,2,999) OVER(ORDER BY Score)AS NextScore
--Score -LAG(Score) OVER(ORDER BY Score)AS DifferenceFromPrevious
FROM School.Scores
ORDER BY Score
GO


SELECT Score,SetType,LAG(Score)  IGNORE NULLS OVER(PARTITION BY SetType ORDER BY Score)AS PreviousScore
,LEAD(Score) RESPECT NULLS OVER(PARTITION BY SetType ORDER BY Score)AS NextScore
--Score -LAG(Score) OVER(ORDER BY Score)AS DifferenceFromPrevious
FROM School.Scores
ORDER BY SetType,Score
GO
--13. FIRST_VALUE and LAST_VALUE
SELECT Score,SetType
,FIRST_VALUE(Score) OVER w AS FirstScore
,LAST_VALUE(Score) OVER w AS LastScore
FROM School.Scores
WINDOW w AS(ORDER BY Score RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
ORDER BY Score;



SELECT Score,SetType
,FIRST_VALUE(Score) OVER w AS FirstScore
,LAST_VALUE(Score) OVER w AS LastScore
FROM School.Scores
WINDOW w AS(ORDER BY Score ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)
ORDER BY Score;

SELECT Score,SetType,ScoresID
,FIRST_VALUE(Score) OVER w AS FirstScore
,LAST_VALUE(Score) OVER w AS LastScore
FROM School.Scores
WINDOW w AS(ORDER BY Score RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
ORDER BY Score;

--CUME_DIST, PERCENT_RANK, PERCENTILE_CONT and PERCENTILE_DISC
SELECT SetType,Score,ROW_NUMBER() OVER w AS RowNum
,CUME_DIST() OVER w AS CumeDist
,PERCENT_RANK() OVER w AS PercentRank
--,PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY Score) OVER w AS PercentileCont
--,PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY Score) OVER w AS PercentileDisc
FROM School.Scores
WINDOW w AS (PARTITION BY SetType ORDER BY Score)
ORDER BY  SetType,Score ASC
GO

SELECT SetType,AVG(Score*1.0) AS AverageScore
FROM School.Scores
GROUP BY SetType
ORDER BY Score
GO

SELECT SetType,Score
FROM School.Scores
ORDER BY SetType,Score

SELECT DISTINCT SetType,PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY Score) OVER(PARTITION BY SetType) AS MedianScore,
PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY Score) OVER(PARTITION BY SetType) AS MedianScore
FROM School.Scores
ORDER BY SetType,Score


--Aggregations using Windows Functions

SELECT SetType,Score
FROM School.Scores AS S
ORDER BY SetType,Score
--without window function
SELECT SetType,AVG(Score * 1.0) AS AverageScore
FROM School.Scores AS S
GROUP BY SetType

SELECT SetType,Score,(SELECT AVG(Score * 1.0) FROM School.Scores AS S2 WHERE S.SetType=S2.SetType)AS AverageScore
,AVG(Score * 1.0) OVER (PARTITION BY SetType) AS AverageScoreWindow
FROM School.Scores AS S
ORDER BY SetType,Score
GO

SELECT SetType, COUNT(*) AS TotalScores, Count(Score) AS TotalScoresNonNull
,Count(DISTINCT PupilID) AS TotalPupilID
,MIN(Score) AS MinimumScore,MAX(Score) AS MaximumScore
,SUM(Score) AS TotalScore
,AVG(Score) AS AverageScore
FROM School.Scores AS S
GROUP BY SetType
ORDER BY SetType
GO