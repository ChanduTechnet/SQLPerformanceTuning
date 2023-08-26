-- Live troubleshooting 

select wait_type,wait_time,cpu_time,total_elapsed_time, * from sys.dm_exec_requests
where session_id = 60

select wait_duration_ms,session_id, * from sys.dm_os_waiting_tasks
where session_id = 60

select cpu, * from sys.sysprocesses
where spid = 60

select * from sys.dm_os_latch_stats

select * from sys.dm_os_wait_stats

