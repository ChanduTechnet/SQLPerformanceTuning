/*

Repeatable read isolation level. Repeatable reads and cannot avoid phantom reads 

*/
-- In session 1
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRAN
SELECT * FROM IsolationTests
WAITFOR DELAY '00:00:10'
SELECT * FROM IsolationTests
ROLLBACK

-- In session 2

UPDATE IsolationTests SET Col1 = -1
