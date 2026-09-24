-- ============================================================================
-- Scores3 - APPROACH 1: inline DEFAULT constraint
-- ----------------------------------------------------------------------------
-- Declares the DEFAULT inside the CREATE TABLE column definition.
-- Use when building the table from scratch and the sequence already exists.
--
-- Run this script OR Scores3_alter_default.sql - never both against the same
-- database, or the second fails: "There is already an object named 'Scores3'".
-- ============================================================================


-- ----------------------------------------------------------------------------
-- 1. TEAR DOWN  (order matters)
-- ----------------------------------------------------------------------------
-- Drop the TABLE before the SEQUENCE. The default constraint depends on the
-- sequence, so reversing this raises:
--   "The sequence object 'seqScoresID' is referenced by a default constraint."
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS [School].[Scores3];
GO

DROP SEQUENCE IF EXISTS [dbo].[seqScoresID];
GO


-- ----------------------------------------------------------------------------
-- 2. CREATE THE SEQUENCE
-- ----------------------------------------------------------------------------
-- A sequence is a standalone schema object, NOT bound to a table - that is the
-- key difference from IDENTITY. One sequence can feed many tables.
--
-- NO MAXVALUE / NO CYCLE:  the original used MAXVALUE 3 + CYCLE, which yields
--   1, 2, 3, 1, 2, 3 ... duplicate ScoresID from row 4 onward.
--   CYCLE suits a rotating slot number, never a key.
--
-- CACHE 50:  SQL Server hands out 50 values from memory before writing the
--   counter to disk. Fast, but an unclean shutdown loses the unused values,
--   leaving gaps. Gaps are expected - a sequence guarantees uniqueness,
--   never contiguity.
-- ----------------------------------------------------------------------------
CREATE SEQUENCE [dbo].[seqScoresID] AS int
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 50;
GO


-- ----------------------------------------------------------------------------
-- 3. CREATE THE TABLE  - defaults declared INLINE
-- ----------------------------------------------------------------------------
-- Naming the constraint (CONSTRAINT DF_ScoresID) is the whole point of writing
-- it out. Omit the name and SQL Server generates DF__Scores3__Score__3B75D760,
-- which you cannot script or drop predictably.
--
-- CREATE TABLE and CREATE SEQUENCE do NOT have to be first in a batch, so they
-- could share one. Split here only for readability.
-- ----------------------------------------------------------------------------
CREATE TABLE [School].[Scores3]
(
    [PupilID]      int         NOT NULL,
    [Score]        smallint    NOT NULL,
    [SetType]      varchar(10) NOT NULL,
    [DateTaken]    date        NULL,

    -- fires only when ScoresID is omitted from the INSERT column list
    [ScoresID]     int         NOT NULL
        CONSTRAINT [DF_ScoresID]     DEFAULT (NEXT VALUE FOR [dbo].[seqScoresID]),

    -- GETDATE() is server local time; SYSUTCDATETIME() gives UTC and matches
    -- datetime2 precision better
    [DateRecorded] datetime2   NULL
        CONSTRAINT [DF_DateRecorded] DEFAULT (GETDATE())
);
GO


-- ----------------------------------------------------------------------------
-- 4. INSERT
-- ----------------------------------------------------------------------------
-- ScoresID and DateRecorded are deliberately LEFT OUT of the column list.
-- A DEFAULT fires only when the column is absent. Supply ScoresID 1..12
-- yourself and the sequence is never touched - sys.sequences.current_value
-- stays NULL, which is what happened in the original script.
-- ----------------------------------------------------------------------------
INSERT INTO [School].[Scores3] ([PupilID], [SetType], [Score], [DateTaken])
VALUES (1, 'Math',    85, '2032-10-01'),
       (2, 'Math',    90, '2032-10-01'),
       (3, 'Math',    78, '2032-10-01'),
       (4, 'Science', 92, '2032-10-01'),
       (5, 'Science', 88, '2032-10-01'),
       (6, 'Science', 80, '2032-10-01'),
       (4, 'Math',    70, '2032-11-02'),
       (5, 'Math',    76, '2032-11-02'),
       (7, 'Math',    91, '2032-11-02'),
       (1, 'Science', 42, '2032-11-02'),
       (2, 'Science', 18, '2032-11-02'),
       (3, 'Science', 80, '2032-11-02');
GO


-- ----------------------------------------------------------------------------
-- 5. VERIFY
-- ----------------------------------------------------------------------------
SELECT * FROM [School].[Scores3] ORDER BY [ScoresID];
GO

-- current_value = last value handed out; expect 12 after one run
SELECT [name], [current_value], [minimum_value], [maximum_value],
       [is_cycling], [cache_size]
FROM   sys.sequences;
GO

-- confirm both defaults exist under the names we chose
SELECT dc.[name] AS [constraint_name],
       c.[name]  AS [column_name],
       dc.[definition]
FROM   sys.default_constraints AS dc
JOIN   sys.columns             AS c
       ON  c.[object_id] = dc.[parent_object_id]
       AND c.[column_id] = dc.[parent_column_id]
WHERE  dc.[parent_object_id] = OBJECT_ID('School.Scores3');
GO
