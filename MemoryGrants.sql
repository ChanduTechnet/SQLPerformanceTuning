-- Repro the issue: 

while (1=1)
begin
DECLARE @xmlMessage XML
DECLARE @x XML
SELECT @x = @xmlMessage.query('for $WC in /AuditMessage/ActiveParticipant, $S in $WC/RoleIDCode return <RoleIDCode UserID= "{$WC/@UserID }" > { $S/@code } </RoleIDCode> ')
end

-- CREATE THE TABLE IN A SEPARATE DATABASE

CREATE TABLE [dbo].[MemoryGrant_info](
[data_capture_time] [datetime] NOT NULL,
[sql_statement] [nvarchar](max) NULL,
[scheduler_id] [int] NULL,
[group_id] [int] NULL,
[pool_id] [int] NULL,
[dop] [smallint] NULL,
[request_time] [datetime] NULL,
[grant_time] [datetime] NULL,
[requested_memory_kb] [bigint] NULL,
[granted_memory_kb] [bigint] NULL,
[required_memory_kb] [bigint] NULL,
[used_memory_kb] [bigint] NULL,
[max_used_memory_kb] [bigint] NULL,
[is_small] [bit] NULL,
[ideal_memory_kb] [bigint] NULL,
[query_cost] [float] NULL,
[timeout_sec] [int] NULL,
[resource_semaphore_id] [smallint] NULL,
[queue_id] [smallint] NULL,
[wait_order] [int] NULL,
[is_next_candidate] [bit] NULL,
[wait_time_ms] [bigint] NULL,
[plan_handle] [varbinary](64) NULL,
[sql_handle] [varbinary](64) NULL,
[session_id] [smallint] NOT NULL,
[program_name] [nvarchar](128) NULL,
[client_interface_name] [nvarchar](32) NULL,
[client_version] [int] NULL,
[host_name] [nvarchar](128) NULL,
[host_process_id] [int] NULL,
[is_user_process] [bit] NOT NULL,
[last_request_start_time] [datetime] NOT NULL,
[last_request_end_time] [datetime] NULL,
[total_elapsed_time] [int] NOT NULL,
[login_name] [nvarchar](128) NOT NULL,
[nt_domain] [nvarchar](128) NULL,
[nt_user_name] [nvarchar](128) NULL,
[login_time] [datetime] NOT NULL,
[transaction_isolation_level] [smallint] NOT NULL,
[request_id] [int] NOT NULL,
[start_time] [datetime] NOT NULL,
[command] [nvarchar](32) NOT NULL,
[blocking_session_id] [smallint] NULL,
[status] [nvarchar](30) NOT NULL,
[wait_resource] [nvarchar](256) NOT NULL,
[wait_time] [int] NOT NULL,
[reads] [bigint] NOT NULL,
[writes] [bigint] NOT NULL,
[logical_reads] [bigint] NOT NULL,
[cpu_time] [int] NOT NULL,
[nest_level] [int] NOT NULL,
[row_count] [bigint] NOT NULL,
[open_resultset_count] [int] NOT NULL,
[open_transaction_count] [int] NOT NULL,
[client_net_address] [varchar](48) NULL,
[connection_id] [uniqueidentifier] NOT NULL,
[protocol_type] [nvarchar](40) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]



--CREATE A JOB TO STORE THE RESULTS OF THE DMV QUERY TO THE TABLE FOR LATER ANALYSIS

INSERT INTO [dbo].[MemoryGrant_info]
SELECT GETDATE() as "data_capture_time",
(SELECT TOP 1 SUBSTRING(txt.text,r.statement_start_offset / 2+1 , 
( (CASE WHEN r.statement_end_offset = -1 
THEN (LEN(CONVERT(nvarchar(max),txt.text)) * 2) 
ELSE r.statement_end_offset END) - r.statement_start_offset) / 2+1)) AS sql_statement,
mg.scheduler_id, mg.group_id, mg.pool_id, mg.dop, mg.request_time, mg.grant_time,
mg.requested_memory_kb, mg.granted_memory_kb, mg.required_memory_kb, mg.used_memory_kb, mg.max_used_memory_kb, mg.is_small, mg.ideal_memory_kb,
mg.query_cost, mg.timeout_sec, mg.resource_semaphore_id, mg.queue_id, mg.wait_order, mg.is_next_candidate, mg.wait_time_ms, 
mg.plan_handle, mg.sql_handle, 
s.session_id,s.program_name,s.client_interface_name,s.client_version,s.host_name,s.host_process_id,s.is_user_process,
s.last_request_start_time,s.last_request_end_time,s.total_elapsed_time,
s.login_name,s.nt_domain,s.nt_user_name,s.login_time,s.transaction_isolation_level,
r.request_id,r.start_time,r.command,r.blocking_session_id,r.status,r.wait_resource,r.wait_time,
r.reads,r.writes,r.logical_reads,r.cpu_time,r.nest_level,r.row_count,r.open_resultset_count,r.open_transaction_count,
c.client_net_address,c.connection_id,c.protocol_type
FROM sys.dm_exec_query_memory_grants mg
INNER JOIN sys.dm_exec_requests r on r.session_id = mg.session_id
INNER JOIN sys.dm_exec_sessions s on r.session_id = s.session_id
INNER JOIN sys.dm_exec_connections c on r.session_id = c.session_id
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle)as txt
ORDER BY mg.requested_memory_kb DESC


select * from [MemoryGrant_info]

-- check the memory grants 

SELECT 
  ((t1.requested_memory_kb)/1024.00) MemoryRequestedMB
  , CASE WHEN t1.grant_time IS NULL THEN 'Waiting' ELSE 'Granted' END AS RequestStatus
  , t1.timeout_sec SecondsToTerminate
  --, t2.[text] QueryText
FROM sys.dm_exec_query_memory_grants t1
  CROSS APPLY sys.dm_exec_sql_text(t1.sql_handle) t2



-- desired memory grants

select 
getdate() as DataCaptureTime, 
mg.* , 
st.dbid, st.objectid, st.text as Query_text, 
qp.query_plan
-- into tbl_track_memory_grants
from sys.dm_exec_query_memory_grants mg
cross apply sys.dm_exec_sql_text(mg.sql_handle) as st
cross apply sys.dm_exec_query_plan(mg.plan_handle) as qp
-- run this portion in a job every 5 or 10 seconds to capture and save the data
-- insert into tbl_track_memory_grants
select 
getdate() as DataCaptureTime, 
mg.* , 
st.dbid, st.objectid, st.text as Query_text, 
qp.query_plan
from sys.dm_exec_query_memory_grants mg
cross apply sys.dm_exec_sql_text(mg.sql_handle) as st
cross apply sys.dm_exec_query_plan(mg.plan_handle) as qp