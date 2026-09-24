---DP-800
--Section 3: The SEELCT statement -the SELECT, FROM and WHERE clauses AS is alias
SELECT ProductID,
       Name AS ProductName,
       Color,
       listprice,
       SellStartDate
FROM   SalesLT.Product;

-- Select rows fromcolor' in schema 'SchemaName'
SELECT DISTINCT Color AS [Product Color]
FROM   SalesLT.Product;

SELECT ProductCategoryID,
       ProductModelID
FROM   salesLT.Product;

--to remove duplication we can use "distinct " 
SELECT DISTINCT ProductCategoryID,
                ProductModelID
FROM   salesLT.Product;

SELECT ProductID,
       NAME AS ProductName,
       Color,
       ListPrice,
       SellStartDate
FROM   SalesLT.Product
WHERE  ProductID = 710;

--Greater than ">" use to get results after the assigned number
SELECT ProductID,
       NAME AS ProductName,
       Color,
       ListPrice,
       SellStartDate
FROM   SalesLT.Product
WHERE  ProductID > 710;

--lesser than "<" use to get results before the assigned number
SELECT ProductID,
       NAME AS ProductName,
       Color,
       ListPrice,
       SellStartDate
FROM   SalesLT.Product
WHERE  ProductID < 710;

--lesser than ">" and "=" use to get results before the assigned number itself too
SELECT ProductID,
       NAME AS ProductName,
       Color,
       ListPrice,
       SellStartDate
FROM   SalesLT.Product
WHERE  ProductID >= 710;

--lesser than "<" and  greater than ">" use to get results apart from  assigned number. "NOT" placed before ProductID or != 710
SELECT ProductID,
       NAME AS ProductName,
       Color,
       ListPrice,
       SellStartDate
FROM   SalesLT.Product
WHERE  ProductID <> 710;

SELECT ProductID,
       NAME AS ProductName,
       Color AS ProductColor,
       ListPrice,
       SellStartDate
FROM   SalesLT.Product
WHERE  Color = N'White';

--N'White' is different type of string literal
--date using WHERE clause
SELECT ProductID,
       Name AS ProductName,
       Color AS ProductColor,
       ListPrice,
       SellStartDate
FROM   SalesLT.Product
WHERE  SellStartDate = '07/01/2005'; --'JULY 01 2005'

-- SET DATEFORMAT dmy ; to set to date month year
-- '2005-07-01' computer formate
--'2005-07-01  00:00:00' for including date and time Format or using '2005-07-01T00:00:00' and do digit year cutoff current is 1949 to 2049  like '07/01/55' is treated as 1955 example2 '07/01/35' is treated as 2035
SELECT *
FROM   sys.configurations;

--searching through name column
SELECT Name AS ProductName
FROM   SalesLT.Product
--WHERE NAME = 'LL Mountain Frame - Silver, 48' --  we use '=' to get exact infromation 
--WHERE Name LIKE 'LL Mountain Frame%' -- here we use 'LIKE' to get similar informations and '%' in end to get all similar information after LL Mountain Frame%
--WHERE Name LIKE '%Mountain Frame%' -- here we use 'LIKE' to get similar informations and '%' in  start and end to get all similar information before and after %Mountain Frame%
--WHERE Name LIKE '_L Mountain Frame%' -- here we use 'LIKE' to get similar informations and '_' in  start to get all similar information before _L Mountain Frame%
--WHERE Name LIKE '_L Mountain Frame%38' -- here we use 'LIKE' to get similar informations and '_' in  start and end with '%38' to get all similar information before  and after _L Mountain Frame%38
WHERE  Name LIKE '_L Mountain Frame%Black%'; -- here we use 'LIKE' to get similar informations and '_' in  start and end with '%BLACK%'. in middle to get all similar information before  and after _L Mountain Frame%Black%

SELECT DISTINCT Color
FROM   SalesLT.Product
--WHERE Color LIKE 'b%' --where color name starts with b
--WHERE Color LIKE '[BM]%'. ---where color name starts with B and M
--WHERE Color LIKE '[B-M]%' ---where color name starts with B end till M
--WHERE Color LIKE '[B-M]%' ---where color name starts with B end till M
WHERE  Color LIKE '[^B-M]%'; ---where color name but not like starts with B end till M.  'NOT LIKE' '^' in the beginning of letters

