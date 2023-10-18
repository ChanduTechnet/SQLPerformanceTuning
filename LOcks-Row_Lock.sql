USE AdventureWorks2014
GO
--  update a rows 
BEGIN TRAN
UPDATE Production.Product
SET SafetyStockLevel = 1500
WHERE ProductNumber = 'AR-5381'
GO

-- We can see the lock type and resource 

SELECT resource_type, resource_description, request_mode, request_status, *
FROM sys.dm_tran_locks
WHERE request_session_id = @@SPID
GO


-- Identify the row with hash key

SELECT * FROM production.product
WHERE %%lockres%% = '(8194443284a0)'                                                                                   
