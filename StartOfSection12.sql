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


--Creating stored procedures
CREATE OR ALTER PROCEDURE School.procPupilsAndScores
    @PupilID INT = 1,
    @FirstName VARCHAR(50) OUTPUT,
    @LastName VARCHAR(50) OUTPUT,
    @AverageScore DECIMAL(4,1) OUTPUT

AS
BEGIN
    SET NOCOUNT ON;

    SELECT * FROM School.Pupils WHERE PupilID = @PupilID;
    SELECT * FROM School.Scores WHERE PupilID = @PupilID;

    SELECT
        @FirstName = FirstName,
        @LastName = LastName
    FROM School.Pupils
    WHERE PupilID = @PupilID;
    SELECT @AverageScore = AVG(Score*1.0) FROM School.Scores WHERE PupilID =@PupilID
    RETURN 0
END;
GO

DECLARE @FirstName VARCHAR(50), @LastName VARCHAR(50);
DECLARE @AverageScore DECIMAL(4,1)
DECLARE @Result INT
EXEC @Result = School.procPupilsAndScores
    @PupilID = 3,
    @FirstName = @FirstName OUTPUT,
    @LastName = @LastName OUTPUT,
    @AverageScore = @AverageScore OUTPUT;
SELECT @FirstName AS FirstName, @LastName AS LastName,@AverageScore AS AverageScore,@Result AS Result

GO

-- 19. Implementing error handling

CREATE OR ALTER PROCEDURE School.procPupilsAndScores
    @PupilID VARCHAR = '1',
    @FirstName VARCHAR(50) OUTPUT,
    @LastName VARCHAR(50) OUTPUT,
    @AverageScore DECIMAL(4,1) OUTPUT

AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @PupilIDInt INT
    SET @PupilIDInt =TRY_CAST(@PupilID AS INT)
    SELECT * FROM School.Pupils WHERE PupilID = @PupilIDInt;
    SELECT * FROM School.Scores WHERE PupilID = @PupilIDInt;

    SELECT
        @FirstName = FirstName,
        @LastName = LastName
    FROM School.Pupils
    WHERE PupilID = @PupilIDInt;
    BEGIN TRY
    SELECT @AverageScore = ISNULL(SUM(Score*1.0),0)/COUNT(*) FROM School.Scores WHERE PupilID =@PupilIDInt;
    SET NOCOUNT OFF; RETURN 0
    END TRY
    BEGIN CATCH 
        SET @FirstName ='Number:'+CAST(ERROR_NUMBER() AS NVARCHAR(100))
                       +',Message:'+CAST(ERROR_MESSAGE()AS NVARCHAR(100))
                       +',Procedure:'+CAST(ERROR_PROCEDURE() AS NVARCHAR(100))
        Set @LastName  =',Line:'+CAST(ERROR_LINE() AS NVARCHAR(100))
                       +',Severity:'+CAST(ERROR_SEVERITY()AS NVARCHAR(100))
                       +',State:'+CAST(ERROR_STATE()AS NVARCHAR(100))
        SET @AverageScore = 0
          SET NOCOUNT OFF;
    RETURN 1
    END CATCH
END
GO

DECLARE @FirstName VARCHAR(50), @LastName VARCHAR(50);
DECLARE @AverageScore DECIMAL(4,1)
DECLARE @Result INT
EXEC @Result = School.procPupilsAndScores 'hello',
    @FirstName = @FirstName OUTPUT,
    @LastName = @LastName OUTPUT,
    @AverageScore = @AverageScore OUTPUT;
SELECT @FirstName AS FirstName, @LastName AS LastName,@AverageScore AS AverageScore,@Result AS Result

--AVOID BELOW KIND IN ERROR HANDLING IMPLEMENTATION
--SELECT *
--FROM School.Pupils
--ORDER BY 1
--Creating scalar functions



CREATE OR ALTER FUNCTION School.fnGetPupilName(@PupilID INT)
RETURNS VARCHAR(100)
--WITH ENCRYPTION -- This encrypts the definition of the function (stored in sys.sql_modules).
--Other options are SCHEMABINDING,RETURNS NULL ON NULL INPUT
--WITH SCHEMABINDING
--WITH EXECUTE AS CALLER
WITH RETURNS NULL ON NULL INPUT
AS 
BEGIN
DECLARE @Name VARCHAR(100);

SELECT @Name = FirstName + ''+LastName
FROM School.Pupils
WHERE PupilID = @PupilID;

RETURN @Name;
END
GO
SELECT *, School.fnGetPupilName(PupilID) AS FullName
FROM School.Pupils;
GO

ALTER TABLE School.Pupils
ADD FullName AS School.fnGetPupilName(PupilID);
GO

SELECT * FROM School.Pupils;


ALTER TABLE School.Pupils
DROP COLUMN FullName;

SELECT * FROM sys.sql_modules
WHERE object_id =OBJECT_ID('School.fnGetPupilName');

--9. Creating table-valued functions

CREATE OR ALTER FUNCTION School.fnGetPupilScores(@PupilID INT)
RETURNS TABLE
AS 
RETURN
(SELECT SetType,AVG(Score) AS AverageScore,COUNT(*) AS NumberOfScores
FROM School.Scores
WHERE PupilID =@PupilID
GROUP BY SetType)
GO

SELECT * FROM School.fnGetPupilScores(2)


SELECT * FROM School.Pupils AS P
CROSS APPLY School.fnGetPupilScores(P.PupilID) AS S;

DROP FUNCTION School.fnGetPupilScores;
GO

CREATE OR ALTER FUNCTION School.fnGetPupilScores(@PupilID INT)
RETURNS @TblScores TABLE
(SetType VARCHAR(50),
AverageScore DECIMAL(5,2),
NumberOfScores INT)
AS 
BEGIN
    INSERT INTO @TblScores
    SELECT SetType,AVG(Score) AS AverageScore,COUNT(*) AS NumberOfScores
    FROM School.Scores
    WHERE PupilID =@PupilID
    GROUP BY SetType
    RETURN
END
GO