SELECT ThumbnailPhotoFileName
FROM   SalesLT.Product
WHERE  ThumbnailPhotoFileName LIKE '%Image_Available%';

SELECT ProductID,
       Name,
       Color,
       ListPrice,
       SellStartDate
FROM   SalesLT.Product
WHERE  Color = 'White'
       OR ProductID < 710;

SELECT ProductID,
       Name,
       Color,
       ListPrice,
       SellStartDate
FROM   SalesLT.Product
WHERE  Color IN ('White', 'Multi');

--RANGE
SELECT ProductID,
       Name,
       Color,
       ListPrice,
       SellStartDate
FROM   SalesLT.Product
--WHERE ProductID >= 710 AND ProductID<720
WHERE  ProductID BETWEEN 710 AND 719;

--NULL Means missing data
SELECT ProductID,
       Name,
       Color,
       ListPrice,
       SellStartDate
FROM   SalesLT.Product
WHERE  Color <> 'White'
       OR Color IS NULL;

--Aggregation and Groupby clauses
SELECT COUNT(*) AS [Number Of Rows]
FROM   SalesLT.Product;

SELECT COUNT(ProductID) AS [Number Of Rows]
FROM   SalesLT.Product;

SELECT COUNT(Weight) AS [Number Of Rows]
FROM   SalesLT.Product;

SELECT COUNT(*) AS [Number Of Rows],
       Count(Weight) AS NonNullRows,
       SUM(Weight) AS WeightSum,
       MIN(Weight) AS WeightMin,
       MAX(Weight) AS WeightMax
FROM   SalesLT.Product;

--Groupby clause
SELECT   Color,
         COUNT(*) AS NumberOfRows
FROM     SalesLT.Product
GROUP BY color;

SELECT DISTINCT Color
FROM   SalesLT.Product;

SELECT   Color AS ProductColor,
         ProductCategoryID,
         COUNT(*) AS NumberOfRows
FROM     SalesLT.Product
GROUP BY color, ProductCategoryID;

SELECT DISTINCT Color,
                ProductCategoryID
FROM   SalesLT.Product;

--HAVING CLAUSE
SELECT   Color,
         COUNT(*) AS NumberOfRows
FROM     SalesLT.Product
GROUP BY Color
HAVING   COUNT(*) >= 30;

--orderby clause
--SELECT *
--SELECT DISTINCT Weight --using distinct in weight column
SELECT   DISTINCT TOP 10 Weight AS WeightKg
FROM     SalesLT.Product
--ORDER BY ProductID
--ORDER BY Name
--ORDER BY SellStartDate
--ORDER BY Name DESC -- to order by in descending order
--ORDER BY Name ASC -- to order by in ascending order
--ORDER BY ProductCategoryID -- non-deterministic
--ORDER BY ProductCategoryID, ProductModelID,ProductID DESC -- this is deterministic
--ORDER BY 5 ASC, 1 DESC --ordered by column 5 ascending order and column 1 descending order - not recommanded if data columns are changed by others
ORDER BY Weightkg;

--USING ALL 6 CLAUSES
SELECT   Color,
         COUNT(*) AS NumberOfRows
FROM     [salesLT].[Product]
WHERE    ProductID > 800
         AND Color IS NOT NULL
GROUP BY Color
HAVING   COUNT(*) > 20
ORDER BY NumberOfRows DESC;

SELECT *
FROM   salesLT.Product;

--section  data types and related functions
DECLARE @myVar AS BIT = 0; -- 0 is used to not store a null -- BIT is a datatype that can store a 1 or 0 here 0 means false and 1 means true

SELECT @myVar AS myVariable;


GO
-- GO ends a batch or series of instructions 
DECLARE @myVar AS INT = 4;

SELECT @myVar AS myVariable;

--
DECLARE @myVar AS TINYINT = 4; --TINYINT can store data from 0 to 255 it use 1 byte of storage , no negative values are allowed

SELECT @myVar AS myVariable;

DECLARE @myVar AS SMALLINT = -4; --SMALLINT can store data from -32768 to 32767 and it uses 2 bytes of storage

SELECT @myVar AS myVariable;

