DROP TABLE IF EXISTS School.Scores;


GO
DROP TABLE IF EXISTS School.Pupils;


GO
DROP SCHEMA IF EXISTS School;


GO
CREATE SCHEMA School;


GO
CREATE TABLE School.Scores (
    PupilID      INT           NOT NULL,
    Score        SMALLINT      NOT NULL,
    SetType      VARCHAR (10) ,
    DateTaken    DATE          NULL,
    Maximum      SMALLINT      NULL,
    DateRecorded DATETIME2 (7) NULL
);


GO
INSERT  INTO School.Scores (
    PupilID,
    SetType,
    Score,
    DateTaken
)
VALUES                    (1, 'Math', 85, '2032-10-01'),
(2, 'Math', 90, '2032-10-01'),
(3, 'Math', 78, '2032-10-01'),
(4, 'Science', 92, '2032-10-01'),
(5, 'Science', 88, '2032-10-01'),
(6, 'Science', 80, '2032-10-01'),
(4, 'Math', 70, '2032-11-02'),
(5, 'Math', 76, '2032-11-02'),
(7, 'Math', 91, '2032-11-02'),
(1, 'Science', 42, '2032-11-02'),
(2, 'Science', 18, '2032-11-02'),
(3, 'Science', 80, '2032-11-02');

ALTER TABLE School.Scores
    ADD ScoresID INT IDENTITY NOT NULL PRIMARY KEY;

