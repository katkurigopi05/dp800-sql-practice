# DP-800 & SQL Project Instructions (Copilot & AGY)

This repository contains SQL practice scripts, notes, and study material for the **DP-800** (Microsoft Azure SQL Database / SQL Server Administration & Development) curriculum.

---

## 1. Environment & Dialect
- **Database Engine**: Microsoft SQL Server / Azure SQL Database
- **Dialect**: Transact-SQL (T-SQL)
- **Primary Schema**: `School` (e.g., `School.Pupils`, `School.Scores`, `School.PupilsLedger`, `School.PupilsInMemory`)

---

## 2. SQL Coding Standards & Conventions
- **Keywords**: Use UPPERCASE for T-SQL keywords (`SELECT`, `INSERT INTO`, `UPDATE`, `DELETE`, `CREATE TABLE`, `ALTER TABLE`, `WHERE`, `JOIN`, `GO`).
- **Schema Qualification**: Always schema-qualify database objects (e.g., `School.Scores` instead of just `Scores`).
- **Batch Terminators**: Use `GO` between discrete DDL/DML batches where required by SQL Server.
- **Naming Conventions**:
  - Tables: PascalCase (e.g., `Pupils`, `PupilsLedger`, `Scores`)
  - Columns: PascalCase (e.g., `PupilID`, `FirstName`, `DateRecorded`)
  - Primary Keys: Typically `<Entity>ID` or `<Entity>sID` (e.g., `PupilID`, `ScoresID`)
- **Data Types**:
  - Use precise types: `INT`, `SMALLINT`, `VARCHAR(n)`, `NVARCHAR(n)`, `DATE`, `DATETIME2(7)`.
  - Avoid deprecated types (e.g., use `DATETIME2` instead of `DATETIME`).

---

## 3. DP-800 Specific Topics & Features in this Workspace
When generating or assisting with queries in this workspace, be aware of these core DP-800 architectural patterns:

1. **Ledger Tables**:
   - Updatable ledger tables: `WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = ...), LEDGER = ON);`
   - Ledger metadata columns: `ledger_start_transaction_id`, `ledger_start_sequence_number`.
   - Verification procedures: `EXEC sp_generate_database_ledger_digest`.
2. **Temporal Tables (System-Versioned)**:
   - Must have `PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime)` and primary key.
3. **In-Memory OLTP**:
   - Memory-optimized tables: `WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA)`.
   - Natively compiled stored procedures.
4. **Performance & Indexing**:
   - Columnstore vs. B-Tree indexes.
   - Covering indexes with `INCLUDE` clauses.
   - Execution plans and query store considerations.

---

## 4. Agent & Copilot Behavior Guidelines
- **Concise & Direct**: Provide clear, ready-to-run T-SQL scripts.
- **Explain DP-800 Concepts**: When introducing new syntax (e.g., Ledger, In-Memory OLTP, Temporal tables), include a brief comment explaining the exam/architectural significance.
- **Safe DDL**: Where applicable for practice scripts, write clean and reproducible scripts (e.g., drop/cleanup commands or non-destructive alterations).
