--SQL Advance Case Study
use case_study2
select * from Dim_customer
select * from DIM_DATE
select * from DIM_LOCATION
select * from DIM_MANUFACTURER
select * from DIM_MODEL
select * from FACT_TRANSACTIONS

--Q1--BEGIN 
	select state
	from FACT_TRANSACTIONS as x
	left join DIM_LOCATION as y
	on x.IDLocation = y.IDLocation
	left join DIM_MODEL as z
	on x.IDModel = z.IDModel
	where [date] between '01-01-2005' and GETDATE()

--Q1--END

--Q2--BEGIN
	select top 1 *
	from
	(
	select Country , State , count(quantity) as qty
	from DIM_LOCATION as x
	left join FACT_TRANSACTIONS as y
	on x.IDLocation = y.IDLocation
	left join DIM_MODEL as z
	on y.IDModel = z.IDModel
	left join DIM_MANUFACTURER as r
	on z.IDManufacturer = r.IDManufacturer
	where Country = 'US'
	group by Country , State
	) as x
	order by qty desc

--Q2--END

--Q3--BEGIN      
	
	SELECT Model_Name,ZipCode,State,count(TotalPrice) as transactions
	FROM DIM_LOCATION AS X
	LEFT JOIN FACT_TRANSACTIONS AS Y
	ON X.IDLOCATION = Y.IDLOCATION
	LEFT JOIN DIM_MODEL as z
	on y.IDModel = z.IDModel
	group by Model_Name,ZipCode,State

--Q3--END

--Q4--BEGIN
select top 1 *
from
(
select IDModel,unit_price,Model_Name
from DIM_MODEL
) as x
order by unit_price

--Q4--END

--Q5--BEGIN
select  Manufacturer_Name , Model_Name ,avg(TotalPrice) as avg_price
from FACT_TRANSACTIONS as x
left join DIM_MODEL as y
on x.IDModel = y.IDModel
left join DIM_MANUFACTURER as z
on y.IDManufacturer = z.IDManufacturer
group by Manufacturer_Name , Model_Name 
order by avg_price desc

--Q5--END

--Q6--BEGIN

select Customer_Name, [YEAR], AVG(TotalPrice) as avg_amt
from DIM_CUSTOMER as x
left join FACT_TRANSACTIONS as y
on x.IDCustomer = y.IDCustomer
left join DIM_DATE as z
on y.Date = z.DATE
where [YEAR] = 2009
group by Customer_Name, [YEAR]
having avg(TotalPrice) > 500 

--Q6--END
	
--Q7--BEGIN 
select  *
from 
(	
select  Model_Name, count(quantity) as qty , [YEAR]
from DIM_MODEL as x
left join FACT_TRANSACTIONS as y
on x.IDModel = y.IDModel
left join DIM_DATE as z
on y.Date = z.DATE	
where year = 2008
group by Model_Name , [YEAR]

intersect
  
select Model_Name, count(quantity) as qty , [YEAR]
from DIM_MODEL as x
left join FACT_TRANSACTIONS as y
on x.IDModel = y.IDModel
left join DIM_DATE as z
on y.Date = z.DATE	
where year = 2009
group by Model_Name , [YEAR]

intersect

select Model_Name, count(quantity) as qty , [YEAR]
from DIM_MODEL as x
left join FACT_TRANSACTIONS as y
on x.IDModel = y.IDModel
left join DIM_DATE as z
on y.Date = z.DATE	
where year = 2010
group by Model_Name , [YEAR]
) as x
order by qty desc


--Q7--END	
--Q8--BEGIN
select top 1 *
from
(
select top 2 IDManufacturer , [year], sum(totalprice*quantity) as totalsales
from DIM_MODEL as x
left join FACT_TRANSACTIONS as y
on x.IDModel = y.IDModel
left join DIM_DATE as z
on y.Date = z.DATE
where [year] = 2009
group by IDManufacturer , [year]
order by totalsales desc
) as x
union

select top 1 *
from
(
select top 2 IDManufacturer , [year], sum(totalprice*quantity) as totalsales
from DIM_MODEL as x
left join FACT_TRANSACTIONS as y
on x.IDModel = y.IDModel
left join DIM_DATE as z
on y.Date = z.DATE
where [year] = 2010
group by IDManufacturer , [year]
order by totalsales desc
) as x
 
 
--Q8--END

--Q9--BEGIN

select Manufacturer_Name
from DIM_MANUFACTURER as x
left join DIM_MODEL as y on x.IDManufacturer= y.IDManufacturer
left join FACT_TRANSACTIONS as z on y.IDModel=z.IDModel 
where YEAR (date) = 2010

except

select Manufacturer_Name
from DIM_MANUFACTURER as x
left join DIM_MODEL as y on x.IDManufacturer= y.IDManufacturer
left join FACT_TRANSACTIONS as z on y.IDModel=z.IDModel 
where YEAR (date) = 2009
	


--Q9--END

--Q10--BEGIN
	
SELECT TOP 10 CUSTOMER_NAME, 
AVG(CASE WHEN YEAR(date) = 2005 THEN TOTALPRICE END) AS AVERAGE_PRICE_2005,
AVG(CASE WHEN YEAR(date) = 2005 THEN QUANTITY END) AS AVERAGE_QTY_2005,
AVG(CASE WHEN YEAR(date) = 2018 THEN TOTALPRICE END) AS AVERAGE_PRICE_2018,
AVG(CASE WHEN YEAR(date) = 2018 THEN QUANTITY END) AS AVERAGE_QTY_2018
FROM DIM_CUSTOMER as x
INNER JOIN FACT_TRANSACTIONS as y ON x.IDCUSTOMER= y.IDCUSTOMER
GROUP BY CUSTOMER_NAME

--Q10--END