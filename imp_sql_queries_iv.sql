alter table tablename
add columnname varchar(255)

alter table tablename
drop columnname

truncate table tablename
---can't use where command,all records are removed, ddl commmand, data definition language command,

1) Delete
– Delete is Data Manipulation Language command
-You can specify the tuple that you want to delete.
-DELETE command can have WHERE clause.
– DELETE command eliminate the tuples one-by-one.
– DELETE command acts slower as compared to TRUNCATE.
– DELETE command can be followed either by COMMIT or ROLLBACK.

2) Truncate
– Truncate is a Data Definition Language Command
– It deletes all the tuples from a relation.
– TRUNCATE command do not have WHERE clause.
– TRUNCATE delete the entire data page containing the tuples.
– TRUNCATE is faster as compared to DELETE.
– TRUNCATE command can’t be ROLL BACKED.

delete from tablename
where
--where command can be used, dml command, data manipulation language, specific rows can be deleted

drop table tablename
---removes data as well as table from the database,ddl command

dense_rank () OVER (PARTITION BY ULP_MEMBERSHIP_ID order by BILL_DATE) AS rnk_1


ntile(5) over (ORDER BY pen desc) AS pen_band

------------------------add column in a table---------------------

ALTER TABLE WOT_CUST
ADD COLUMN MAX_UCP_WOT numeric(38,2),
MAX_UCP_WATCHES  numeric(38,2),
AVG_UCP_WATCHES numeric(38,2),
RECENCY_WATCHES INTEGER,
RECENCY_WOT INTEGER,
RECENCY_ENCIRCLE INTEGER,
BRAND_LOYALTY_TLC INTEGER,
BRAND_LOYALTY_INTERNATIONAL_LIC INTEGER,
BRAND_LOYALTY_TI_CLUSTER INTEGER

-----update column with values in a table---------------------
UPDATE WOT_CUST Y
SET Y.MAX_UCP_WOT=T.MAX_UCP FROM 
(SELECT ULPMEMBERSHIPID,MAX(UCP) AS MAX_UCP FROM 
(SELECT ULPMEMBERSHIPID,(UCP_VALUE_GROSS+SCHEME_DISCOUNT_VALUE)/(QUANTITY) AS UCP 
FROM SEM_PU_WTCH.ADMIN.V_FCT_RETAIL_ETP_BI A
INNER JOIN SEM_PU_CUST_ALL.ADMIN.V_TGT_CUST_ALL_UCIC_LYLTY_MAPNG_BI B ON A.POSIDEX_UNIFIED_ID=B.UCIC
INNER JOIN SEM_PU_CUST_ALL.ADMIN.V_DIM_PSX_GLD_EDW_BI C ON B.MOB_MTCHED_LYLTY_ID=C.ULPMEMBERSHIPID
INNER JOIN SEM_PU_WTCH.ADMIN.V_DIM_ITEM_MASTER_ETP_BI D ON A.ITEMCODE=D.ITEMNUMBER
WHERE C.PRIMARY_CUSTOMER=1
AND ULPMEMBERSHIPID IN 
(SELECT ULPMEMBERSHIPID FROM WOT_CUST)
AND CHANNEL IN ('WOT','LWOT')
AND ((UCP_VALUE_GROSS+SCHEME_DISCOUNT_VALUE)/(QUANTITY))>300)O
GROUP BY 1)T
WHERE y.ULPMEMBERSHIPID=T.ULPMEMBERSHIPID


------------------------lag function in netezza---------------------

SELECT year, month_num, sales as current_month_sales, LAG(sales,1) OVER (partition by year order by month_num) prior_month_sales, 
ROUND(100*(current_month_sales - prior_month_sales)/prior_month_sales,1) as percentage_increase 
from monthly_sales 
ORDER BY year, month_num

select sales-lag(sales,1) over(order by mth_id)
from a
order by mth_id


-----------------------------offset command in sql--------------------------
SELECT column_name(s)
FROM table_name
WHERE condition
ORDER BY column_name
OFFSET rows_to_skip ROWS;

----The OFFSET argument is used to identify the starting point to return rows from a result set.
----Basically, it exclude the first set of records.
----Note:
----OFFSET can only be used with ORDER BY clause. It cannot be used on its own.
----OFFSET value must be greater than or equal to zero. It cannot be negative, else return error.


