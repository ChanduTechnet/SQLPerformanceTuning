/*
Read commited isolation level, test with multiple scenarios
We can avoid dirty reads by acquiring the locks, 
but cannot avoid non repeatable reads and phantom reads
*/

-- In session 1
BEGIN TRAN
UPDATE IsolationTests SET Col1 = 2
--Simulate having some intensive processing here with a wait
WAITFOR DELAY '00:00:10'
ROLLBACK
-- In Session 2
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SELECT * FROM IsolationTests


-- we get non repeatable reads and phantom reads 

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
SELECT * FROM IsolationTests
WAITFOR DELAY '00:00:10'
SELECT * FROM IsolationTests
ROLLBACK
-- In session 2
UPDATE IsolationTests SET Col1 = -1
