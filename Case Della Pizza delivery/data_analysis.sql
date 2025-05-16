
-- -------------------------- A. Pizza Metrics ------------------------------------------
-- How many pizzas were ordered?

select count(*) as pizza_orderd
from runner_orders 
where cancellation is null;

-- How many unique customer orders were made?

select count(distinct customer_id) as unique_customer
from customer_orders;

-- How many successful orders were delivered by each runner?

select runner_id , count(*) as succesfull_orders
from runner_orders
where cancellation is null
group by 1;

-- How many of each type of pizza was delivered?

select p.pizza_name, count(*) as no_of_pizza_delivered 
from customer_orders as c join pizza_names as p using(pizza_id)
group by p.pizza_name;

-- How many Vegetarian and Meatlovers were ordered by each customer?

select c.customer_id, concat(count(*), '  ', p.pizza_name) as no_of_pizza_ordered
from customer_orders as c join pizza_names as p using(pizza_id)
group by c.customer_id, p.pizza_name
order by c.customer_id ;

-- What was the maximum number of pizzas delivered in a single order?

with total_orders as (select order_id, count(*) as total_order from customer_orders
group by 1)
select max(total_order) as max_ordered_pizza  from total_orders
;

-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

set @total_pizza_orders = (select count(*) from customer_orders);

with no_change as (select count(*) as no_chng from customer_orders
where exclusions is null
and extras is null)
select  (@total_pizza_orders - no_chng) as customized, 
		no_chng as no_customized
        from no_change
;

-- How many pizzas were delivered that had both exclusions and extras?

select count(*) as both_exclusion_extra from customer_orders
where exclusions is not null
and extras is not null;

-- What was the total volume of pizzas ordered for each hour of the day?

select hour(order_time) as hour, count(*) as total
from customer_orders
group by 1
order by 1;

-- What was the volume of orders for each day of the week?

select dayname(order_time) as day, count(*) as total
from customer_orders
group by 1
order by 1;



-- -------------------------- B. Runner and Customer Experience ------------------------------------------

-- How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

select week(registration_date), count(*)  from runners
group by 1;

select *, week(registration_date) from runners;

-- What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

select concat(round(avg(timestampdiff(minute, c.order_time, r.pickup_time)),2), ' minute') as avg_time_taking 
from customer_orders as c join runner_orders as r using(order_id);

-- Is there any relationship between the number of pizzas and how long the order takes to prepare?

select customer_id, timestampdiff(minute, c.order_time, r.pickup_time) as prepare_time
from customer_orders as c join runner_orders as r using(order_id)
group by 1,2; -- the order item increase and time for prepare the order is increase

-- What was the average distance travelled for each customer?

select round(avg(distance_km),2) as avg_distance from runner_orders;

-- What was the difference between the longest and shortest delivery times for all orders?

select concat(min(duration_mins), ' minute') as shortest,
		concat(max(duration_mins), ' minute') as longest
        from runner_orders;

-- What was the average speed for each runner for each delivery and do you notice any trend for these values?

select customer_id, count(*) as total_order, time(c.order_time) as order_time, r.distance_km, r.duration_mins 
from customer_orders as c join runner_orders as r using(order_id)
group by 1,3,4,5
order by 1
;
select * from runner_orders;

-- What is the successful delivery percentage for each runner?

with cte2 as (
	with cte as (
    select *, 
	if(cancellation is null , 'Successful Delivery',null) as delivery_status
	from runner_orders)
			select runner_id, count(delivery_status) as successful_delivery, 
			count(*) as total_delivery from cte
			group by 1)
            
            select runner_id, round((successful_delivery / total_delivery)*100,2) as percent
            from cte2
;



-- ------------------------- C. Ingredient Optimisation -----------------------------------------------------

-- What are the standard ingredients for each pizza?

with recursive numbers as (
    select 1 as n
    union all
    select n + 1 from numbers where n < 20
),
split_toppings as (
    select
        r.pizza_id,
        trim(substring_index(substring_index(r.toppings, ',', n), ',', -1)) as topping_id
    from pizza_recipes r
    join numbers on n <= char_length(r.toppings) - char_length(replace(r.toppings, ',', '')) + 1
)
select 
    t.topping_name, 
    count(distinct s.pizza_id) as appears_on_x_many_pizzas
from split_toppings s
join pizza_toppings t on s.topping_id = t.topping_id
group by t.topping_name
having count(distinct s.pizza_id) = 2;


-- What was the most common exclusion?

with recursive numbers as (
    select 1 as n
    union all
    select n + 1 from numbers where n < 20
),
split_extras as (
    select
        co.order_id,
        trim(substring_index(substring_index(co.extras, ',', n), ',', -1)) as topping_id
    from customer_orders co
    join numbers on n <= char_length(co.extras) - char_length(replace(co.extras, ',', '')) + 1
),
filtered_extras as (
    select * from split_extras 
    where length(topping_id) > 0 and topping_id <> 'null'
)
select 
    t.topping_name,
    count(fe.order_id) as extras
from filtered_extras fe
join pizza_toppings t on fe.topping_id = t.topping_id
group by t.topping_name
order by extras desc
limit 1;

-- What was the most commonly added extra?


with recursive numbers as (
    select 1 as n
    union all
    select n + 1 from numbers where n < 20
),
split_exclusions as (
    select
        co.order_id,
        trim(substring_index(substring_index(co.exclusions, ',', n), ',', -1)) as topping_id
    from customer_orders co
    join numbers on n <= char_length(co.exclusions) - char_length(replace(co.exclusions, ',', '')) + 1
),
filtered_exclusions as (
    select * from split_exclusions 
    where length(topping_id) > 0 and topping_id <> 'null'
)
select 
    t.topping_name,
    count(fe.order_id) as exclusions
from filtered_exclusions fe
join pizza_toppings t on fe.topping_id = t.topping_id
group by t.topping_name
order by exclusions desc
limit 1;

