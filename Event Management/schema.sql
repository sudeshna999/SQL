create database event_management;


CREATE TABLE events (
    event_id INT PRIMARY KEY,      
    event_name VARCHAR(255),       
    start_date DATE,               
    end_date DATE                  
);

INSERT INTO events (event_id, event_name, start_date, end_date) VALUES
(1, 'Annual Conference', '2024-01-15', '2024-01-17'),
(2, 'Team Building Retreat', '2024-02-20', '2024-02-22'),
(3, 'Product Launch', '2024-03-05', '2024-03-06'),
(4, 'Marketing Webinar', '2024-04-10', '2024-04-10'),
(5, 'Quarterly Review', '2024-05-01', '2024-05-01'),
(6, 'Customer Workshop', '2024-06-12', '2024-06-12'),
(7, 'Tech Meetup', '2024-07-03', '2024-07-03'),
(8, 'Sales Training', '2024-08-18', '2024-08-19'),
(9, 'HR Orientation', '2024-09-25', '2024-09-25'),
(10, 'End of Year Gala', '2024-12-05', '2024-12-05'),
(11, 'Strategy Meeting', '2024-01-20', '2024-01-20'),
(12, 'New Product Development', '2024-02-10', '2024-02-11'),
(13, 'Board Meeting', '2024-03-18', '2024-03-18'),
(14, 'Industry Conference', '2024-04-22', '2024-04-24'),
(15, 'Financial Audit', '2024-05-14', '2024-05-15'),
(16, 'Customer Feedback Session', '2024-06-28', '2024-06-28'),
(17, 'IT Security Training', '2024-07-10', '2024-07-10'),
(18, 'Investor Presentation', '2024-08-21', '2024-08-21'),
(19, 'Holiday Party', '2024-12-20', '2024-12-20'),
(20, 'Leadership Summit', '2024-11-15', '2024-11-17');


CREATE TABLE event_manager (
    event_id INT,               
    manager_id INT,             
    PRIMARY KEY (event_id, manager_id),
    FOREIGN KEY (event_id) REFERENCES events(event_id)
);


INSERT INTO event_manager (event_id, manager_id) VALUES
(1,5),
(2,4),
(3,1),
(4,1),
(5,3),
(6,1),
(7,1),
(8,2),
(9,3),
(10,5),
(11,1),
(12,4),
(13,4),
(14,5),
(15,4),
(16,2),
(17,2),
(18,4),
(19,3),
(20,4);

CREATE TABLE managers (
    manager_id INT PRIMARY KEY,  
    name VARCHAR(255)
);           

INSERT INTO managers (manager_id, name) VALUES
(1, 'Alice Johnson'),
(2, 'Bob Smith'),
(3, 'Carol Davis'),
(4, 'David Wilson'),
(5, 'Eve Martinez');
