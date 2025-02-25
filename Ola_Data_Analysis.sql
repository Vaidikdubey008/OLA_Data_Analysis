-- Create database and use it
CREATE DATABASE IF NOT EXISTS ola;
USE ola;

-- Create table with correct data types
CREATE TABLE IF NOT EXISTS ola_table (
    Dates DATE,
    Times TIME,
    Booking_ID VARCHAR(255),
    Booking_Status VARCHAR(255),
    Customer_ID VARCHAR(255),
    Vehicle_Type VARCHAR(255),
    Pickup_Location VARCHAR(255),
    Drop_Location VARCHAR(255), 
    V_TAT varchar(255),
    C_TAT varchar(255),
    Canceled_Rides_by_Customer VARCHAR(255),
    Canceled_Rides_by_Driver VARCHAR(255),
    Incomplete_Rides VARCHAR(255),
    Incomplete_Rides_Reason VARCHAR(255),
    Booking_Value varchar(255),
    Payment_Method VARCHAR(255),
    Ride_Distance varchar(255),
    Driver_Ratings varchar(255),
    Customer_Rating varchar(255),
    Vehicle_Images VARCHAR(255)
);

-- Verify the table structure
DESC ola_table;

-- Check secure_file_priv directory
SHOW VARIABLES LIKE 'secure_file_priv';

-- Enable local file loading (May require MySQL restart)


-- Load data with NULL handling
LOAD DATA INFILE 'BOOKINGS01.csv'
INTO TABLE ola_table
FIELDS TERMINATED BY ','  
IGNORE 1 LINES;
SELECT * FROM ola_table;

-- 1. Retrieve all successful bookings:
create view Successful_Bookings As
select*from ola_table
where Booking_Status = 'Success';
select*from Successful_Bookings;


-- 2. Find the average ride distance for each vehicle type:
create view average_ride as
select Vehicle_Type , avg(Ride_Distance)
as avg_distance from ola_table
group by Vehicle_Type;
select*from average_ride;


-- 3. Get the total number of cancelled rides by customers:
create view count_of_ride_cancelled_customer as
select count(*) from ola_table
where Booking_Status = 'Canceled by Customer';
select*from count_of_ride_cancelled_customer;


-- 4. List the top 5 customers who booked the highest number of rides:
create view top5_customers as
select Customer_ID , count(Booking_ID) as total_rides
from ola_table
group by Customer_ID
Order by total_rides Desc limit 15;
select*from top5_customers;


-- 5. Get the number of rides cancelled by drivers due to personal and car-related issues:
create view cancelled_by_driver as
select count(*) from ola_table
where Canceled_Rides_by_Driver = 'personal and car related issue';
select*from cancelled_by_driver;


-- 6. Find the maximum and minimum driver ratings for Prime Sedan bookings:
create view max_and_min_rating as
select max(Driver_Ratings) as Max_rating,
min(Driver_Ratings) as min_rating
from ola_table where Vehicle_Type = 'Prime Sedan';
select*from max_and_min_rating;


-- 7. Retrieve all rides where payment was made using UPI:
create view UPI_PAYMENT as
select*from ola_table
where payment_method = 'UPI';
select*from UPI_PAYMENT;

-- 8. Find the average customer rating per vehicle type:
create view average_rating as
select vehicle_type,avg(customer_rating) as avg_customer_rating
from ola_table
group by vehicle_type;
select*from average_rating;



-- 9. Calculate the total booking value of rides completed successfully:
create view total_booking_value as
select sum(booking_value) as total_booking_value
from ola_table
where booking_status = 'success';
select*from total_booking_value;

-- 10. List all incomplete rides along with the reason:
create view incomplete_rides as
select booking_id,incomplete_rides_reason
from ola_table 
where incomplete_rides = 'yes';
select*from incomplete_rides;



select*from Successful_Bookings;
select*from average_ride;
select*from count_of_ride_cancelled_customer;
select*from top5_customers;
select*from cancelled_by_driver;
select*from max_and_min_rating;
select*from UPI_PAYMENT;
select*from average_rating;
select*from total_booking_value;
select*from incomplete_rides;
