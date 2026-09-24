IF EXISTS (SELECT *
           FROM   sys.objects
           WHERE  object_id = OBJECT_ID(N'[School].[Scores4]')
                  AND type IN (N'U'))
    DROP TABLE [School].[Scores4];