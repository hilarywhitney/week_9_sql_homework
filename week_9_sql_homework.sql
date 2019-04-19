Use sakila;

-- 1a. Display the first and last names of all actors from the table actor.
select 
first_name
,last_name
from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select
concat(first_name, ' ', last_name) as "Actor Name"
from actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select
actor_id
,first_name
,last_name
from actor
where first_name = "Joe";

-- 2b. Find all actors whose last name contain the letters GEN

select
actor_id
,first_name
,last_name
from actor
where last_name like "%gen%";

-- 2c.Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select
actor_id
,first_name
,last_name
from actor
where last_name like "%li%"
order by last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
Select 
country_id
, country
from country
where country in ("Afghanistan", "Bangladesh", "China");

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
alter table actor
add description blob;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
alter table actor
drop description;

-- 4a/b. List the last names of actors, as well as how many actors have that last name.
select
last_name
, count(last_name) as "Count_Actors"
from actor
group by last_name
having Count_Actors >= 2;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
update actor
set first_name = "HARPO" 
where first_name = "GROUCHO" and last_name = "Williams";

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
update actor
set first_name = "GROUCHO"
where first_name = "Harpo" and last_name = "Williams";

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

CREATE TABLE `address` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;


-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select 
first_name
, last_name
, address
from staff as s
join address as a on s.address_id = a.address_id;

select * from payment;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select 
first_name
, last_name
, sum(amount) as "Total Rung Up"
from staff as s
join payment as p on s.staff_id = p.staff_id
where month(payment_date) = 8
and year(payment_date) = 2005
group by s.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

select
title
,count(actor_id) as "# Actors"
from film as f
inner join film_actor as fa on f.film_id = fa.film_id
group by f.film_id;


-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
use Sakila;

select count(i.film_id) as "Hunchback Impossible Count" 
from inventory i
join film f on f.film_id = i.film_id
where title like '%hunchback imposs%';

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:

select 
first_name
,last_name
, sum(amount) as "Total Paid"
from payment p 
join customer c on c.customer_id = p.customer_id
group by p.customer_id
order by last_name;