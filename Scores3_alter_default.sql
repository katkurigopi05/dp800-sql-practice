-- ============================================================================
-- Scores3 - APPROACH 2: DEFAULT attached afterwards with ALTER TABLE
-- ----------------------------------------------------------------------------
-- Creates a bare table, then adds the DEFAULT constraints as a separate step.
-- This is the real-world approach: most of the time the table already exists
-- and you cannot go back and re-run CREATE TABLE.
--
-- Same end result as Scores3_inline_default.sql. Run ONE script, not both.
-- ============================================================================


-- ----------------------------------------------------------------------------
-- 1. TEAR DOWN  (order matters)
-- ----------------------------------------------------------------------------
-- Table before sequence - the default constraint is a dependency, so dropping
-- the sequence while the table still references it fails.
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS [School].[Scores3];
GO

DROP SEQUENCE IF EXISTS [dbo].[seqScoresID];
GO


-- ----------------------------------------------------------------------------
-- 2. CREATE THE SEQUENCE
-- ----------------------------------------------------------------------------
-- NO MAXVALUE / NO CYCLE:  MAXVALUE 3 + CYCLE gives 1, 2, 3, 1, 2, 3 ...
--   i.e. duplicate keys from row 4. CYCLE is for rotating slot numbers only.
-- CACHE 50:  trades gap-free numbering for speed. Gaps are normal.
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
-- 3. CREATE THE TABLE  - no defaults yet
-- ----------------------------------------------------------------------------
-- Note there is NO "CONSTRAINT DF_ScoresID DEFAULT ..." here. That is the only
-- difference from approach 1, and having it in both places is exactly what
-- broke the original script.
-- ----------------------------------------------------------------------------
CREATE TABLE [School].[Scores3]
(
    [PupilID]      int         NOT NULL,
    [Score]        smallint    NOT NULL,
    [SetType]      varchar(10) NOT NULL,
    [DateTaken]    date        NULL,
    [ScoresID]     int         NOT NULL,
    [DateRecorded] datetime2   NULL
);
GO


-- ----------------------------------------------------------------------------
-- 4. ATTACH THE DEFAULTS
-- ----------------------------------------------------------------------------
-- Syntax worth memorising - the column name comes LAST, after a second FOR:
--
--     ALTER TABLE <table>
--     ADD CONSTRAINT <name> DEFAULT <expression> FOR <column>;
--
-- That trailing "FOR ScoresID" is the part people forget. Without it SQL Server
-- has no idea which column the default belongs to.
--
-- Adding a default is metadata-only and instant - it does NOT rewrite existing
-- rows. Rows already present keep their values; the default applies to future
-- INSERTs that omit the column. Backfilling old rows needs a separate UPDATE.
-- ----------------------------------------------------------------------------
ALTER TABLE [School].[Scores3]
ADD CONSTRAINT [DF_ScoresID] DEFAULT (NEXT VALUE FOR [dbo].[seqScoresID]) FOR [ScoresID];
GO

ALTER TABLE [School].[Scores3]
ADD CONSTRAINT [DF_DateRecorded] DEFAULT (GETDATE()) FOR [DateRecorded];
GO


-- ----------------------------------------------------------------------------
-- 5. INSERT
-- ----------------------------------------------------------------------------
-- ScoresID and DateRecorded omitted on purpose so the new defaults fire.
-- List them explicitly and you bypass the sequence entirely.
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
-- 6. VERIFY
-- ----------------------------------------------------------------------------
SELECT * FROM [School].[Scores3] ORDER BY [ScoresID];
GO

SELECT [name], [current_value], [minimum_value], [maximum_value],
       [is_cycling], [cache_size]
FROM   sys.sequences;
GO

SELECT dc.[name] AS [constraint_name],
       c.[name]  AS [column_name],
       dc.[definition]
FROM   sys.default_constraints AS dc
JOIN   sys.columns             AS c
       ON  c.[object_id] = dc.[parent_object_id]
       AND c.[column_id] = dc.[parent_column_id]
WHERE  dc.[parent_object_id] = OBJECT_ID('School.Scores3');
GO


-- ----------------------------------------------------------------------------
-- 7. RE-RUNNABLE VARIANT  (pattern worth knowing)
-- ----------------------------------------------------------------------------
-- ALTER TABLE ... ADD CONSTRAINT has no "IF NOT EXISTS". Re-running step 4
-- where the constraint already exists throws:
--   "There is already an object named 'DF_ScoresID' in the database."
-- Constraint names are unique database-wide, not per table, so this bites even
-- after renaming the table. Guard it:
--
--   IF NOT EXISTS (SELECT 1 FROM sys.default_constraints
--                  WHERE [name] = 'DF_ScoresID'
--                    AND [parent_object_id] = OBJECT_ID('School.Scores3'))
--       ALTER TABLE [School].[Scores3]
--       ADD CONSTRAINT [DF_ScoresID]
--           DEFAULT (NEXT VALUE FOR [dbo].[seqScoresID]) FOR [ScoresID];
--
-- ALTER TABLE sits under the IF with no BEGIN/END because it is one statement.
-- Add BEGIN ... END to guard more than one. Never put GO inside the IF block -
-- GO splits the batch and orphans the IF.
-- ----------------------------------------------------------------------------
