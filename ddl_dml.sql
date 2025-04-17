-- create table customers (
-- 	id serial primary key, 
-- 	first_name varchar(50) not null,
-- 	last_name varchar(50) not null,
-- 	country varchar(50) not null,
-- 	score int
-- );

CREATE TABLE persons (
	id serial PRIMARY KEY, 
	person_name VARCHAR(50) NOT NULL,
	birth_date DATE,
	phone VARCHAR(15) NOT NULL
);

-- insert into table manually
INSERT INTO customers (first_name, last_name, country, score) VALUES
('Liam', 'Walker', 'United States', 87),
('Emma', 'Nguyen', 'Canada', 92),
('Noah', 'Patel', 'India', 76),
('Olivia', 'Ivanov', 'Russia', NULL),
('Elijah', 'Chen', 'China', 65),
('Ava', 'Kowalski', 'Poland', 78),
('William', 'Garcia', 'Mexico', 90),
('Sophia', 'Müller', 'Germany', 82),
('James', 'Dubois', 'France', 88),
('Isabella', 'Tanaka', 'Japan', 95);

select * from customers order by id asc;

select * from persons;

-- insert into persons from customers table
insert into persons (id,person_name,birth_date,phone)
select id,first_name,NULL,'Unknown' from customers;

-- update commands
update customers 
set score =0 where id = 6;
--
update customers 
set score = 100 where country ='Poland';
--
update customers 
set score = 0 where score is null;


-- delete multiple commands
delete from customers where id>5;

-- alter table commands
alter table persons 
add email varchar(50);

-- alter table persons
-- drop column email;

-- drop table persons;
