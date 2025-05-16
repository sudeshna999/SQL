create database zomato_delivery;


use zomato_delivery;
drop table delivery;

-- step- 2. create table for importing the data using non GUI
create table delivery
(
ID	text ,
Delivery_person_ID	text,
Delivery_person_Age	int,
Delivery_person_Ratings	double,
Restaurant_latitude	double,
Restaurant_longitude	double,
Delivery_location_latitude	double,
Delivery_location_longitude	double,
Order_Date	date,
Time_Orderd	time,
Time_Order_picked	time,
Weather_conditions	text,
Road_traffic_density	text,
Vehicle_condition	int,
Type_of_order	text,
Type_of_vehicle	text,
multiple_deliveries	int,
Festival	text,
City	text,
Time_taken_min int
);