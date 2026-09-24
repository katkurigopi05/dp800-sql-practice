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

--

CREATE TABLE[School].[PupilsInMemory]
(
    PupilID INT NOT NULL PRIMARY KEY,
    FirstName VARCHAR(50) NULL,
    LastName VARCHAR(50) NULL,
    ClassID INT NULL,
)WITH(MEMORY_OPTIMIZED = ON)
GO


--CREATE TEMPORAL TABLE

CREATE TABLE School.PupilsTemporial
(
    PupilID INT NOT NULL PRIMARY KEY,
    FirstName VARCHAR(50) NULL,
    LastName VARCHAR(50) NULL,
    ClassID INT NULL,
    ValidFrom DATETIME2(7) GENERATED ALWAYS AS ROW START, 
    ValidTo DATETIME2(7) GENERATED ALWAYS AS ROW END,
    PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)
WITH(SYSTEM_VERSIONING = ON );
GO

INSERT INTO School.PupilsTemporial (PupilID, FirstName, LastName, ClassID)
SELECT PupilID,FirstName,LastName,ClassID
FROM School.Pupils

SELECT *
FROM School.PupilsTemporial

INSERT INTO School.PupilsTemporial (PupilID, FirstName, LastName, ClassID)
VALUES(9,'Lizzy','Mycroft',4)

SELECT *
FROM School.PupilsTemporial
FOR SYSTEM_TIME
--BETWEEN START_DATE AND END_DATE

SELECT *
FROM School.PupilsTemporial
FOR SYSTEM_TIME BETWEEN '2026-01-01' AND '2026-12-31';

--ALL BETWEEN END_DATE AND START_DATE

SELECT *
FROM School.PupilsTemporial
FOR SYSTEM_TIME ALL BETWEEN '2026-01-01' AND '2026-12-31';


--CONTAINED IN START_DATE AND END_DATE 

SELECT * 
FROM School.PupilsTemporial
FOR SYSTEM_TIME CONTAINED IN ('2026-01-01', '2026-12-31')

--
--FROM START_DATE TO END_DATE

SELECT * 
FROM School.PupilsTemporial
FOR SYSTEM_TIME FROM '2026-01-01' TO '2026-12-31'   

ALTER TABLE School.PupilsTemporial SET (SYSTEM_VERSIONING = OFF);
GO

DROP TABLE School.PupilsTemporial
GO

--CREATING EXTERNAL TABLES
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '<strong password>'

CREATE DATABASE SCOPED CREDENTIAL AzureStorageCredentail
WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
SECRET = '<SAS token with read access to Pupils.csv>'
GO
CREATE EXTERNAL DATA SOURCE AzureBlobSource
WITH (
    LOCATION = 'abs://<storage-account>.blob.core.windows.net/dp800/Pupils.csv',
    CREDENTIAL = AzureStorageCredentail
)
GO


CREATE EXTERNAL FILE FORMAT CsvFileFormat
WITH(
FORMAT_TYPE=DELIMITEDTEXT,
FORMAT_OPTIONS
(
FIELD_TERMINATOR = ',',
STRING_DELIMITER = '"',
FIRST_ROW=2
)
);
GO


CREATE EXTERNAL TABLE School.PupilsExternal
(
    PupilID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    ClassID INT

)
WITH
(
    LOCATION ='/Pupils.csv',
    DATA_SOURCE = AzureBlobSource,
    FILE_FORMAT = CsvFileFormat
);
GO




SELECT * FROM School.PupilsExternal;




CREATE EXTERNAL TABLE School.PupilsExternal
(
    PupilID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    ClassID INT

)


DROP EXTERNAL TABLE School.PupilsExternal;
DROP EXTERNAL DATA SOURCE AzureBlobSource;
GO
CREATE EXTERNAL TABLE School.PupilsExternal
(
    PupilID   INT,
    FirstName VARCHAR(50),
    LastName  VARCHAR(50),
    ClassID   INT
)
WITH (
    LOCATION    = '/Pupils.csv',
    DATA_SOURCE = AzureBlobSource,
    FILE_FORMAT = CsvFileFormat
);
GO

SELECT * FROM School.PupilsExternal 
UNION
SELECT * FROM School.Pupils 
ORDER BY PupilID;
GO

DROP EXTERNAL TABLE School.PupilsExternal
DROP EXTERNAL FILE FORMAT CsvFileFormat
DROP EXTERNAL DATA SOURCE AzureBlobSource
DROP DATABASE SCOPED CREDENTIAL AzureStorageCredentail

--LEDGER TABLES

CREATE TABLE School.PupilsLedger
(PupilID int NOT NULL,
 FirstName varchar(50) NULL,
 LastName varchar(50) NULL,
 ClassID int NULL)
--WITH (LEDGER = ON (APPEND_ONLY = ON))
WITH ( SYSTEM_VERSIONING = ON (HISTORY_TABLE = School.PupilsLedgerHistory), LEDGER = ON );

INSERT INTO School.PupilsLedger
SELECT PupilID, FirstName, LastName, ClassID
FROM School.Pupils

SELECT *, ledger_start_transaction_id, ledger_start_sequence_number
FROM School.PupilsLedger

INSERT INTO School.PupilsLedger(PupilID, FirstName, LastName, ClassID)
VALUES (9, 'Lizzy', 'Mycroft', 4)


UPDATE School.PupilsLedger
SET FirstName = 'Georgiana', LastName = 'Smith'
WHERE PupilID = 8

DELETE School.PupilsLedger
WHERE PupilID = 5

EXEC sp_generate_database_ledger_digest

DROP TABLE School.PupilsLedger

SELECT * FROM School.PupilsLedgerHistory

SELECT * FROM sys.dm_db_file_space_usage;


--120. 39. Create, build, and validate database models by using SQL Database Projects
SELECT *
FROM salesLT.Address;





