
-- dataset is very large so we used non GUI method to load the data
-- load data using cmd

LOAD DATA LOCAL INFILE "C:\\Users\\SUDESHNA\\OneDrive\\Sudeshna Dey\\IVY\\New folder\\Zomato Dataset Cleaned.csv" 
INTO TABLE delivery										
FIELDS TERMINATED BY ','											
ENCLOSED BY '"'											
LINES TERMINATED BY '\r\n' IGNORE 1 ROWS; 

 -- only change the file location 
 -- run the same command for loading large file
 
 -- check if dataset load properly
select * from delivery
limit 10;
