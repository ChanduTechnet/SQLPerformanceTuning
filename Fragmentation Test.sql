-- Fragmentation Test
DROP TABLE IF EXISTS dbo.FragTest;
GO
CREATE TABLE dbo.FragTest
(
 C1 INT,
 C2 INT,
 C3 INT,
 c4 CHAR(2000)
);

CREATE CLUSTERED INDEX iClustered ON dbo.FragTest (C1);


-- Insert data into dbo.FragTest
WITH Nums
AS (SELECT TOP (10000)
 ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS n
 FROM MASTER.sys.all_columns AS ac1
 CROSS JOIN MASTER.sys.all_columns AS ac2)

INSERT INTO dbo.FragTest
(
 C1,
 C2,
 C3,
 c4
)
SELECT n,
 n,
 n,
 'a'
FROM Nums;
WITH Nums
AS (SELECT 1 AS n
 UNION ALL
 SELECT n + 1
 FROM Nums
 WHERE n < 10000)
INSERT INTO dbo.FragTest
(
 C1,
 C2,
 C3,
 c4
)
SELECT 10000 - n,
 n,
 n,
 'a'
FROM Nums
OPTION (MAXRECURSION 10000);

-- Read few rows
SELECT ft.C1,
 ft.C2,
 ft.C3,
 ft.c4
FROM dbo.FragTest AS ft
WHERE C1
BETWEEN 21 AND 23;

--Reads all rows
SELECT ft.C1,
 ft.C2,
 ft.C3,
 ft.c4
FROM dbo.FragTest AS ft
WHERE C1
BETWEEN 1 AND 10000


