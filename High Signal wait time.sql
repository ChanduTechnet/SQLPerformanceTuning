/*

If the signal wait time is a significant portion of the total wait time then it means that tasks 
are waiting a relatively long time to resume execution after the resources that they were 
waiting for became available.

Total wait time = single wait time(Threads in runnable) + resource wait time (Thread waiting for some resources)

Exmple wait type: SOS_SCHEDULER_YIELD
*/

SELECT SUM(signal_wait_time_ms) AS TotalSignalWaitTime ,
 ( SUM(CAST(signal_wait_time_ms AS NUMERIC(20, 2)))
 / SUM(CAST(wait_time_ms AS NUMERIC(20, 2))) * 100 )
 AS PercentageSignalWaitsOfTotalTime
FROM sys.dm_os_wait_stats

/*
Check for the tasks on the individual schedulers CPU 
*/

SELECT scheduler_id ,
 current_tasks_count ,
 runnable_tasks_count
FROM sys.dm_os_schedulers
WHERE scheduler_id < 255