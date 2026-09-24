--121. 44. Update an SQL database project and deploy changes
-- Run against the deployed database to confirm the tblTest column definitions.
SELECT c.name,
       TYPE_NAME(c.user_type_id) AS data_type,
       c.max_length / 2          AS char_length
FROM sys.columns AS c
WHERE c.object_id = OBJECT_ID('dbo.tblTest');