CREATE TABLE School.Pupils (
    PupilID   INT          PRIMARY KEY,
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

-- 15a. Regular expressions and the REGEXP_LIKE function
SELECT *
FROM   School.Pupils
--123-456-7890
--\d\d\d-\d\d\d-\d\d\d\d
--\d{3}-\d{3}-\d{4}
WHERE  REGEXP_LIKE (FirstName, '[a-z]', 'i'); -- it selects the firstname starts with any of the alphabets and i = case insensitive 

--15a. More about regular expressions
SELECT *
FROM   School.Pupils
WHERE  REGEXP_LIKE (FirstName, '^[A-Za-z]{7}', 'i'); -- it selects the firstname starts with any of the alphabets and i = case insensitive and {7} equals to 7 characters between a to z

SELECT *
FROM   School.Pupils
WHERE  FirstName LIKE '%[^c-e]';

SELECT *
FROM   School.Pupils
WHERE  REGEXP_LIKE (FirstName, '^[A-Oa-o]+$'); -- 

SELECT *
FROM   School.Pupils
WHERE  REGEXP_LIKE (FirstName, '^(Alice|Daisy)$');

SELECT *
FROM   School.Scores
WHERE  REGEXP_LIKE (CAST (Score AS NCHAR (3)), '\d8');

--72. 15b. The REGEXP_REPLACE function
SELECT *,
       REGEXP_REPLACE(FirstName, '^[^A-Da-d]', '#') AS ModifiedFirstName
FROM   School.Pupils;

SELECT *,
       REGEXP_REPLACE(FirstName, 'e$', '#') AS ModifiedFirstName --$ matches end of the string
FROM   School.Pupils;

SELECT *,
       REGEXP_REPLACE(FirstName, 'e$', '(e)') AS ModifiedFirstName --$^ matches starting and $ matches end of the string
FROM   School.Pupils;

SELECT *,
       REGEXP_REPLACE(FirstName, '([aeiouAEIOU])(.*)([aeiouAEIOU])', '\3\2\1') AS ModifiedFirstName
FROM   School.Pupils;

SELECT *,
       REGEXP_REPLACE(CAST (DateTaken AS CHAR (10)), '(\d{2})(\d{2})-(\d{2})-(\d{2})', '\3.\4.\2') AS ModifiedDate
FROM   School.Scores;

--2032-11-02 ->11.02.32  (20)(32)-(11)-(02)
--73. 15c-e. The REGEXP_SUBSTR, INSTR and COUNT functions
SELECT FirstName,
       REGEXP_SUBSTR(FirstName, '[aeiouAEIOU]') AS Letter,
       REGEXP_INSTR(FirstName, '[aeiouAEIOU]') AS LetterPosition,
       REGEXP_COUNT(FirstName, '[aeiouAEIOU]') AS LetterPosition
FROM   School.Pupils;

SELECT FirstName,
       REGEXP_SUBSTR(FirstName, '[aeiouAEIOU]', 2) AS Letter,
       REGEXP_INSTR(FirstName, '[aeiouAEIOU]', 2) AS LetterPosition,
       REGEXP_COUNT(FirstName, '[aeiouAEIOU]', 2) AS LetterPosition
FROM   School.Pupils;

SELECT FirstName,
       REGEXP_SUBSTR(FirstName, '[aeiouAEIOU]', 2, 2) AS Letter,
       REGEXP_INSTR(FirstName, '[aeiouAEIOU]', 2, 2) AS LetterPosition
FROM   School.Pupils;

SELECT FirstName,
       REGEXP_SUBSTR(FirstName, '[AEIOU]', 2, 2, 'i') AS Letter,
       REGEXP_INSTR(FirstName, '[AEIOU]', 2, 2, 0, 'i') AS LetterPosition,
       REGEXP_INSTR(FirstName, '[AEIOU]', 2, 2, 1, 'i') AS LetterPosition2
FROM   School.Pupils;

SELECT FirstName,
       REGEXP_SUBSTR(FirstName, '([A-Z])([A-Z])$', 1, 1, 'i', 1) AS Letter,
       REGEXP_INSTR(FirstName, '([A-Z])([A-Z])$', 1, 1, 0, 'i', 1) AS LetterPosition
FROM   School.Pupils;

SELECT FirstName,
       REGEXP_SUBSTR(FirstName, '([A-Z]{2})([A-Z])$', 1, 1, 'i', 1) AS Letter,
       REGEXP_INSTR(FirstName, '([A-Z]{2})([A-Z])$', 1, 1, 0, 'i', 1) AS LetterPosition
FROM   School.Pupils;

SELECT *
FROM   School.Scores;

SELECT *,
       REGEXP_SUBSTR(CAST (DateTaken AS NVARCHAR (10)), '(\d{2})(\d{2})-(\d{2})-(\d{2})', 1, 1, 'i', '3') AS ChangedDateTaken,
       REGEXP_INSTR(CAST (DateTaken AS NVARCHAR (10)), '(\d{2})(\d{2})-(\d{2})-(\d{2})', 1, 1, 0, 'i', 3) AS DatePosition,
       REGEXP_COUNT(CAST (DateTaken AS NVARCHAR (10)), '\d', 1) AS NumberOfDigits
FROM   School.Scores;

WITH   CTE
AS     (SELECT CONCAT(PupilID, ' ', FirstName, ' ', LastName, ' ', ClassID) AS FullString
        FROM   School.Pupils)
SELECT FullString,
       REGEXP_SUBSTR(FullString, '([A-Za-z]+) ([A-Za-z]+)', 1, 1, 'c', 2) AS Name,
       REGEXP_INSTR(FullString, '([A-Za-z]+) ([A-Za-z]+)', 1, 1, 0, 'i', 2) AS NamePosition
FROM   --, REGEXP_COUNT(FullString,'\d',1) AS NumberOfDigits
       -- REGEXP_COUNT(FullString,'\D',1) AS NumberOfNonDigits
       --,REGEXP_COUNT(FullString,'[a-z]',1,'i') AS NumberOfLetters
       CTE;

--15f-g. The REGEXP_MATCHES and SPLIT_TO_TABLE functions
SELECT *
FROM   REGEXP_MATCHES ('Alice Jones', '[A-Z]');

SELECT *
FROM   REGEXP_SPLIT_TO_TABLE ('Alice Jones', ' ');

SELECT *
FROM   REGEXP_MATCHES ('Alice Jones', '[A-Z]', 'i');

SELECT *
FROM   REGEXP_SPLIT_TO_TABLE ('Alice Jones', '[E]', 'i');

SELECT *
FROM   REGEXP_MATCHES ('Alice Jones', '[A-Z]{2}', 'i');

SELECT FirstName
FROM   School.Pupils;

SELECT FirstName,
       M.*
FROM   School.Pupils AS P CROSS APPLY REGEXP_MATCHES (P.FirstName, '[A-Z]{2}', 'i') AS M;

SELECT DateTaken
FROM   School.Scores;

SELECT   DISTINCT DateTaken,
                  M.*
FROM     School.Scores AS S CROSS APPLY REGEXP_SPLIT_TO_TABLE (CAST (S.DateTaken AS VARCHAR (10)), '-') AS M
ORDER BY DateTaken, ordinal;

--16. Fuzzy string matching functions
DECLARE @CharFrom varchar(100) = 'Favourite Programme';
DECLARE @CharTo   varchar(100) = 'Favorite Program';

SELECT @CharFrom AS CharFrom,
       @CharTo   AS CharTo,
       EDIT_DISTANCE(@CharFrom COLLATE Latin1_General_100_CI_AS,
                     @CharTo   COLLATE Latin1_General_100_CI_AS) AS Distance;

SELECT CASE WHEN LEN(@CharFrom) > LEN(@CharTo) THEN LEN(@CharFrom) ELSE LEN(@CharTo) END AS MaxLength;

SELECT 100.0 - (100.0 * 3 / 19) AS Similarity;

SELECT EDIT_DISTANCE_SIMILARITY(@CharFrom,@CharTo) AS Similarity
GO
DECLARE @CharFrom AS VARCHAR (100) = 'Favourite Programme';

DECLARE @CharTo AS VARCHAR (100) = 'Favorite Program';

SELECT @CharFrom AS CharFrom,
       @CharTo AS CharTo,
       JARO_WINKLER_DISTANCE(@CharFrom, @CharTo) AS Distance,
       JARO_WINKLER_SIMILARITY(@CharFrom, @CharTo) AS Similarity;


--2e, 17.Creating node and edge graph tables, and using the MATCH function
SELECT * FROM School.Pupils
SELECT * FROM School.PupilFriends

CREATE SCHEMA Graph
GO
--Node Tables
CREATE TABLE Graph.Student (ID INT PRIMARY KEY,name VARCHAR(50)) AS NODE;
CREATE TABLE Graph.Teacher (ID INT PRIMARY KEY,name VARCHAR(50)) AS NODE;
--Edge Tables
CREATE TABLE Graph.TaughtBy(Start_date DATE) AS EDGE;


SELECT * FROM Graph.Student
SELECT * FROM Graph.Teacher
SELECT * FROM Graph.TaughtBy;
--Students
INSERT INTO Graph.Student VALUES (1,'Alice'); 
INSERT INTO Graph.Student VALUES (2,'Bob')
INSERT INTO Graph.Student VALUES (3,'Charlie'); 
INSERT INTO Graph.Student VALUES (4,'Daisy'); 
INSERT INTO Graph.Student VALUES (5,'Ethan'); 
INSERT INTO Graph.Student VALUES (8,'Fiona'); 


--Teachers
INSERT INTO Graph.Teacher VALUES (1,'Mr Smith');
INSERT INTO Graph.Teacher VALUES (2,'Mrs Brown');
INSERT INTO Graph.Teacher VALUES (3,'Mr Jones');


SELECT * FROM Graph.Student
SELECT * FROM Graph.Teacher
SELECT * FROM Graph.TaughtBy;

--Alice TaughtBy Mr Smith from 2023-01-01 to 2023-06-30
INSERT INTO Graph.TaughtBy
VALUES ((SELECT $node_id FROM Graph.Student WHERE ID = 1),
        (SELECT $node_id FROM Graph.Teacher WHERE ID = 1),
        '2032-09-01')

--BOB TaughtBy Mrs Smith from 2032-09-01 to 2033-06-30
INSERT INTO Graph.TaughtBy
VALUES ((SELECT $node_id FROM Graph.Student WHERE ID = 2),
        (SELECT $node_id FROM Graph.Teacher WHERE ID = 1),
        '2032-09-01')

--CHARLIE TaughtBy Mr SMith from 2032-09-01 to 2033-06-30
INSERT INTO Graph.TaughtBy
VALUES ((SELECT $node_id FROM Graph.Student WHERE ID = 3),
        (SELECT $node_id FROM Graph.Teacher WHERE ID = 1),
        '2032-09-01')


INSERT INTO Graph.TaughtBy
VALUES ((SELECT $node_id FROM Graph.Student WHERE ID = 4),
        (SELECT $node_id FROM Graph.Teacher WHERE ID = 2),
        '2032-09-01')

INSERT INTO Graph.TaughtBy
VALUES ((SELECT $node_id FROM Graph.Student WHERE ID = 5),
        (SELECT $node_id FROM Graph.Teacher WHERE ID = 2),
        '2032-09-01')

INSERT INTO Graph.TaughtBy
VALUES ((SELECT $node_id FROM Graph.Student WHERE ID = 8),
        (SELECT $node_id FROM Graph.Teacher WHERE ID = 3),
        '2032-09-01');

SELECT * FROM Graph.TaughtBy;


SELECT t.name AS TeacherName
FROM Graph.Student S, Graph.TaughtBy tb, Graph.Teacher t
WHERE MATCH(s-(tb)->t)
AND S.name='Alice';

SELECT s.name AS StudentName
FROM Graph.Student S, Graph.TaughtBy tb, Graph.Teacher t
WHERE MATCH(s-(tb)->t)
AND t.name='Mr Smith';

-- 2e, 17. More about graph tables and using the MATCH function

CREATE TABLE Graph.FreindsOf AS EDGE 

INSERT INTO Graph.FreindsOf ($from_id,$to_id)
VALUES((SELECT $node_id FROM Graph.Student WHERE name = 'Charlie'),
       (SELECT $node_id FROM Graph.Student WHERE name = 'Daisy')),
((SELECT $node_id FROM Graph.Student WHERE name = 'Alice'),
       (SELECT $node_id FROM Graph.Student WHERE name = 'Charlie')),
((SELECT $node_id FROM Graph.Student WHERE name = 'Bob'),
       (SELECT $node_id FROM Graph.Student WHERE name = 'Ethan')),
((SELECT $node_id FROM Graph.Student WHERE name = 'Bob'),
       (SELECT $node_id FROM Graph.Student WHERE name = 'Charlie')),
((SELECT $node_id FROM Graph.Student WHERE name = 'Charlie'),
       (SELECT $node_id FROM Graph.Student WHERE name = 'Ethan')),
((SELECT $node_id FROM Graph.Student WHERE name = 'Ethan'),
       (SELECT $node_id FROM Graph.Student WHERE name = 'Fiona'));

Select * FROM Graph.FreindsOf

SELECT s2.name AS FriendName
FROM Graph.Student s1,
     Graph.FreindsOf f,
     Graph.Student s2
WHERE MATCH(s1-(f)->s2)
AND s1.name='Alice';


SELECT DISTINCT 
s1.name AS StartStudent,
STRING_AGG(s2.name,'->')
WITHIN GROUP (GRAPH PATH) AS PATH
FROM Graph.Student AS s1,
Graph.FreindsOf FOR PATH AS f,
Graph.Student FOR PATH AS s2
WHERE MATCH(SHORTEST_PATH(s1(-(f)->s2)+)) AND s1.name ='Alice';
--18. The sys.dm_db_page_info function
