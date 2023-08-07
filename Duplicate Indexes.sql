-- Duplicate indexes
SELECT object_schema_name(Object_ID)+'.'+object_name(Object_ID) as tableName,
       count(*) as Similar, ColumnList as TheColumn, 
       max(name)+', '+min(name) as duplicates
FROM 
   (SELECT Object_ID, name,   
     stuff (--get a list of columns
         (SELECT ', ' + col_name(sc.Object_Id, sc.Column_Id)
         FROM  sys.stats_columns  sc
         WHERE sc.Object_ID=s.Object_ID
         AND sc.stats_ID=s.stats_ID
         ORDER BY stats_column_ID ASC
         FOR XML PATH(''), TYPE).value('.', 'varchar(max)'),1,2,'') AS ColumnList
   FROM sys.stats s)f
WHERE OBJECTPROPERTYEX(f.object_id, N'IsUserTable') <> 0
GROUP BY Object_ID,ColumnList 
HAVING count(*) >1