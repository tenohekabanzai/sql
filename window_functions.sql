--///////////////////////////////////////////////////////////////////////////
-- WINDOW FUNCTIONS CAN ONLY BE USED IN THE SELECT AND ORDER BY CLAUSE
-- WINDOW FUNCTIONS CANO BE USED TO FILTER DATA
-- CANNOT USE WINDOW FUNCS IN GORUP BY CLAUSE
-- NESTING OF WINDOW FUNCTIONS NOT ALLOWED
-- WINDOW FUNCS EXECUTED ONLY AFTER DATa FILTERING BY WHERE CLAUSE
--///////////////////////////////////////////////////////////////////////////
-- find total sales across all orders
select *
from orders;
select orderid,
    sales,
    sum(sales) over ()
from orders;
-- find tot sales for each product
-- granularity changed by groupby 
select productid,
    sum(sales)
from orders
group by productid -- find tot sales for each product
    -- also provide details like orderid, orderdate
    -- granularity not changed
select orderid,
    productid,
    orderdate,
    sum(sales) over(partition by productid) as sum
from orders;
-- partition by divides rows into grps based on columns
-- # find total sales across all orders
-- also show orderid, orderdate
select orderid,
    orderdate,
    sales,
    sum(sales) over ()
from orders -- # find total sales for each product
    -- also include orderid, orderdate
select orderid,
    orderdate,
    productid,
    sales,
    sum(sales) over(),
    sum(sales) over (partition by productid)
from orders;
-- # find total sales by each (product and orderstatus)
-- also include orderid,orderdate
select orderid,
    orderdate,
    productid,
    sales,
    orderstatus,
    sum(sales) over (partition by productid, orderstatus)
from orders;
-->> order by in OVER(), helps order the window according to column(s)
-- # rank each order by les in desc order
select orderid,
    orderdate,
    sales,
    rank() over (
        order by sales desc
    )
from orders --///////////////////////////////////////////////////////////////////////////
    -- frame helps control the size of the window
    -- OVER(partition by col1 order by col2 rows between con1 and con2)
    -- denoted by rows between condition1 and condition2
select orderid,
    orderdate,
    productid,
    sales,
    orderstatus,
    sum(sales) over (
        partition by orderstatus
        order by orderdate rows between current row
            and 2 following
    )
from orders;
select orderid,
    orderdate,
    productid,
    sales,
    orderstatus,
    sum(sales) over (
        partition by orderstatus
        order by orderdate rows between 2 preceding and current row
    )
from orders;
--///////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////
select orderid,
    orderdate,
    productid,
    sales,
    orderstatus,
    sum(sales) over (
        partition by orderstatus
        order by orderdate
    )
from orders;
-- order by always consists of a frame even if not explicitly defined
-- -> it is the same as a prefix sum here
select orderid,
    orderdate,
    productid,
    sales,
    orderstatus,
    sum(sales) over (
        partition by orderstatus
        order by orderdate rows between unbounded preceding and current row
    )
from orders --///////////////////////////////////////////////////////////////////////////
    --///////////////////////////////////////////////////////////////////////////
    -- RANK CUSTOMERS BASED ON TOTAL SALES
select customerid,
    sum(sales),
    rank() over(
        order by sum(sales) desc
    )
from orders
group by customerid --- here window func can be used with groupby only if the column getting operated upon in the window function is getting selected 
    --///////////////////////////////////////////////////////////////////////////
    --  Aggregate WINDOW FUNCTIONS-
    --///////////////////////////////////////////////////////////////////////////
    -- count ->
    -- COUNT(SALES) OVER (PARTITION BY COL_NAME) -> counts the number of non null entries in that table
    --- # select the total no of orders
select count(*)
from orders;
-- # select tot no of orders and provide details of
-- orderid,orderdate
select orderid,
    orderdate,
    count(*) over()
from orders;
-- # get no of orders for each customer
select orderid,
    orderdate,
    customerid,
    count(*) over(partition by customerid)
from orders;
-- # find total no of customers and find customer details
select customerid,
    firstname,
    lastname,
    score,
    count(*) over() as tot_customer_count
from customers -- # find total no of customers,scores and find customer details
select customerid,
    firstname,
    lastname,
    score,
    count(*) over() as tot_customer_count,
    count(score) over() as score_count
from customers;
-- # check if table ordersarchive contain any duplicate rows
select orderid,
    count(*) over (partition by orderid)
from ordersarchive -- # show only those orders which have duplicates in ordersarchive
select *
from (
        select orderid,
            count(*) over (partition by orderid) as check_pk
        from ordersarchive
    )
where check_pk > 1 --///////////////////////////////////////////////////////////////////////////
    -- sum ->
    -- SUM(SALES) OVER (PARTITION BY COL_NAME) -> returns sum of all non null entries in that table
    -- # find tot sales, tot_sales by product
select orderid,
    orderdate,
    sales,
    productid,
    sum(sales) over() as tot_sales,
    sum(sales) over(partition by productid) as tot_sales_by_product
from orders;
-- # find percent contribution of each product to total sales
select orderid,
    orderdate,
    sales,
    productid,
    sum(sales) over() as tot_sales,
    round(
        cast (sales as numeric) / sum(sales) over() * 100,
        2
    ) as percentage
from orders;
-- find avg sales for each product
select orderid,
    orderdate,
    productid,
    sales,
    round(
        avg(coalesce(sales, 0)) over(partition by productid),
        2
    ) as avg,
    sum(sales) over(partition by productid) as sum,
    count(sales) over(partition by productid) as count
from orders -- find avg scores for each customers
select customerid,
    lastname,
    score,
    round(avg(score) over(), 2) as avg,
    round(avg(coalesce(score, 0)) over(), 2) as avg_withoutnull
from customers;
-- find all orders where sales are higer than avg sales
-- ineffecient code
-- select * from 
-- (select orderid,orderdate,sales,
-- case when sales>avg(sales) over () then 1 else 0 end as take
-- from orders)
-- where take=1
-- proper code
select orderid,
    orderdate,
    sales
from orders
where sales > (
        select avg(sales)
        from orders
    ) --///////////////////////////////////////////////////////////////////////////