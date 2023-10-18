/* 

Read uncommitted isolation level,execute on two different sessions

*/
BEGIN TRAN
UPDATE IsolationTests SET Col1 = 2
--Simulate having some intensive processing here with a wait
WAITFOR DELAY '00:00:10'
ROLLBACK

-- In Session 2

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT * FROM IsolationTests