DECLARE @myVar AS INT = -45000; --INT is a signed integer that can store values from -2,147,483,648 to 2,147,483,647 and it uses 4 bytes of storage.

SELECT @myVar AS myVariable;

DECLARE @myVar AS BIGINT = 45000000000; --BIGINT is a signed integer that can store values from -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807 and it uses 8 bytes of storage.

SELECT @myVar AS myVariable;

DECLARE @myVar AS INT = 4;

SELECT @myVar AS myVariable;

SET @myVar = @myVar + 1;

SELECT @myVar - 2 AS myResult; -- we can to all math operations using operators


GO
DECLARE @myVar AS INT = 4;

SELECT @myVar AS myVariable;

SET @myVar = @myVar + 1;

SELECT (@myVar - 2) * 3 AS myResult; -- we can to BODMAS as well here


GO
DECLARE @myVar AS INT = 4;

SELECT @myVar AS myVariable;

SET @myVar = @myVar + 1;

SELECT @myVar % 2 AS myResult; -- we can get remainder of division here


GO
DECLARE @myVar AS INT = 4;

SELECT @myVar AS myVariable;

SET @myVar = @myVar + 1;

SELECT @myVar / 2 AS myResult; -- we just remove remainder and get the result


GO
DECLARE @myVar AS INT = 4;

SELECT @myVar AS myVariable;

SET @myVar = @myVar + 1;

SELECT @myVar / 2.0 AS myResult; -- we can get remainder in fraction if we set divisor in float/decimal


GO
--numbers with decimal places
DECLARE @myVar AS DECIMAL = 123456789.123456789;

SELECT @myVar AS myVariable;

DECLARE @myVar AS SMALLMONEY = 123456.7891; --smallmoney is a currency type that can store values from -214,748.3648 to 214,748.3647 and it uses 4 bytes of storage. it allows up to 4 digits after the decimal point.

SELECT @myVar AS myVariable; -- int/10000 = small money


GO
DECLARE @myVar AS MONEY = 123456789.7891; --money is a currency type that can store values from -9,223,372,036,854,77.5808 to 9,223,372,036,854,77.5807 and it uses 8 bytes of storage. it allows up to 4 digits after the decimal point.

SELECT @myVar AS myVariable; -- bigint/10000 = money


GO
--Approximate numeric. data types: float and real they are used to store approximate values with floating-point representation , not all decimal    
DECLARE @myVar AS FLOAT (24) = 1234.56789; --stores 6 decimal places and uses 4 bytes of storage. and upto 38 digits in float(24).

SELECT @myVar AS myVariable;


GO
DECLARE @myVar AS FLOAT (53) = 1234.56789; --stores 15 decimal places and uses 8 bytes of storage. and upto 308 digits in float(53).

SELECT @myVar AS myVariable;


GO
DECLARE @myVar AS INT;

SELECT @myVar + 2 AS myResult;

SELECT COALESCE (@myVar, 0) + 2 AS myResult;

DECLARE @myVar AS INT;

SELECT @myVar + 2 AS myResult;

SELECT COALESCE (@myVar + 2, 999) AS myResult;

SELECT ISNULL(@myVar + 2, 999) AS myResult;

SELECT IIF (@myVar IS NULL, 0, @myVar + 2) AS myResult;

SELECT CASE WHEN @myVar IS NULL THEN 0 WHEN @myVar = 2 THEN 999 ELSE @myVar + 2 END AS myResult;

SELECT CASE @myVar WHEN NULL THEN 2 ELSE @myVar + 2 END AS myResult;

--Strings
DECLARE @MyVar AS CHAR (20) = 'Hello'; -- char stores exact length of  strings and char(20) allocates 20 bytes of storage space for this string. it fills the remaining space with spaces.   

SELECT @MyVar AS myChar,
       LEN(@MyVar) AS charLength,
       DATALENGTH(@MyVar) AS dataLength;


GO
--Do not use text and ntext data types, as they are deprecated.Use varchar(max) or nvarchar(max) instead
DECLARE @MyVar AS VARCHAR (20) = 'Hello'; -- varchar stores variable length of  strings and varchar(20) allocates  exactly what is needed by the string. no leading or trailing spaces are added. It is efficient for text that vary in length.   

