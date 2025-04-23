
--///////////////////////////////////////////////////////////////////////////
-- WINDOW FUNCTIONS CAN ONLY BE USED IN THE SELECT AND ORDER BY CLAUSE
-- WINDOW FUNCTIONS CANO BE USED TO FILTER DATA
-- CANNOT USE WINDOW FUNCS IN GORUP BY CLAUSE
-- NESTING OF WINDOW FUNCTIONS NOT ALLOWED
-- WINDOW FUNCS EXECUTED ONLY AFTER DATa FILTERING BY WHERE CLAUSE

--///////////////////////////////////////////////////////////////////////////
-- find total sales across all orders

select * from orders;
select orderid,sales, sum(sales) over () 
from orders;

-- find tot sales for each product

-- granularity changed by groupby 
select productid, sum(sales) from orders group by productid


-- find tot sales for each product
-- also provide details like orderid, orderdate

-- granularity not changed
select orderid, productid, orderdate, sum(sales) over(partition by productid) 
as sum
from orders;

-- partition by divides rows into grps based on columns

-- # find total sales across all orders
-- also show orderid, orderdate
select orderid,orderdate,sales, sum(sales) over ()
from orders

-- # find total sales for each product
-- also include orderid, orderdate

select orderid,orderdate,productid,sales, 
sum(sales) over(),
sum(sales) over (partition by productid)
from orders;

-- # find total sales by each (product and orderstatus)
-- also include orderid,orderdate
select orderid,orderdate,productid,sales,orderstatus, 
sum(sales) over (partition by productid, orderstatus)
from orders;

-->> order by in OVER(), helps order the window according to column(s)

-- # rank each order by les in desc order

select orderid,orderdate,sales,
rank() over (order by sales desc)
from orders

--///////////////////////////////////////////////////////////////////////////

-- frame helps control the size of the window
-- OVER(partition by col1 order by col2 rows between con1 and con2)
-- denoted by rows between condition1 and condition2


select orderid,orderdate,productid,sales,orderstatus, 
sum(sales) 
over (partition by orderstatus order by orderdate 
rows between current row and 2 following)
from orders;


select orderid,orderdate,productid,sales,orderstatus, 
sum(sales) 
over (partition by orderstatus order by orderdate 
rows between 2 preceding and current row)
from orders;
--///////////////////////////////////////////////////////////////////////////


--///////////////////////////////////////////////////////////////////////////
select orderid,orderdate,productid,sales,orderstatus, 
sum(sales) 
over (partition by orderstatus order by orderdate )
from orders;

-- order by always consists of a frame even if not explicitly defined
-- -> it is the same as a prefix sum here

select orderid,orderdate,productid,sales,orderstatus,
sum(sales)
over (partition by orderstatus order by orderdate
rows between unbounded preceding and current row
)
from orders
--///////////////////////////////////////////////////////////////////////////

--///////////////////////////////////////////////////////////////////////////
-- RANK CUSTOMERS BASED ON TOTAL SALES

select customerid, sum(sales),
rank() over(order by sum(sales) desc)
from orders 
group by customerid

--- here window func can be used with groupby only if the column getting operated upon in the window function is getting selected 
--///////////////////////////////////////////////////////////////////////////

--  Aggregate WINDOW FUNCTIONS-
--///////////////////////////////////////////////////////////////////////////
-- count ->
-- COUNT(SALES) OVER (PARTITION BY COL_NAME) -> counts the number of non null entries in that table

--- # select the total no of orders
select count(*) from orders;


-- # select tot no of orders and provide details of
-- orderid,orderdate

select orderid, orderdate,
count(*) over()
from orders;

-- # get no of orders for each customer
select orderid, orderdate,customerid,
count(*) over(partition by customerid)
from orders;


-- # find total no of customers and find customer details

select customerid, firstname,lastname,score,
count(*) over() as tot_customer_count
from customers

-- # find total no of customers,scores and find customer details

select customerid,firstname,lastname,score,
count(*) over() as tot_customer_count,
count(score) over() as score_count
from customers;

-- # check if table ordersarchive contain any duplicate rows
select orderid,
count(*) over (partition by orderid)
from ordersarchive

-- # show only those orders which have duplicates in ordersarchive
select * from
(select orderid,
count(*) over (partition by orderid) as check_pk
from ordersarchive)
where check_pk>1

--///////////////////////////////////////////////////////////////////////////
-- sum ->
-- SUM(SALES) OVER (PARTITION BY COL_NAME) -> returns sum of all non null entries in that table

-- # find tot sales, tot_sales by product
select orderid,orderdate,sales,productid,
sum(sales) over() as tot_sales,
sum(sales) over(partition by productid) as tot_sales_by_product
from orders;

-- # find percent contribution of each product to total sales

select orderid,orderdate,sales,productid,
sum(sales) over() as tot_sales,
round(cast (sales as numeric)/sum(sales)  over() *100,2) as percentage
from orders;


-- find avg sales for each product
select orderid,orderdate,productid,sales,
round(avg(coalesce(sales,0)) over(partition by productid),2) as avg,
sum(sales) over(partition by productid) as sum,
count(sales) over(partition by productid) as count
from orders

-- find avg scores for each customers
select customerid,lastname, score,
round(avg(score) over(),2) as avg,
round(avg(coalesce(score,0)) over(),2) as avg_withoutnull
from customers;

-- find all orders where sales are higher than avg
-- my query
select * from 
(
    select orderid,orderdate,productid,sales,
    round(avg(sales) over (),2) as avg
    from orders
)
where sales>avg

-- effecient query
select orderid,orderdate,productid,sales
from orders
where sales > (select avg(sales) from orders)

--///////////////////////////////////////////////////////////////////////////

