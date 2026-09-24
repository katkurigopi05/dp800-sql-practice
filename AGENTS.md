# AGENTS & COPILOT INSTRUCTIONS

These instructions apply to Antigravity (AGY) and GitHub Copilot in the `DP-800` workspace.

Detailed configuration and rules are documented in [.github/copilot-instructions.md](file:///.github/copilot-instructions.md) and [.github/agy-instructions.md](file:///.github/agy-instructions.md).

## Quick Summary
- **Engine**: Microsoft SQL Server / Azure SQL Database (T-SQL)
- **Primary Schema**: `School`
- **Keywords**: Always UPPERCASE (`SELECT`, `FROM`, `WHERE`, `INSERT`, `UPDATE`, `DELETE`, `CREATE`, `ALTER`, `GO`)
- **Schema Qualification**: Always use `School.<TableName>`
- **Core Topics**: Ledger Tables, Temporal Tables (System-Versioned), In-Memory OLTP, Indexing & Query Tuning

## Data Agent
- **Copilot Prompt**: [.github/prompts/data-agent.prompt.md](file:///.github/prompts/data-agent.prompt.md) (`/data-agent`)
