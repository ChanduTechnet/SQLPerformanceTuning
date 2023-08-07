-- Unused Indexes 

SELECT object_Schema_Name(IndexOpStats.object_id)+'.'
         +OBJECT_NAME(IndexOpStats.object_id) AS TableName,
       Indexes.name AS IndexName, 
       LOWER(Indexes.type_desc) AS IndexType,
       SUM(PartitionStats.used_page_count) * 8 AS IndexSizeInKB,
       SUM(IndexOpStats.leaf_insert_count) AS InsertCount,--
       SUM(IndexOpStats.leaf_update_count) AS UpdateCount,--
       SUM(IndexOpStats.leaf_delete_count) AS DeleteCount--
FROM sys.dm_db_index_operational_stats(NULL, NULL, NULL, NULL) IndexOpStats
---parameters are (Database_id, Object_id, index_id, Partition_id)
    INNER JOIN sys.indexes AS Indexes
        ON Indexes.object_id = IndexOpStats.object_id
           AND Indexes.index_id = IndexOpStats.index_id
    INNER JOIN sys.dm_db_partition_stats PartitionStats
        ON PartitionStats.object_id = Indexes.object_id
WHERE OBJECTPROPERTY(Indexes.[object_id], 'IsUserTable') = 1
GROUP BY IndexOpStats.object_id,
         Indexes.name,
         Indexes.type_desc