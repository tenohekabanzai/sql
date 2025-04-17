select firstname,lastname from customers
union 
select firstname, lastname from employees



-- union -> returns all distinct rows from both queries 

select firstname,lastname from employees
union 
select firstname, lastname from customers
order by lastname


-- union all includes duplicates as well -> A union B
select firstname,lastname from employees
union all
select firstname, lastname from customers
order by lastname

-- except -> (A - (A intersection B))
-- return unique rows in A but not in B

select firstname,lastname from customers
except
select firstname, lastname from employees
order by lastname

-- find employees who are also customers -> A intersection B
select firstname,lastname from customers
intersect
select firstname, lastname from employees
order by lastname

select * from orders
union
select * from ordersarchive





