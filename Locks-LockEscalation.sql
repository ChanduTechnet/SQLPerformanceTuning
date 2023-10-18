create database LockEscalation
GO

--Use the new database:
use LockEscalation
GO

-- Create a test table
CREATE TABLE dbo.Customer
(COLA int IDENTITY (1,1), COLB INT)
GO

--Insert 10000 records
while 1=1
BEGIN
	INSERT dbo.Customer DEFAULT VALUES
	If @@IDENTITY = 10000
	BREAK;
END

-- verify data

SELECT * FROM dbo.Customer
