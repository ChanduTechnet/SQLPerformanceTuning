-- statistics with more than 10% change

SELECT
    [sch].[name] + '.' + [so].[name] AS [TableName],
    [ss].[name] AS [Statistic],
    [ss].[auto_Created] AS [WasAutoCreated],
    [ss].[user_created] AS [WasUserCreated],
    [ss].[has_filter] AS [IsFiltered], 
    [ss].[filter_definition] AS [FilterDefinition], 
    [ss].[is_temporary] AS [IsTemporary],
    [sp].[last_updated] AS [StatsLastUpdated], 
    [sp].[rows] AS [RowsInTable], 
    [sp].[rows_sampled] AS [RowsSampled], 
    [sp].[unfiltered_rows] AS [UnfilteredRows],
    [sp].[modification_counter] AS [RowModifications],
    [sp].[steps] AS [HistogramSteps],
    CAST(100 * [sp].[modification_counter] / [sp].[rows]
                            AS DECIMAL(18,2)) AS [PercentChange]
FROM [sys].[stats] [ss]
JOIN [sys].[objects] [so] ON [ss].[object_id] = [so].[object_id]
JOIN [sys].[schemas] [sch] ON [so].[schema_id] = [sch].[schema_id]
OUTER APPLY [sys].[dm_db_stats_properties]
                    ([so].[object_id], [ss].[stats_id]) sp
WHERE [so].[type] = 'U'
AND CAST(100 * [sp].[modification_counter] / [sp].[rows]
                                        AS DECIMAL(18,2)) >= 10.00
ORDER BY CAST(100 * [sp].[modification_counter] / [sp].[rows]
                                        AS DECIMAL(18,2)) DESC;