SELECT @MyVar AS myVar,
       LEN(@MyVar) AS varcharLength,
       DATALENGTH(@MyVar) AS dataLength;


GO
--Do not use text and ntext data types, as they are deprecated.Use varchar(max) or nvarchar(max) instead
DECLARE @MyVar AS NVARCHAR (20) = N'Hello#'; -- nvarchar stores variable length of unicode strings and nvarchar(20) allocates  exactly what is needed by the string. no leading or trailing spaces are added. It is efficient for text that vary in length.   

SELECT @MyVar AS myVar,
       LEN(@MyVar) AS varcharLength,
       DATALENGTH(@MyVar) AS dataLength;


GO
--Do not use text and ntext data types, as they are deprecated.Use varchar(max) or nvarchar(max) instead
DECLARE @MyVar AS NVARCHAR (MAX) = N'Hello#'; -- nvarchar(max) stores variable length of unicode strings and nvarchar(max) allocates  exactly what is needed by the string. no leading or trailing spaces are added. It is efficient for text that vary in length.   

SELECT @MyVar AS myVar,
       LEN(@MyVar) AS varcharLength,
       DATALENGTH(@MyVar) AS dataLength;


GO
--Do not use text and ntext data types, as they are deprecated.Use varchar(max) or nvarchar(max) instead
--string functions
DECLARE @MyVar AS NVARCHAR (20) = 'Hello';

SELECT @MyVar + 'World' AS ConcatenatedString, -- + operator is used for concatenation
       UPPER(@MyVar) AS UpperCase, --converts the string to uppercase
       LOWER(@MyVar) AS LowerCase, --converts the string to lowercase
       LEFT(@MyVar, 2) AS LeftPart, --get left part of the string
       RIGHT(@MyVar, 2) AS RightPart, --get right part of the string
       SUBSTRING(@MyVar, 2, 3) AS SubString, --get substring starting from position 2 with length of 3
       LEN(@MyVar) AS StringLength, --get length of the string
       DATALENGTH(@MyVar) AS DataLength, --get data length of the string
       @MyVar + NULL AS NULLString,
       TRIM('Hello World') AS TrimmedString,
       LTRIM('Hello World') AS LTrimmedString,
       RTRIM('Hello World') AS RTrimmedString;


GO
DECLARE @MyString AS NVARCHAR (20) = '3';

DECLARE @MyNumber AS INT = 1;

SELECT @MyString + @MyNumber AS ConcatenatedWithNumber; --- does not work

SELECT @MyString + 1 AS ConcatedWithString; ---change 1 to '1'

SELECT @MyString + CAST (1 AS NVARCHAR (20)) AS ConcatenatedWithString; --works

SELECT @MyString + CONVERT (NVARCHAR (20), 1) AS ConcatenatedWithString; ---works


GO
--converting to number
--DECLARE @MyString NVARCHAR(20)='hello'
DECLARE @MyString AS NVARCHAR (20) = '1.234';

SELECT 1 + 1.234 AS PlusNumber;

SELECT 1.0 + @MyString AS PlusNumber;

SELECT 1 + CAST (@MyString AS DECIMAL (9, 5)) AS PlusNumber;

SELECT 1 + TRY_CAST (@MyString AS DECIMAL (9, 5)) AS PlusNumber;


GO
--Time data types
--DECLARE @myDate as DATE ='2032-02-03T01:02:03.1234567'
--DECLARE @myDate as TIME ='2032-02-03T01:02:03.1234567'
DECLARE @myDate AS DATETIMEOFFSET = '2032-02-03 01:0203.1234567 -05:00'; --doesn't work

--DECLARE @myDate as DATETIME2(0) ='2032-02-03T01:02:03.1234567'
SELECT @myDate AS DateValue,
       DATALENGTH(@myDate) AS DataLength,
       SQL_VARIANT_PROPERTY(@myDate, 'BaseType') AS BaseType,
       SQL_VARIANT_PROPERTY(@myDate, 'Precision') AS Precision,
       SQL_VARIANT_PROPERTY(@myDate, 'Scale') AS Scale;


GO
--Manipulating dates
DECLARE @myDate AS DATETIME2 (7) = '2032-02-03T01:02:03.1234567';

