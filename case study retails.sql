--Data prep and analysis
use case_study
select * from Customer
select * from Transactions
select * from prod_cat_info
--Q1 begin 
  select 'transactions' as table_name, count(transaction_id) as count_records
  from Transactions as transaction_count
  union all
  select 'customer' as table_name, count(customer_id)  as count_records
  from Customer as customer_count
  union all
  select 'prod_cat_code' as table_name, count(prod_cat_code)  as count_records
  from prod_cat_info as prod_cat_count


--Q2 Begin
select count(*) as tot_return
from Transactions
where CAST(total_amt as float) < 0

--Q3 BEGIN
select *,
CONVERT(date,tran_date,105)as convertdate
from Transactions

--Q4 BEGIN
select 
max(CONVERT(date,tran_date,105)) as max_date,
min(CONVERT(date,tran_date,105)) as min_date,
DATEDIFF(year, min(CONVERT(date,tran_date,105)), max(CONVERT(date,tran_date,105)) ) as diff_years,
DATEDIFF(MONTH, min(CONVERT(date,tran_date,105)), max(CONVERT(date,tran_date,105)) ) as diff_months,
DATEDIFF(DAY, min(CONVERT(date,tran_date,105)), max(CONVERT(date,tran_date,105)) ) as diff_days
from Transactions

--Q5 BEGIN
select prod_cat
from prod_cat_info
where prod_subcat = 'DIY'

--DATA ANALYSIS

--Q1 BEGIN
SELECT MAX(STORE_TYPE) AS frequently_used
FROM Transactions

--Q2 BEGIN
SELECT 'male' as Gender, COUNT(GENDER) AS count_records from Customer  WHERE GENDER = 'M' 
union all
SELECT 'female' as Gender, COUNT(GENDER) AS count_records from Customer  WHERE GENDER = 'F'


--Q3 BEGIN
SELECT TOP 1 city_code, count(customer_id) as counts
FROM Customer
group by city_code
ORDER BY counts DESC


--Q4 BEGIN
SELECT prod_subcat,prod_cat
FROM prod_cat_info
WHERE prod_cat = 'BOOKS'

--Q5 BEGIN
SELECT prod_cat ,MAX(cast(qty as int)) AS MAX_QTY
FROM prod_cat_info AS X
LEFT JOIN Transactions AS Y
ON X.prod_cat_code = Y.prod_cat_code
GROUP BY prod_cat

-- Q6 BEGIN

SELECT  sum(cast(total_amt as float)) as tot_revenue
FROM prod_cat_info AS X
LEFT JOIN Transactions AS Y
ON X.prod_cat_code = Y.prod_cat_code
where prod_cat in ('electronics' , 'books')
group by prod_cat


--Q7 BEGIN
SELECT customer_Id, COUNT(customer_Id) as transaction_count
FROM Customer AS X
LEFT JOIN Transactions AS Y
ON X.customer_Id = Y.cust_id
where cast(total_amt as float) > 0
group by customer_Id
having customer_Id > 10

--Q8 BEGIN


SELECT sum(cast(total_amt as float))
FROM prod_cat_info AS X
left JOIN Transactions AS Y
ON X.prod_cat_code = Y.prod_cat_code
where prod_cat in ('electronics' , 'clothing')
and
Store_type = 'flagship store'


-- Q9 BEGIN
SELECT prod_subcat_code , sum(cast(total_amt as float)) as tot_revenue
FROM Customer AS X
left join Transactions as y
on x.customer_Id = y.cust_id
where gender = 'm'
and   prod_cat_code = 3
group by prod_subcat_code


--Q10 BEGIN
select top 5 b.prod_subcat, percent_sale,percent_return from
(select prod_subcat,
sum(convert(numeric,total_amt))*100/sum(sum(convert(numeric,total_amt)))over()as percent_sale
from prod_cat_info
left join Transactions
on prod_cat_info.prod_cat_code = Transactions.prod_cat_code
where convert(numeric,qty)>0
group by prod_subcat) as b

left join

(select prod_subcat,
sum(convert(numeric,total_amt))*100/sum(sum(convert(numeric,total_amt)))over()as percent_return
from prod_cat_info

left join Transactions
on prod_cat_info.prod_cat_code = Transactions.prod_cat_code
where convert(numeric,qty)<0
group by prod_subcat )as o
on b.prod_subcat = o.prod_subcat
order by percent_sale desc



--Q11 BEGIN

select cust_id , sum(cast(total_amt as float)) as revenue
from Transactions
where cust_id in 
(select customer_id from Customer
where datediff(year,convert(date,dob,105),GETDATE())between 25 and 35)
and convert (date,tran_date,105)
between dateadd (day,-30 , (select max(convert (date, tran_date , 105)) from Transactions))
and (select max (convert (date, tran_date , 105)) from Transactions)
group by cust_id 

--Q12 BEGIN
select top 1 
prod_cat , sum(cast(total_amt as float)) as total from Transactions as x
left join prod_cat_info as y 
on x.prod_cat_code = y.prod_cat_code
where cast(total_amt as float) < 0 and
 convert (date,tran_date,105)
between dateadd (day,-3 , (select max(convert (date, tran_date , 105)) from Transactions))
and (select max (convert (date, tran_date , 105)) from Transactions)
group by prod_cat
order by 2 desc


--Q13 BEGIN
SELECT TOP 1 Store_type
FROM
(
SELECT Store_type, SUM(CAST(QTY AS numeric)) AS CNT_QTY,
SUM(cast(total_amt as float)) AS CNT_AMT
FROM Transactions AS X
LEFT JOIN prod_cat_info AS Y
ON X.prod_cat_code = Y.prod_cat_code
GROUP BY Store_type
)AS X
ORDER BY CNT_AMT DESC


--Q14 BEGIN
SELECT prod_cat , AVG(cast(total_amt as float)) AS AVG_AMT
FROM Transactions AS X
LEFT JOIN prod_cat_info AS Y
ON X.prod_cat_code = Y.prod_cat_code
GROUP BY prod_cat
having avg(cast(total_amt as float)) > (select AVG(cast(total_amt as float)) from Transactions)

--Q15 BEGIN
SELECT TOP 5 *
FROM
(
SELECT prod_cat, prod_subcat,
SUM(cast(total_amt as float)) AS TOT_REVENUE,
AVG(cast(total_amt as float)) AS AVG_REVENUE,
SUM(CAST(QTY AS numeric)) AS TOT_QUANTITY
FROM Transactions AS X
LEFT JOIN prod_cat_info AS Y
ON X.prod_cat_code = Y.prod_cat_code
GROUP BY prod_cat, prod_subcat
) AS X
ORDER BY TOT_QUANTITY DESC


