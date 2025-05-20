/* 1. Write a query to list events that have durations significantly longer than the average duration of all events. 
   The query should include the event name, duration, and the difference in days from the average duration.*/
   -- done
   
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
   
   /* 2. Write a query to find the number of distinct managers overseeing events on the same day. 
   The result should include the date, number of distinct managers, and a list of events managed on that day.  */
   
   
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

   
   
/* 3. write a query to find all managers who have not managed any events between 2024-05-01 and 2024-07-31. 
   list the manager's name and the total number of events they have managed outside this date range. */

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

   
   
   
/* 4. Write a query to categorize each event into one of three categories: "Short" if the event duration is less than 3 days, 
   "Medium" if the event duration is between 3 and 5 days, and "Long" if the event duration is more than 5 days. */ 
   
   
 with cte as (select *, timestampdiff(day, start_date,end_date) as event_duration_days
   from events)
   select *,
   case when event_duration_days <3 then "Short"
   when event_duration_days between 3 and 5 then "Medium"
   else "Long"
   end as event_catagory
   from cte
   ;  
   
   /* 5. For each manager, list the total number of days of events they are managing (consider event duration). */
   
  with cte as ( select e.*, timestampdiff(day, start_date,end_date) as event_duration_days, em.manager_id 
  from events as e join event_manager as em using(event_id))
   select name, sum(event_duration_days) as total_no_of_days
   from cte join managers as m using(manager_id)
   group by 1
   ;
   
   
   /* 6. List the managers who are managing two or more events in the same month. */
   

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
   
   
   
   /* 7. List events that are not assigned to any manager. */
 -- done
   select  e.event_name, em.manager_id from events as e left join event_manager as em using(event_id)
   where em.manager_id is  null
   ;
   
   