-- Analyze delivery ratings over time

SELECT 
  Order_Date,
  ROUND(AVG(Delivery_person_Ratings), 2) AS Avg_Rating
FROM delivery
GROUP BY Order_Date
ORDER BY Order_Date;

-- Average rating of each delivery partner

SELECT 
  Delivery_person_ID,
  ROUND(AVG(Delivery_person_Ratings), 2) AS Avg_Rating,
  COUNT(*) AS Total_Deliveries
FROM delivery
GROUP BY Delivery_person_ID
ORDER BY Avg_Rating DESC;

-- Most popular food order type in each city

SELECT 
  City,
  Type_of_order,
  COUNT(*) AS Total_Orders,
  RANK() OVER (PARTITION BY City ORDER BY COUNT(*) DESC) AS Popularity_Rank
FROM delivery
GROUP BY City, Type_of_order;

-- Most common delivery locations (lat/long frequency)

SELECT 
  concat('lat ',Delivery_location_latitude,
  ' long ', Delivery_location_longitude) as location,
  COUNT(*) AS Delivery_Count
FROM delivery
GROUP BY location
ORDER BY Delivery_Count DESC
LIMIT 10;



-- Festival vs. Non-Festival delivery time comparison

SELECT 
  Festival,
  ROUND(AVG(Time_taken_min), 2) AS Avg_Time
FROM delivery
GROUP BY Festival;

-- Delivery performance by vehicle condition & traffic

SELECT 
  Vehicle_condition,
  Road_traffic_density,
  ROUND(AVG(Time_taken_min), 2) AS Avg_Delivery_Time
FROM delivery
GROUP BY Vehicle_condition, Road_traffic_density;

-- Top delivery person by delivery time & rating

SELECT 
  Delivery_person_ID,
  ROUND(AVG(Time_taken_min), 2) AS Avg_Time,
  ROUND(AVG(Delivery_person_Ratings), 2) AS Avg_Rating,
  COUNT(*) AS Deliveries
FROM delivery
GROUP BY Delivery_person_ID
HAVING COUNT(*) > 10
ORDER BY Avg_Time ASC, Avg_Rating DESC
LIMIT 5;

-- How delivery times vary by city

SELECT 
  City,
  ROUND(AVG(Time_taken_min), 2) AS Avg_Delivery_Time
FROM delivery
GROUP BY City
ORDER BY Avg_Delivery_Time DESC;

-- Peak delivery hours

SELECT 
  HOUR(Time_Orderd) AS Order_Hour,
  COUNT(*) AS Total_Orders,
  ROUND(AVG(Time_taken_min), 2) AS Avg_Delivery_Time
FROM delivery
WHERE Time_Orderd IS NOT NULL
GROUP BY Order_Hour
ORDER BY Total_Orders DESC;

-- Effect of multiple deliveries on delivery time

SELECT 
  multiple_deliveries,
  COUNT(*) AS Total_Orders,
  ROUND(AVG(Time_taken_min), 2) AS Avg_Time
FROM delivery
GROUP BY multiple_deliveries;

--  Average rating by age group

SELECT 
  CASE 
    WHEN Delivery_person_Age < 25 THEN 'Under 25'
    WHEN Delivery_person_Age BETWEEN 25 AND 35 THEN '25-35'
    WHEN Delivery_person_Age BETWEEN 36 AND 45 THEN '36-45'
    ELSE '45+' END AS Age_Group,
  ROUND(AVG(Delivery_person_Ratings), 2) AS Avg_Rating
FROM delivery
GROUP BY Age_Group;

-- Vehicle condition vs. delivery performance

SELECT 
  Vehicle_condition,
  ROUND(AVG(Time_taken_min), 2) AS Avg_Time,
  ROUND(AVG(Delivery_person_Ratings), 2) AS Avg_Rating
FROM delivery
GROUP BY Vehicle_condition;

-- Most common types of orders

SELECT 
  Type_of_order,
  COUNT(*) AS Total_Orders
FROM delivery
GROUP BY Type_of_order
ORDER BY Total_Orders DESC;

-- Average delivery time by type of vehicle

SELECT 
  Type_of_vehicle,
  ROUND(AVG(Time_taken_min), 2) AS Avg_Delivery_Time
FROM delivery
GROUP BY Type_of_vehicle
ORDER BY Avg_Delivery_Time;



-- Monthly Delivery Trends 
    SELECT 
    DATE_FORMAT(Order_Date, '%Y-%m-01') AS Month,
    AVG(Time_taken_min) AS Avg_Delivery_Time
FROM 
    delivery
GROUP BY 
    Month
ORDER BY 
    Month;
    
    -- Predict Late Deliveries in Real-Time 

WITH normalized_data AS (
  SELECT 
    *,
    NTILE(3) OVER (ORDER BY Time_taken_min) AS time_bucket,
    CASE 
      WHEN Road_traffic_density = 'Jam' THEN "Jam"
      WHEN Road_traffic_density = 'High' THEN "High"
      ELSE "Normal"
    END AS traffic_score,
    CASE 
      WHEN Weather_conditions IN ('Stormy', 'Fog') THEN "Stromy,Fog"
      WHEN Weather_conditions = 'Windy' THEN "Windy"
      ELSE "Normal"
    END AS weather_score
  FROM delivery
)
SELECT 
    time_bucket,
    traffic_score,
    weather_score,
    COUNT(*) AS delivery_count
FROM normalized_data
GROUP BY time_bucket, traffic_score, weather_score
ORDER BY time_bucket DESC;

/*
 ---------------- Daily Delivery Count ------------
*/

WITH RECURSIVE DateSeries AS (
    SELECT 
        '2022-02-01' AS Order_Date
    UNION ALL
    SELECT 
        DATE_ADD(Order_Date, INTERVAL 1 DAY)
    FROM 
        DateSeries
    WHERE 
        Order_Date < '2022-04-30'
)
SELECT 
    ds.Order_Date,
    COUNT(d.ID) AS Delivery_Count
FROM 
    DateSeries ds
LEFT JOIN 
    delivery d ON ds.Order_Date = d.Order_Date
GROUP BY 
    ds.Order_Date
ORDER BY 
    ds.Order_Date;
    
    /* 
----------- Monthly Delivery Trends ----------
*/
    
    SELECT 
    DATE_FORMAT(Order_Date, '%Y-%m-01') AS Month,
    AVG(Time_taken_min) AS Avg_Delivery_Time
FROM 
    delivery
GROUP BY 
    Month
ORDER BY 
    Month;