SELECT DATEADD(YEAR, 1, @myDate) AS AddYear,
       DATEADD(MONTH, -1, @myDate) AS AddMonth;


GO
--What is the current date/time?
SELECT GETDATE() AS GetDate,
       SYSDATETIME() AS SysDateTime,
       SYSUTCDATETIME() AS SysUtc,
       SYSDATETIMEOFFSET() AS SysDateTimeOffset;

--Converting dates to numbers
DECLARE @myDate AS DATETIME2 (7) = '2032-02-03T01:02:03.1234567';

SELECT YEAR(@myDate) AS YearValue,
       MONTH(@myDate) AS MonthValue,
       DAY(@myDate) AS DayValue;

DECLARE @myDate AS DATETIME2 (7) = '2032-02-03T01:02:03.1234567';

SELECT DATEPART(YEAR, @myDate) AS YearValue,
       DATEPART(MONTH, @myDate) AS MonthValue,
       DATEPART(DAY, @myDate) AS DayValue,
       DATEPART(HOUR, @myDate) AS HourValue,
       DATEPART(MINUTE, @myDate) AS MinuteValue,
       DATEPART(SECOND, @myDate) AS SecondValue2,
       DATEPART(MILLISECOND, @myDate) AS MillisecondValue,
       DATEPART(MICROSECOND, @myDate) AS MicrosecondValue,
       DATEPART(NANOSECOND, @myDate) AS NanosecondValue;

SELECT DATEPART(QUARTER, @myDate) AS QuarterValue,
       DATEPART(WEEKDAY, @myDate) AS WeekDayValue,
       DATEPART(WEEK, @myDate) AS WeekValue,
       DATEPART(DAYOFYEAR, @myDate) AS DayOfYearValue,
       DATEPART(WEEK, @myDate) AS WeekValue;


GO
--Converting dates to strings
DECLARE @myDate AS DATETIME2 (7) = '2032-02-03T01:02:03.1234567';

DECLARE @myDate2 AS DATETIME2 (7) = '2032-01-01';

SELECT DATEDIFF(DAY, @myDate2, @myDate) AS DayDifference;

SELECT DATEDIFF(MONTH, @myDate2, @myDate) AS MonthDifference,
       DATEDIFF(YEAR, @myDate2, @myDate) AS YearDifference,
       DATEDIFF(HOUR, @myDate2, @myDate) AS HourDifference,
       DATEDIFF(MINUTE, @myDate2, @myDate) AS MinuteDifference,
       DATEDIFF(SECOND, @myDate2, @myDate) AS SecondDifference,
       DATEDIFF(MILLISECOND, @myDate2, @myDate) AS MillisecondDifference,
       DATEDIFF(MICROSECOND, @myDate2, @myDate) AS MicrosecondDifference,
       DATEDIFF(NANOSECOND, @myDate2, @myDate) AS NanosecondDifference;

SELECT DATENAME(WEEKDAY, @myDate) AS WeekDayName,
       DATENAME(MONTH, @myDate) AS MonthName;

SELECT FORMAT(@myDate, 'dd mm yyyy hh:mm:ss.fffffff') AS FormattedDate;

SELECT FORMAT(@myDate, 'D') AS FormattedDate;

SELECT FORMAT(@myDate, 'd') AS FormattedDate;

SELECT FORMAT(@myDate, 'D', 'es-ES') AS FormattedDateInSpanish; --martes, 3 de febrero de 2032


GO
--Converting strings to dates
DECLARE @myString AS NVARCHAR (30) = '2032-02-03 01:02:03.1234567';

SELECT CAST (@myString AS DATETIME2 (7)) AS CastDate,
       TRY_CAST (@myString AS DATETIME2 (7)) AS TryCastDate;


GO
DECLARE @myString AS NVARCHAR (30) = 'Tuesday, 3 February 2032';

SELECT PARSE (@myString AS DATETIME2 (7) USING 'en-US') AS ParseDate,
       TRY_PARSE (@myString AS DATETIME2 (7) USING 'en-US') AS TryParseDate;
GO

--other data types
--binary and varbinary data types
--cursor data type
--geography data type
--geography data type
--hierarchyid data type
--image data type
--sql_variant data type
--xml data type
--uniqueidentifier data type
--json
--rowversion
--table
--vector
--creating tables