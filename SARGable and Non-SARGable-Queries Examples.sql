-- SARGable vs non-SARGable 

-- non-SARGable
SELECT FirstName  FROM Person.Person where LEFT(LastName,1)= 'K'

-- SARGable
SELECT FirstName  FROM Person.Person where LastName  LIKE 'K%'

-- non-SARGable

SELECT ModifiedDate FROM Person.Person where YEAR(ModifiedDate)= 2012

-- SARGable
SELECT ModifiedDate FROM Person.Person where ModifiedDate between '20120101' and '20121231'

-- non-SARGable

SELECT LastName
FROM Person.Person
WHERE CONVERT(CHAR(10),ModifiedDate,121)  = '2012-03-4'

-- SARGable

SELECT LastName
FROM Person.Person
WHERE ModifiedDate = CAST('2012-03-4' AS CHAR(10))

SELECT LastName
FROM Person.Person
WHERE ModifiedDate = '2012-03-4'

-- non-SARGable

select * from Person.Person where LastName like '%Duffy%' and FirstName = 'Terri'

-- SARGable
select * from Person.Person where LastName like 'Duffy%' and FirstName = 'Terri'