-- MIN/MAX ->
-- MIN(SALES) OVER (PARTITION BY COL_NAME) -> returns min of all non null entries in that table

-- # find lowest sales by product
select orderid,productid,sales,
min(sales) over (partition by productid) as mini
from orders

-- # find highest sales by product
select orderid,productid,sales,
max(sales) over (partition by productid) as maxi
from orders

-- # find highest and lowest sales by product
select orderid,productid,sales,
max(sales) over (partition by productid) as maxi,
min(sales) over (partition by productid) as mini
from orders

-- # find emp with highest salaries
select * from employees
where salary=(select max(salary) from employees)

-- # find deviation of sales amt from max and min
select * from 
(
    select orderid,sales,
    max(sales) over (),
    min(sales) over (),
    sales-min(sales) over () as devn_min,
    (max(sales) over ())-sales as devn_max
    from orders
)

-- # find the moving average of sales for each product over time
select orderid,productid,sales,
round(avg(sales) over (partition by productid),2) as avg,
round(avg(sales) over (partition by productid order by orderdate),2) as moving_avg
from orders

select orderid,productid,sales,
round(avg(sales) over (partition by productid),2) as avg,
round(avg(sales) over (partition by productid order by orderdate rows between current row and 1 following),2) as moving_avg
from orders


--///////////////////////////////////////////////////////////////////////////


--  Ranking WINDOW FUNCTIONS- Used for Top N and bottom N analyses
--///////////////////////////////////////////////////////////////////////////
-- rank functions

-- row_number() -> assign a row number to every tuple, cannot handle ties, leaves no gaps in numbering
-- row_number() over (order by sales desc)

-- # rank every order by sales amount
select orderid,productid,sales,
row_number() over(order by sales desc) as sales_rank
from orders

-- rank() -> assigns rank to every row, can handle ties , leaves gaps in ranking
-- rank() over (order by sales desc)

-- # rank every order by sales amount
select orderid,productid,sales,
rank() over(order by sales desc) as sales_rank
from orders


-- dense_rank() -> same as rank leaves no gaps in ranking
-- dense_rank() over (order by sales desc)

-- # rank every order by sales amount
select orderid,productid,sales,
dense_rank() over(order by sales desc) as sales_rank
from orders

-- # rank every order by sales amount
select orderid,productid,sales,
row_number() over(order by sales desc) as sales_row_num,
rank() over(order by sales desc) as sales_rank,
dense_rank() over(order by sales desc) as sales_rank_dense
from orders


-- # select the top highest sales for each product
select * from
(select orderid,productid,sales,
row_number() over(partition by productid order by sales desc) rankbyproduct
from orders)
where rankbyproduct=1;



--select lowest 2 customers based on total sales

select * from (
select customerid,sum(sales),
row_number() over(order by sum(sales)) as rank
from orders
group by customerid)
where rank<3

-- identify duplicate rows in ordersarchive and return cleaned data
select * from
(select *,
row_number() over(partition by orderid order by creationtime desc) as rank
from ordersarchive) where rank=1

--///////////////////////////////////////////////////////////////////////////
-- ntile -> group buckets into buckets
-- ntile(2) over (order by sales desc)

select orderid,sales,
ntile(4) over (order by sales desc) as nt4,
ntile(3) over (order by sales desc) as nt3,
ntile(2) over (order by sales desc) as nt2,
ntile(1) over (order by sales desc) as nt1
from orders

-- # segment all orders into 3 categories-> high/med/lowest

select orderid,sales,
case rank
when 1 then 'high'
when 2 then 'mid'
else 'low'
end as category
from
(select orderid,sales,
ntile(3) over(order by sales desc) as rank
from orders)

-- # divide orders into 2 groups

select *,
ntile(2) over(order by orderid) as ntile
from orders;

-- find products that fall within the highest 40% of the prices
select * from
(select *,
percent_rank() over (order by price desc)
from products)
where percent_rank <= 0.4

--///////////////////////////////////////////////////////////////////////////
--  Value WINDOW FUNCTIONS-> access a value from other row --///////////////////////////////////////////////////////////////////////////

-- value functions
-- lead() -> access a value from next row within a window
-- lag() -> access a value from prev row within a window

-- lead(Sales,2,10) over (partition by ProductID order by orderdate)
-- the above exp means give 2nd from row after current in window, or return 10 in case of null

-- lead(Sales) over (order by month)
-- lag(Sales) over (order by month)

-- find Month over Month performance by finding the percentage change in sales
-- in percentage change in sales b/w current and prev months

select ordermonth,curr_sales,
lag(curr_sales) over(order by ordermonth) as prev_sales,
round((cast(curr_sales - lag(curr_sales) over(order by ordermonth) as double precision)/curr_sales)*100,2) as diff
from
(select 
extract(month from orderdate) as ordermonth,
sum(sales) as curr_sales
from orders group by ordermonth)

-- # find loyalty of customers by avg days b/w their orders
-- rank customers on basis of their loyalty

select customerid,round(avg(days_gap),2),
rank() over(order by avg(days_gap)) from
(select customerid,orderdate,
lead(orderdate) over(partition by customerid order by orderdate) as next_orderdate,
lead(orderdate) over(partition by customerid order by orderdate) - orderdate as days_gap
from orders)
group by customerid order by avg(days_gap)

-- # show the no of days gaps b/w current order and next order for every order

(select customerid,orderdate,
lead(orderdate) over(partition by customerid order by orderdate) as next_orderdate,
lead(orderdate) over(partition by customerid order by orderdate) - orderdate as days_gap
from orders)

-- find highest and lowest sales for each product

select orderid,productid,sales,
first_value(sales) over(partition by productid order by sales desc),
last_value(sales) over(partition by productid order by sales desc rows between current row and unbounded following)
from orders;


--///////////////////////////////////////////////////////////////////////////

