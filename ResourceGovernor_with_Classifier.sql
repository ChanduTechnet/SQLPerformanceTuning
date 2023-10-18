-- Create resource governor 

USE MASTER
GO 

-- pool 1 

CREATE RESOURCE POOL [MemRP] WITH(
		min_cpu_percent=0,      -- how much must be assigned to this pool 
		max_cpu_percent=100,    -- how much would be assigned if possible  
		min_memory_percent=0,   -- Min memory to this pool which cannot be shared 
		max_memory_percent=20,  -- Percentage total server memory which is allowed to be used 
		AFFINITY SCHEDULER = AUTO
)

-- update resource governor

ALTER RESOURCE GOVERNOR RECONFIGURE;


GO

CREATE WORKLOAD GROUP [MemWG] WITH(group_max_requests=0, 
		importance=Medium, 
		request_max_cpu_time_sec=0,			 -- how long a single request can take
		request_max_memory_grant_percent=5, -- how much memory a single process can request  
		request_memory_grant_timeout_sec=0,  -- maximum time, in seconds, that a query can wait for..
											 --	memory grant (work buffer memory) to become available.
											 -- value, 0, uses an internal calculation based on query cost to determine the maximum time.		
		max_dop=0							 -- Maxdop allowed		
		) USING [MemRP]

GO

-- update resource governor

ALTER RESOURCE GOVERNOR RECONFIGURE;

GO

-- show the logins

use master 
go 

select s.session_id, s.login_name,g.name  from sys.dm_exec_sessions s
join sys.resource_governor_workload_groups g 
on s.group_id = g.group_id
where s.session_id >50

-- Create classified function 

CREATE FUNCTION udf_memgrants_classifier() RETURNS SYSNAME WITH SCHEMABINDING
AS
BEGIN
  DECLARE @workload_group sysname;
 
  IF ( suser_name() = 'sa')
      SET @workload_group = 'MemWG';
     
  RETURN @workload_group;
END;

-- Apply the classifier 

ALTER RESOURCE GOVERNOR WITH (CLASSIFIER_FUNCTION = [dbo].[udf_memgrants_classifier]);

GO

-- Update the resource governor

ALTER RESOURCE GOVERNOR RECONFIGURE;

GO

-- show the logins

use master 
go 

select s.session_id, s.login_name,g.name  from sys.dm_exec_sessions s
join sys.resource_governor_workload_groups g 
on s.group_id = g.group_id
where s.session_id >50




