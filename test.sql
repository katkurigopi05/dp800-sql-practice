EXECUTE test.sql ;

SELECT SCHEMA_NAME(schema_id) AS SchemaName,
       name,
       create_date
FROM   sys.tables
WHERE  name = 'tblTest';+-