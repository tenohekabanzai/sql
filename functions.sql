-- select * from customers;

-- SQL functions
-- Single Row functions -> String/Numeric/NULL/DateTime
-- Multi Row functions -> Aggregate/Window


-- String functions
-----------------------------------------------


-- Manipulation functions

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

-- ISNULL(column, replacement_for_NULL) -> replaces null values

-- COALESCE(val1,cal2,val3 ....) -> returns first non null value form list 

select * from customers;