--------------------order of sql queries-------------------------------------
1) FROM, including JOINs
2) WHERE
3) GROUP BY
4) HAVING
5) WINDOW Functions
6) SELECT
7) DISTINCT
8) UNION
9) ORDER BY
10) LIMIT AND OFFSET

--------------------------2nd highest salary using subquery, rank-----------------

select max(salary)
from a
where salary not in (select max(salary) from a)

select max(UCP_VALUE_GROSS)
from ANALYTICS_WORKSPACE.ADMIN.TRANSACTIONS_WAT_VW
where UCP_VALUE_GROSS<(select max(UCP_VALUE_GROSS) from ANALYTICS_WORKSPACE.ADMIN.TRANSACTIONS_WAT_VW)

select *
from
(select rank() over(order by salary desc) as rnk
from a)
where rnk=2

-------------------------ntile-----------------------------------

ntile(5) over (ORDER BY tq_pen desc) AS pen_band

-------------------------------------like function in sql----------
select name from student where length(name)=10 and lower(name) like ‘k%z’

--------------------conditional query-------------
select *
from a
where gender='m' 
or address like '%mumbai%'

-------------alternate record--------------------
Select *
from (
Select * , row_number() OVER(order by empid desc ) As RowNumber from Employee) t
Where t.RowNumber % 2 == 0

Note: In case of odd records do
RowNumber % 2 == 1

---------------------------nvl and nvl2------------------------------
--NVL() takes 2 parameters whereas NVL2()
--takes 3 parameters
--
--NVL(expr1,expr2)
--expr1 is the source value or expression that may
--contain null.
--expr2 is the target value for converting the null.
--If expr1 is null then it will be replaced with expr2 in that particular column
--
--NVL2(expr1,expr2,expr3)
--This function examines expr1.
--If expr1 is not null, then expr2 is returned.
--If expr1 is null, then expr3 is returned.

---------------substring, distinct email domain from employee table-------------------

TO_DATE('2000'||substr(DOB,5,7),'YYYY-MM-DD') as dob_redemp

Select Distinct(Substring(email,(charindex(‘@’,email))+1))
From employee

----------------------remove duplicates without using temp table--------------
select id, count(id)
from a
group by id

select * from
(select *, row_number() over(partition by name order by val) as rnk
from a)
where rnk=1

------------------------common records---------------------------------
select * 
from a 
where a.id in (select distinct id from b)

select * from a


------------Get all employee detail from EmployeeDetail table whose “FirstName” not start with any single character between ‘a-p’

select * from ANALYTICS_WORKSPACE.ADMIN.TRANSACTIONS_WAT_VW limit 10

SELECT * 
FROM ANALYTICS_WORKSPACE.ADMIN.TRANSACTIONS_WAT_VW 
WHERE substr(upper(POS_CUSTOMER_ID),1,1) between 'Q' and 'Z'
limit 10


--------------------------------------difference b/w rank, dense rank and row number------------

Row number simply numbers each row. Rank gives discontinuous rank,
Dense Rank gives continuous rank
Salary – 10000,10000,9000,9000,8000
Row Number – 1,2,3,4,5
Rank – 1,1,3,3,5
Dense Rank – 1,1,2,2,3
In this case Dense Rank was the best choice


------------o/p of query-----------------
select case when null=null then ‘Amit’ else ‘Rahul’ end from dual;
The null=null is always false. so the Answer of this query is Rahul.


-----------------fetch, offset----------------------------

The FETCH argument is used to return a set of number of rows. FETCH
can’t be used itself, it is used in conjuction with OFFSET.
SELECT column_name(s)
FROM table_name
ORDER BY column_name
OFFSET rows_to_skip
FETCH NEXT number_of_rows ROWS ONLY;

----------------difference between View and Store Procedure? (Q. 23)-----------------
KR: Answered
Providing a more detailed answer
View
Does not accept parameters
Can be used in FROM clause. Can be used as a building block in
larger query
Contains only Select query
Cannot perform modification to any table
Store Procedure
Accept Parameters
Cannot be used in FROM clause. Hence, cannot be used a building
block in larger query
Can contains several statements, IF-ELSE, Loop etc
Can perform modification to one or several tables

