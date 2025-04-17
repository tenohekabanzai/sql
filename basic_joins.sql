select * from orders;
select * from customers;

select * from customers inner join orders 
on customers.id = orders.customer_id;

select * from customers left join orders 
on customers.id = orders.customer_id;

select * from customers right join orders 
on customers.id = orders.customer_id;

-- right join not needed just do left join in reverse order
select * from orders left join customers
on customers.id = orders.customer_id;

select * from customers full join orders 
on customers.id = orders.customer_id;

-- left anti join
select * from customers left join orders on id = customer_id 
where customer_id IS NULL

-- full anti join
select * from customers full join orders on id = customer_id 
where customer_id IS NULL or id IS NULL;

select * from customers left join orders on id = customer_id 
where order_id is not null



