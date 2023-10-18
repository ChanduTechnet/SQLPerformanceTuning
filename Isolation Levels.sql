CREATE TABLE IsolationTests
(
    Id INT IDENTITY,
    Col1 INT,
    Col2 INT,
    Col3 INT
)
 
INSERT INTO IsolationTests(Col1,Col2,Col3)
SELECT 1,2,3
UNION ALL SELECT 1,2,3
UNION ALL SELECT 1,2,3
UNION ALL SELECT 1,2,3
UNION ALL SELECT 1,2,3
UNION ALL SELECT 1,2,3
UNION ALL SELECT 1,2,3

-- read uncommitted

BEGIN TRAN
UPDATE IsolationTests SET Col1 = 2
--Simulate having some intensive processing here with a wait
WAITFOR DELAY '00:00:10'
ROLLBACK


-- read committed

BEGIN TRAN
UPDATE IsolationTests SET Col1 = 2
--Simulate having some intensive processing here with a wait
WAITFOR DELAY '00:00:10'
ROLLBACK