----------------------------------difference between COUNT(*) and COUNT(ColName)? (Ques. 24)---------------------------
KR: COUNT(*) count the number of rows in result set while
COUNT(ColName) count the number of values
in column ignoring NULL values.

-----------------What is NULLIF? (Q. 29)------------
NULLIF (exp1,exp2): Return NULL if exp1=exp2 else return exp1.

IFNULL? (Q. 30)
KR: IFNULL(exp1,exp2): Return exp1 if it is not NULL else
return exp2.
I: There is a function called ISNULL, what is it used for? (Q.
31)
KR: ISNULL(exp1,value): Return value if exp1 is NULL else
return exp1.

---------------------difference between WHERE and HAVING clause? (Q. 32)
KR:
Both are used to filter the dataset but WHERE is applied first and
HAVING is applied at later stage of query execution.
WHERE can be used in any SELECT query, while HAVING clause
is only used in SELECT queries, which contains aggregate function
or group by clause.
Apart from SELECT queries, you can use WHERE clause with
UPDATE and DELETE clause but HAVING clause can only be
used with SELECT query

---------:SELECT NULL+98 (Q. 41)------------------------
 NULL

----------------------------- Get the name of all the restaurants that starts with any alphabet between a and k. (Q. 45)-----------

SELECT Restaurant
FROM food
WHERE Restaurant LIKE ‘[a-k]%’



-------------------------coalesce--------------------------------

The advantage of the COALESCE() function over the NVL() function is
that the COALESCE function can take multiple alternate values. In simple
words COALESCE() function returns the first non-null expression in the
list.


----------------------ddl, dml, dcl---------------------------------------------
What is DDL?
It is used to define the database structure such as tables. It includes 3
commands:-
a. Create – Create is for creating tables
CREATE TABLE table_name (
 column1 datatype,
 column2 datatype,
 column3 datatype,
 ….
);
b. Alter – Alter table is used to modifying the existing table object in the
database.
ALTER TABLE table_name
ADD column_name datatype
c. Drop – If you drop a table, all the rows in the table is deleted and the
table structure is removed from the database. Once the table is dropped, you
can’t get it back
63. What is DML?
Data Manipulation Language is used to manipulate the data in records.
Commonly used DML commands are Update, Insert and Delete. Sometimes
SELECT command is also referred as a Data Manipulation Language.

Data Control Language is used to control the privileges by granting and
revoking database access permission


-------------------------------concat------------------------------------------

SELECT concat(NAME, CASE WHEN occupation = "Doctor" THEN "(D)" WHEN occupation = "Professor" THEN "(P)" WHEN occupation = "Singer" 
THEN "(S)" WHEN occupation = "Actor" THEN "(A)" END )
FROM OCCUPATIONS ORDER BY NAME; 
SELECT "There are total", COUNT(OCCUPATION), concat(LOWER(OCCUPATION),"s") 
FROM OCCUPATIONS 
GROUP BY OCCUPATION 
ORDER BY COUNT(OCCUPATION) ASC, OCCUPATION ASC


select concat(Name,'(',Substring(Occupation,1,1),')') as Name

from occupations

Order by Name

select concat('There are total',' ',count(occupation),' ',lower(occupation),'s.') as total

from occupations

group by occupation

order by total

-----------------------------------------ntile----------------------------------------

select b1.*,ntile(5) over (ORDER BY mth_diff desc) AS rec, ntile(5) over (ORDER BY no_visits) AS freq,
ntile(5) over (ORDER BY tot_val) AS mon

--------------------------running total-------------------------------

select t1.id, t1.SomeNumt, SUM(t2.SomeNumt) as sum
from @t t1
inner join @t t2 
on t1.id >= t2.id
group by t1.id, t1.SomeNumt
order by t1.id

-----------------------------datediff, day, year, month, day of week--------------------------
SELECT DATEDIFF(year, '2017/08/25', '2011/08/25') AS DateDiff

SELECT dateadd(year, 2, '2011/08/25') AS new_dt

DAYOFWEEK()

SELECT MONTH(CURRENT_TIMESTAMP)

SELECT YEAR(CURRENT_TIMESTAMP)

SELECT MONTHNAME("2017-06-15")

select datename(month, S0.OrderDateTime)


-------------------------------------------pivot, unpivot in sql-----------------------------------------------

