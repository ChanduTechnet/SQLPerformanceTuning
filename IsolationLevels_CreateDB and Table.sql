/*

Create a sample database, table and insert few records
*/

Create database Isolation

use Isolation


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
