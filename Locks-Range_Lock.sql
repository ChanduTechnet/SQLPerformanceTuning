SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
GO

BEGIN TRAN
UPDATE Production.Product
SET ReorderPoint = 1000
WHERE ReorderPoint = 600
GO

rollback

select * from Production.Product WHERE ReorderPoint = 600
-- step 2
-- the locks can be monitored (RangeX-X)

SELECT resource_type, resource_description, request_mode, request_status, *
FROM sys.dm_tran_locks
WHERE request_session_id = @@SPID
AND request_mode = 'RangeX-X'
GO

-- step 3
-- request_mode is filtered on RangeS-U lock, you will observe that remaining rows in the table are locked with RangeS-U lock mode.

SELECT resource_type, resource_description, request_mode, request_status, *
FROM sys.dm_tran_locks
WHERE request_session_id = @@SPID
AND request_mode = 'RangeS-U'
GO

-- step 4
ROLLBACK TRAN
GO