SELECT *
FROM gunpermit 
PIVOT (
      SUM(permit) FOR month IN ([2020-04-30], [2020-03-31], 
                                [2020-02-29], [2020-01-31])
      -- If we want the STATE as columns, use the following 
      -- SUM(permit) FOR state IN ([Alabama], [Alaska], [California], [Massachusetts], [North Dakota])
  ) AS pvt_tab
  
  --------------------------------
  SELECT 
  *
FROM   
  gunpermit 
UNPIVOT  
   (
    permit FOR month IN ([2020-04-30], [2020-03-31], 
                         [2020-02-29], [2020-01-31])
) AS unpvt_tab;  


---------------------------------------coalesce------------------------------

SELECT 
    first_name, 
    last_name, 
    COALESCE(phone,'N/A') phone, 
    email
FROM 
    sales.customers
ORDER BY 
    first_name, 
    last_name;


------------------------full outer join-------------------------------

SELECT Customers.CustomerName, Orders.OrderID
FROM Customers
FULL OUTER JOIN Orders ON Customers.CustomerID=Orders.CustomerID
ORDER BY Customers.CustomerName;


------------------necessary condition s for join-----------------------------
Primary conditions for joining two tables on keys:
1. The key column should contain non-NULL values
2. The datatype of both tables’s column should be similar

---------------------------month and year sales flipkart-------------------


select a.mth_id, mth_sales, c.cy_sales
from
(select month(bill_dt) as mth_id, sum(sales) as mth_sales, 2019 as yr
from fact
where bill_dt between '2019-01-01' and  '2019-12-31'
group by month(bill_dt))a
left join
(select *, 2019 as yr
from
(select sum(sale) as cy_sales
from fact
where bill_dt between '2019-01-01' and  '2019-12-31')b)c
on a.yr=c.yr

------------------------------vedantu-------------------

select doctor, singer
from
(select *, case when prof='doctor' then cust_id end as doctor,
case when prof='singer' then cust_id end as singer
from prof)a


-------------------------------noon---------------------------

-----------------------------Q1-------------------------------------------

select city, state, country, city_sales/state_sales as city_share_in_state,
city_sales/country_sales as city_share_in_country,
state_sales/country_sales as state_share_in_country
from
(select city, state, country, sum(tot_sales) over(partition by city)as city_sales,
sum(tot_sales) over(partition by state)as state_sales,
sum(tot_sales) over(partition by country)as country_sales
from
(select city, state, country, sum(sales) as tot_sales
from t
where year(order_dt)=2019
group city, state, country)a)b

----------------------------svwl---------------------------------------------
(select a.*, b.tm as lagged_time
from
(select *, row_number() over(partition by user_id order by dt) as rnk
from t)a
left join
(select *, row_number() over(partition by user_id order by dt) as rnk
from t)b
on a.user_id=b.user_id
and r.rnk=b.rnk+1)c


------------------------------------------Q2------------------------------------------------

select city, state, country
from
(select *, dense_rank() over(partition by country order by tot_sales desc) as rnk
from
(select city, state, country, sum(revenue) as tot_sales
from t
where year(order_dt)=2019
group by city, state, country)a)b
where rnk=2

-------------------------------------------xiaomi---------------------------

select pdt, sum(no_users_2) as cumulative_users, sum(no_users_completed_2) as cumulative_users_completed
from
(select a.*, b.no_users as no_users_2, b.no_users_completed as no_users_completed_2
from
(select date(CREATED_AT) as pdt, count(distinct USER_ID)as no_users,
count(distinct(case when STATUS='completed' then USER_ID end)) as no_users_completed
from wallet_service.orders
group by date(CREATED_AT))a
inner join(select date(CREATED_AT) as pdt, count(distinct USER_ID) as no_users,
count(distinct(case when STATUS='completed' then USER_ID end)) as no_users_completed
from wallet_service.orders
group by date(CREATED_AT))b
on a.pdt-interval'6 days'<=b.pdt
and a.pdt>=b.pdt)c
--where pdt<=to_date('2018-01-01','YYYY-MM-DD')
group by pdt
order by pdt

--------------------------------------------------------------------------

FROM
(ON)
JOIN
WHERE
GROUP BY
(WITH CUBE or WITH ROLLUP)
HAVING
SELECT
DISTINCT
ORDER BY
TOP

