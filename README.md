# DP-800 T-SQL practice on Azure SQL Database

My practice work for **DP-800: Microsoft SQL Server AI Developer**, covering the database development topics: T-SQL from `SELECT` to programmability objects, JSON, regular expressions, graph tables, indexing and partitioning, in-memory, temporal, external and ledger tables, and a SQL database project built and deployed with GitHub Actions.

The embeddings, vector search and RAG topics are in a separate repo: [dp800-sql-embeddings-vector-search](https://github.com/katkurigopi05/dp800-sql-embeddings-vector-search).

## Highlights

- **CI/CD for a database:** a SQL database project (`Microsoft.Build.Sql`) is built into a `.dacpac` by GitHub Actions and published to Azure SQL Database with `azure/sql-action`. Changes to the `tblTest` table were made on a `dev` branch and merged through pull requests.
- **Updatable views:** `INSTEAD OF` insert, update and delete triggers make a view that joins two tables accept changes.
- **Recursive CTE:** a friends-of-friends query over a `PupilFriends` table, written longhand level by level first and then as one recursive CTE.
- **Newer T-SQL features:** the `JSON` data type and JSON indexes, `REGEXP_*` functions, fuzzy matching with `EDIT_DISTANCE` and `JARO_WINKLER_SIMILARITY`, and graph tables queried with `MATCH`.

## Topics covered

| Topic | Where |
|---|---|
| `SELECT`, `WHERE`, `GROUP BY`, `HAVING`, `ORDER BY`; numeric, string and date types and their functions | `---DP-800.sql` |
| Tables, `PRIMARY KEY`, `UNIQUE`, `CHECK`, `DEFAULT` and `FOREIGN KEY` constraints, sequences, joins | `tables.sql`, `Scores3_inline_default.sql`, `Scores3_alter_default.sql` |
| Week 1 recap: sequences, nonclustered indexes, JSON columns, temporal, ledger and graph tables, partitioning | `week1-database-objects/week1.sql` |
| Views with `WITH CHECK OPTION` (plus the `ENCRYPTION`, `SCHEMABINDING` and `VIEW_METADATA` options), `INSTEAD OF` triggers, derived tables, correlated subqueries, `EXISTS` | `StartOfSection9.sql` |
| Window functions: `ROW_NUMBER`, `RANK`, `DENSE_RANK`, `NTILE`, `LAG`/`LEAD`, `FIRST_VALUE`/`LAST_VALUE`, `CUME_DIST`, `PERCENTILE_CONT` | `StartOfSection10.sql` |
| `UNION`, `INTERSECT`, `EXCEPT`, and non-recursive and recursive CTEs | `StartOfSection11.sql` |
| Stored procedures, `TRY…CATCH` error handling with `ERROR_*` functions, scalar and table-valued functions | `StartOfSection12.sql` |
| `JSON` data type, `JSON_OBJECT`, `JSON_ARRAY`, `JSON_ARRAYAGG`, `JSON_CONTAINS`, `OPENJSON`, `JSON_VALUE`, `CREATE JSON INDEX` | `StartOfSection13.sql` |
| `REGEXP_LIKE`, `REGEXP_REPLACE`, `REGEXP_SUBSTR`, `REGEXP_INSTR`, `REGEXP_COUNT`, `REGEXP_MATCHES`, `REGEXP_SPLIT_TO_TABLE`; fuzzy string matching; node and edge tables with `MATCH` | `StartOfSection14.sql` |
| Index rebuild, reorganize and disable, covering indexes, partition functions and schemes, columnstore indexes | `StartOfSection15.sql` |
| Memory-optimized tables, temporal tables queried with `FOR SYSTEM_TIME`, external tables over Azure Blob Storage, updatable ledger tables and `sp_generate_database_ledger_digest` | `StartOfSection16.sql` |
| SQL database project with a publish profile and post-deployment script | `DP-800dbProj/` |
| Build on every push and pull request to `main`, deploy to Azure SQL on demand | `.github/workflows/My1stWorkFlowInDP800.yml` |
| GitHub Copilot custom instructions and prompt files (`/data-agent`, `/explain-plan`, `/review-sql`, `/tune-query`, `/dp800-features`) | `.github/`, `AGENTS.md` |
| Mind maps of the first two study days | `day1_database_objects_mindmap.png`, `day2_storage_access_mindmap.png` |

The other `.sql` files at the root are short scratch queries saved from the editor.

## Running the scripts

The scripts target Azure SQL Database with the AdventureWorksLT sample (`SalesLT` schema). Each `StartOfSection` file starts with the course's setup block, which recreates the `School` schema and its sample data, followed by my work for that section.

The external table part of `StartOfSection16.sql` has placeholders for the storage account, SAS token and master key password. Replace them with your own before running it.

### Build and deploy the database project

```bash
cd DP-800dbProj
dotnet build                                                      # produces bin/Debug/DP-800dbProj.dacpac
az login
SQL_SERVER=<your-server>.database.windows.net ./publish.sh --preview   # writes the change script only
SQL_SERVER=<your-server>.database.windows.net ./publish.sh             # publishes to DP800Free
```

`publish.sh` signs in with a Microsoft Entra access token from the Azure CLI, so no SQL password is stored anywhere.

In GitHub Actions, the build job runs on pushes and pull requests to `main` and uploads the `.dacpac` as an artifact. The deploy job only runs when started by hand from the Actions tab, and needs `AZURE_CREDENTIALS` and `SQL_CONNECTION_STRING` repository secrets.

## What I learned

- **Post-deployment scripts run on every publish**, so a `CREATE TABLE` there fails the second time (`Msg 2714`, object already exists). Tables belong in the project model; the post-deployment script should only hold repeatable DML such as `MERGE`.
- **`DropObjectsNotInSource=False` in the publish profile** stops the deploy from dropping tables that exist in the database but not in the project (here the `School` and `SalesLT` tables).
- **`azure/sql-action` doesn't run on macOS runners**, so the deploy job runs on `ubuntu-latest`, where `sqlpackage` is no longer preinstalled: install it with `dotnet tool install --global microsoft.sqlpackage`.
- **An `INSERT` through a view can only change one base table.** A view over `Scores` joined to `Pupils` needs `INSTEAD OF` triggers to send each column to the right table.
- **A `DEFAULT` that uses a sequence makes the table depend on it**, so drop the table before the sequence.
- **Once a unique rule is a `UNIQUE` constraint, `DROP INDEX` no longer removes it** (`Msg 3723`). Use `ALTER TABLE … DROP CONSTRAINT` instead.
- **`ORDER BY` on a non-unique column is non-deterministic.** Add a unique column such as `ProductID` as the last sort key to get a stable order.

## Data attribution

`Reviews.csv` is derived from [SAP-samples/datahub-dine](https://github.com/SAP-samples/datahub-dine) (Apache License 2.0), as adapted for the DP-800 course. See the header of that file. The setup blocks at the top of the `StartOfSection` files come from the course.
