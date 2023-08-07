-- all statistics, ordered by update_date descending

SELECT  [sch].[name] + '.' + [so].[name] AS [TableName] ,
        [ss].[name] AS [Statistic] ,
        [ss].[auto_Created] AS [WasAutoCreated] ,
        [ss].[user_created] AS [WasUserCreated] ,
        [ss].[has_filter] AS [IsFiltered] ,
        [ss].[filter_definition] AS [FilterDefinition] ,
        [ss].[is_temporary] AS [IsTemporary],
        [sp].[last_updated] AS [StatsLastUpdated], 
        [sp].[rows] AS [RowsInTable], 
        [sp].[rows_sampled] AS [RowsSampled], 
        [sp].[unfiltered_rows] AS [UnfilteredRows],
        [sp].[modification_counter] AS [RowModifications],
        [sp].[steps] AS [HistogramSteps]
FROM    [sys].[stats] [ss]
        JOIN [sys].[objects] [so] ON [ss].[object_id] = [so].[object_id]
        JOIN [sys].[schemas] [sch] ON [so].[schema_id] = [sch].[schema_id]
        OUTER APPLY [sys].[dm_db_stats_properties]
                              ([so].[object_id],[ss].[stats_id]) sp
WHERE   [so].[type] = 'U'
ORDER BY [sp].[last_updated] DESC;
 