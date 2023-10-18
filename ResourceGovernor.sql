-- Check state of the resource governor 

select * from sys.resource_governor_configuration

-- Enable resource governor 

ALTER RESOURCE GOVERNOR RECONFIGURE

-- Disable resource governor

ALTER RESOURCE GOVERNOR DISABLE

-- show the logins

use master 
go 

select s.session_id, s.login_name,g.name  from sys.dm_exec_sessions s
join sys.resource_governor_workload_groups g 
on s.group_id = g.group_id
where s.session_id >50


--Get the resource governor resource pool 

select * from sys.dm_resource_governor_resource_pools 

-- Get the stored metadata for classifiers 

select OBJECT_SCHEMA_NAME(classifier_function_id) As 'classifier UDF schema in metadata',
OBJECT_NAME(classifier_function_id) As 'Classifier UDF name in metadata'	
from sys.resource_governor_configuration


-- get statistics on pool 

select name, [start] =statistics_start_time,
cpu = total_cpu_usage_ms,
memgrant_timeouts = total_memgrant_timeout_count,
out_of_mem = out_of_memory_count,
mem_waiters = memgrant_waiter_count
from sys.dm_resource_governor_resource_pools
where pool_id > 1

-- Get statistics on workgroup 

select 
name, start = statistics_start_time,
	waiter = queued_request_count, -- or total_queued_request_count 
	cpu_violations = total_cpu_limit_violation_count,
	subopt_plans = total_suboptimal_plan_generation_count,
	reduced_mem = total_reduced_memgrant_count
from 
sys.dm_resource_governor_workload_groups
where group_id > 1
