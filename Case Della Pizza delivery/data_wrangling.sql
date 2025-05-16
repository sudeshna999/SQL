 -- ....................*DATA WRANGLING*........................
 
 -- -------------- DATA CLEANING ----------------------
  use casa_della_pizza;
  set sql_safe_updates = 0;
 -- customer order table 
 
  update customer_orders
  set exclusions = null
  where exclusions = 'null' or exclusions = '';
  
update customer_orders
set extras = null
where extras = 'null' or extras = '';

-- runner order table

update runner_orders
set distance = null
where distance = 'null' or distance = '';

update runner_orders
set Duration = null
where Duration = 'null' or Duration = '';

update runner_orders
set Cancellation = null
where Cancellation = 'null' or Cancellation = '';

update runner_orders
set pickup_time = null
where pickup_time = 'null' or pickup_time = '';

update runner_orders
set distance = trim(replace(distance,'km',''));

update runner_orders
set duration = left(duration,2);

alter table runner_orders
change distance distance_km float;
alter table runner_orders
change duration duration_mins float;

-- duplicate handle

CREATE TEMPORARY TABLE temp_topings AS
SELECT DISTINCT topping_id, topping_name
FROM pizza_toppings;

SELECT * FROM temp_topings;
DELETE FROM pizza_toppings;

INSERT INTO pizza_toppings (topping_id, topping_name)
SELECT topping_id, topping_name
FROM temp_topings;

DROP TEMPORARY TABLE temp_topings;
select * from pizza_toppings;



select * from customer_orders;
  select * from pizza_names;
  select * from pizza_recipes;
  select * from pizza_toppings;
  select * from runner_orders;
  select * from runners;
