/*

Serializable isolation levels. Range locks

We can avoid non-repeatable reads and phantom reads 

*/



SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
BEGIN TRAN
SELECT * FROM IsolationTests
WAITFOR DELAY '00:00:10'
SELECT * FROM IsolationTests
ROLLBACK

In session 2
INSERT INTO IsolationTests(Col1,Col2,Col3)
VALUES (100,100,100)
