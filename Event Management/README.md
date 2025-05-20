# 📅 Event Management SQL EDA Project

## 📌 Project Overview

This project performs **Exploratory Data Analysis (EDA)** on an event management system using **MySQL**. The analysis focuses on event durations, manager assignments, and event scheduling patterns. The database includes information about events, their scheduled dates, and the managers overseeing them.

The goal is to extract meaningful insights such as average event durations, manager workloads, scheduling conflicts, and unassigned events using **advanced SQL queries** including CTEs, joins, date functions, and aggregation.



## 🛠 Tech Stack

- **Database**: MySQL 8+
- **Tools Used**: MySQL Workbench
- **Concepts**: 
  - CTEs
  - Window Functions
  - Date Functions
  - Aggregations
  - Conditional Logic

---

## 🗃️ Database Schema

- **`events`**: Stores event information (name, start date, end date)
- **`managers`**: Stores manager details
- **`event_manager`**: Bridge table for many-to-many relationship between events and managers

---

## EER Diagram

![image](https://github.com/user-attachments/assets/966b6a7e-8d08-4458-84f3-af33e4ad8289)

---

## 🧪 Sample Data
Includes 20 events across 2024 and 5 managers with a realistic mix of short and long events, single and multiple manager assignments.

---

## 🔍 Business Queries

### 1.  Events with Duration Significantly Above Average
- Lists events that exceed the **average event duration**.
- Shows duration and how many days above average.

![image](https://github.com/user-attachments/assets/6e79171a-1853-43e5-9738-53c7eaa17c17)


### 2.  Managers Overseeing Events on the Same Day
- For each event day, shows:
  - Number of **distinct managers**
  - **List of events** held on that date

![image](https://github.com/user-attachments/assets/2028d4c6-6b27-41da-ad27-4259a78c94f2)


### 3.  Managers NOT Managing Events Between May–July 2024
- Lists managers with **no events between 2024-05-01 and 2024-07-31**
- Includes **event count managed outside** this date range

![image](https://github.com/user-attachments/assets/1d73efb2-22f3-4a21-aef2-20b3a7c630fd)


### 4.  Event Duration Categories
- Categorizes events as:
  - **Short** (<3 days)
  - **Medium** (3–5 days)
  - **Long** (>5 days)

![image](https://github.com/user-attachments/assets/ddba7421-4543-411d-8f36-eecf9eb7426c)


### 5.  Total Event Days per Manager
- Calculates how many **total event days** each manager is responsible for.

![image](https://github.com/user-attachments/assets/56a05c6f-c7e7-4d41-9a51-3bf753f57d19)

### 6.  Managers Managing Multiple Events in the Same Month
- Identifies managers overseeing **2+ events in the same month**

### 7.  Events Not Assigned to Any Manager
- Lists events that have **no manager assigned**



---

## 📁 Project Structure

#### 🧠 Sample Query Snippet

```sql
-- Events with Duration Significantly Above Average
 with cte as 
	(with difference as 
		(with avg_duration as 
			(select *, timestampdiff(day, start_date,end_date) as event_duration_days 
            from events)
					select *, round(avg(event_duration_days) over(),2) as avg_duration 
                    from avg_duration )
						select * , event_duration_days - avg_duration as difference 
                        from difference)
   
   select event_name,event_duration_days, difference
   from cte
   where  difference > avg_duration 
   ;

![image](https://github.com/user-attachments/assets/0b521953-9ff6-41b4-a894-ed012042d6e2)

   
 -- Managers Overseeing Events on the Same Day
   
   with cte as
		(select e.*, em.manager_id 
        from events as e join event_manager as em 
        using(event_id))
        
   select start_date, 
		count(distinct manager_id) as distinct_manager,
		group_concat(distinct event_name order by event_name separator ', ') as event_list
   from cte 
   group by 1
   ;

--  Managers NOT Managing Events Between May–July 2024

with outside_events as (
    select e.event_id, em.manager_id
    from events e
    join event_manager em using(event_id)
    where e.end_date < '2024-05-01' or e.start_date > '2024-07-31'
),
inside_event_managers as (
    select distinct em.manager_id
    from events e
    join event_manager em using(event_id)
    where e.start_date <= '2024-07-31' and e.end_date >= '2024-05-01'
)
select 
    m.manager_id,
    m.name,
    count(oe.event_id) as event_managed
from managers m
left join outside_events oe using(manager_id)
where m.manager_id not in (select manager_id from inside_event_managers)
group by m.manager_id, m.name;


-- Event Duration Categories   
     
 with cte as (select *, timestampdiff(day, start_date,end_date) as event_duration_days
   from events)
   select *,
   case when event_duration_days <3 then "Short"
   when event_duration_days between 3 and 5 then "Medium"
   else "Long"
   end as event_catagory
   from cte
   ;  
   
-- Total Event Days per Manager
   
  with cte as ( select e.*, timestampdiff(day, start_date,end_date) as event_duration_days, em.manager_id 
  from events as e join event_manager as em using(event_id))
   select manager_id, sum(event_duration_days) as total_no_of_days
   from cte
   group by 1
   ;
   
   
--  Managers Managing Multiple Events in the Same Month

    with cte as (SELECT 
        em.manager_id, 
        MONTH(e.start_date) AS month,
        COUNT(*) AS event_count
    FROM events e
    JOIN event_manager em USING(event_id)
    GROUP BY em.manager_id, MONTH(e.start_date))
    select c.*, m.name
    from cte as c join managers as m using(manager_id)
    where event_count >= 2
    ;
   
   

-- Events Not Assigned to Any Manager

   select  e.event_name, em.manager_id from events as e left join event_manager as em using(event_id)
   where em.manager_id is  null
   ;
   ```

### 📈 Key Insights
--  Certain events last well above the average duration and can be resource-intensive.

--  Some managers consistently handle multiple events in the same month, indicating scheduling load.

--  Several dates have multiple managers working simultaneously, useful for staffing analysis.

--  A few events are unassigned, which might lead to gaps in execution planning.

--  Most events are categorized as Short or Medium, helping with resource planning.

--- 

## Author
### — Sudeshna Dey
###  — Contact & Contributions

#### 📧 Email: sudeshnadey1000@gmail.com
#### 🔗 LinkedIn: https://www.linkedin.com/in/sudeshna-dey-724a811a0/
 Have feedback or suggestions? I'm always open to improving and collaborating!
 
If you find this project helpful:
⭐ Give it a star
Thanks for visiting — and happy data analyzing!


