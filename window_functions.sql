-- find total sales across all orders

select * from orders;
select orderid,sales, sum(sales) over () 
from orders;

-- find tot sales for each product

-- granularity changed by groupby 
select productid, sum(sales)
from orders group by productid


-- find tot sales for each product
-- also provide details like orderid, orderdate

-- granularity not changed
select orderid,productid,orderdate,
sum(sales) over(partition by productid) as tot_sales_by_product
from orders order by productid;

