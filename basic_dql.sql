select * from customers;

select first_name,country from customers;

-- order by
select * from customers where score>50 order by score desc;
select * from customers where score>50 order by score asc;
select * from customers order by country asc ,score desc;

-- group by aggregation
select country, sum(score) as tot_score,count(*) as count from customers 
group by country;

select country, sum(score) as tot_score,count(*) as count from customers 
group by country having sum(score)>=100;


select country,avg(score) as avg_score from customers where score>0 
group by country;

select country,avg(score) as avg_score from customers where score>0 
group by country having avg(score)>70;


select distinct(country) from customers;

select * from customers where score is not null 
order by score desc limit 3;

select * from customers where score is not null 
order by score asc limit 2;

select * from customers where not score<60;
select * from customers where country in ('China','Italy');
select * from customers where last_name like '%an%';


