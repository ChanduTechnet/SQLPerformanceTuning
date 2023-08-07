-- insert into a new table 

select * into person.person2 
from person.person

-- Check statistics 

sp_helpstats 'person.person2','All'

select * from Person.person2

select * from Person.person2 
where FirstName = 'Bradley'

select * from Person.person2
where FirstName = 'Bradley'
and LastName = 'A'
and MiddleName = 'C'

dbcc show_statistics ('Person.person2','_WA_Sys_00000006_61BB7BD9')

update Person.person2
set FirstName = 'ABC4'
where BusinessEntityID <= 1000

-- statistics 

SELECT obj.name, obj.object_id, stat.name, stat.stats_id, last_updated, modification_counter  
FROM sys.objects AS obj   
INNER JOIN sys.stats AS stat ON stat.object_id = obj.object_id  
CROSS APPLY sys.dm_db_stats_properties(stat.object_id, stat.stats_id) AS sp  
WHERE modification_counter > 1000;

-- Table stats 

SELECT sp.stats_id, name, filter_definition, last_updated, rows, 
rows_sampled, steps, unfiltered_rows, modification_counter   
FROM sys.stats AS stat   
CROSS APPLY sys.dm_db_stats_properties(stat.object_id, stat.stats_id) AS sp  
WHERE stat.object_id = object_id('person.person3');

select SQRT(1000*19972) + 500 -- 4969.00436339013
