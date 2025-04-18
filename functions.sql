-- select * from customers;

-- SQL functions
-- Single Row functions -> String/Numeric/NULL/DateTime
-- Multi Row functions -> Aggregate/Window


-- String functions
-----------------------------------------------

 -- concat -> concatenates 2 strings
 -- concatenate fname and country into one col
select concat(firstname,country) as cc from customers;

--lower & upper
select lower(firstname), upper(lastname) from customers;

-- trim -> replaces blankspace
select '     Hello ', trim('     Hello ');

-- replace -> REPLACES A CHARACTER/STRING WITH A GIVEN STRING
select '     Hello ', REPLACE('     Hello ',' ','*');
select 'Hello', REPLACE('Hello','Hello','XYZ');

-- length -> retuns how many characters
select length('Hello');

-- left and right -> prints x chars from left or right
select left('Hello',2);
select right('Hello',2);

--- substring (start,length)
select substring('Hello',2,3);


-- Number functions
-----------------------------------------------
-- round (x,number_of_decimal_places)
select round(3.613)
select round(3.613,1),round(3.613,2)

-- abs
select abs(-10)

-- DateTime functions
-----------------------------------


-- NULL functions
-----------------------------------

-- ISNULL(value, replacement_for_NULL) -> replaces null values

-- select isnull(ShippingAddress, 'N/A')
-- orderid  ShippingAddress isnull
-- 1        A               A
-- 2        NULL            N/A

-- select isnull(col1,col2)
-- id   col1    col2    isnull
-- 1    A       B       A
-- 2    NULL    C       C
-- 3    NULL    NULL    NULL



-- COALESCE(val1,cal2,val3 ....) -> returns first non null value form list 
-- can compare more than 2 column but slower than isnull

-- coalesce(col1,col2,col3,'unknown')

-- id   col1    col2    col3    coalesce
-- 1    A       B       X       A
-- 2    NULL    C       Y       C
-- 3    NULL    NULL    Z       Z
-- 3    NULL    NULL    Z       Z

-- # Avg with and without handling null values
select 
customerid , 
score,
avg(score) over () AvgScores,
avg(coalesce(Score,0)) over()   AvgScores2
from customers;


select * from customers;

-- # display fullname and show score+10 as new score for customers
select 
concat(firstname,lastname) as name,
coalesce(score,0)+10 as Score_2,
score
from customers;


-- # sort customers from lowest to highest scores with nulls appearing lastname

-- Strategy 1 for hanlding Null vals
-- replacing null with very large number
select customerid,coalesce(score,1e9) as score, score as old_score from customers order by coalesce(score,1e9);

-- Strategy 2 for hanlding Null vals
-- adding a flag field for NULL values

select
    customerid,
    score,
    case 
        when score is null then 1 
        else 0 
    end as Flag
from customers
order by Flag, score;


--- NULLIF(cal,checkvalue)-> converts value to NULL if it matches checkvalue

-- # find sales price for each order by dividing sales by quantity

select orderid,sales,quantity,
sales / nullif(quantity,0) as sales_per_unit
from orders;

-- # list all details for customers who have not placed any orders

select * from orders;

select * from customers x
left join
orders y on x.customerid = y.customerid
where orderid is null

-- WHEN statement

-- case
--     when cond1 then res1
--     when cond2 then res2
--     ...
--     else result
-- end

-- # list all orders, categorize by High (sales>50) Med(sales?20) and Low

select orderid,sales,
case
    when sales>50 then 'High'
    when sales>20 then 'Med'
    else 'Low' 
    end as X
 from orders order by sales desc;


-- # display gender as full text
select 
EmployeeId,firstname,lastname,
case when gender='M' then 'Male' else 'Female' end as gender
from employees;

-- # change countryname to code via case
select 
case country
    when 'Germany' then 'DE'
    when 'USA' then 'US'
    end as countrycode
from customers;

-- # find avg scores of customers
select customerid,score from customers;

select customerid,score, 
avg(coalesce(score,0)) over () as avg_score 
from customers

-- # how many times each customer has made an order > 30

-- my code
select p.customerid,p.firstname,p.lastname,
    coalesce(sales, 0) as orders_morethanthirty
from customers p
    left join (
        select a.customerid,count(*) sales
        from customers a
            inner join (
                select x.customerid,coalesce(y.sales, 0) as sales
                from customers x
                    left join orders y on x.customerid = y.customerid
                where sales > 30
            ) b on a.customerid = b.customerid
        GROUP BY a.customerid
    ) q on p.customerid = q.customerid


-- efficient code
select c.customerid, c.firstname, c.lastname,
sum(case when o.sales > 30 then 1 else 0 end) as orders_morethanthirty
from customers c
left join orders o on c.customerid = o.customerid
group by c.customerid, c.firstname, c.lastname

--# tot no of customers
select count(*) from customers

-- # tot sales of all orders
select sum(sales),avg(sales),min(sales) ,max(sales) from orders
GROUP BY customerid;


