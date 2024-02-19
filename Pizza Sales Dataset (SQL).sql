create database pizza_db;

use pizza_db;

create table pizza_sales
(pizza_id int,
order_id int,
pizza_name_id varchar(50),
quantity int,
order_date varchar(50),
order_time time,
unit_price double,
total_price double,
pizza_size varchar(50),
pizza_category varchar(50),
pizza_ingredients varchar(200),
pizza_name varchar(100));

select * from pizza_sales;

alter table pizza_sales
add column new_order_date date;
 
select order_date, str_to_date(order_date, "%d-%m-%y") as new_order_date
from pizza_sales;

set sql_safe_updates = 0;

update pizza_sales
set new_order_date = str_to_date(order_date, "%d-%m-%Y");

-- 1. Total Revenue:
select sum(total_price) as Total_Revenue
from pizza_sales;

-- 2. Average Order Value:
select (sum(total_price) / count(distinct order_id)) as Avg_Order_Value
from pizza_sales;

-- 3. Total Pizzas Sold
select sum(quantity) as Total_Pizza_Sold 
from pizza_sales;

-- 4. Total Orders
select count(distinct order_id) as Total_Orders
from pizza_sales;

-- 5. Average Pizzas Per Order
select cast(sum(quantity) / count(distinct order_id) as decimal(10,2)) as Avg_Pizzas_Per_Order
from pizza_sales;

-- 6. Daily Trend for Orders
select dayname(new_order_date) as Order_Day, count(distinct order_id) Total_Orders
from pizza_sales
group by dayname(new_order_date)
order by Total_Orders desc;

-- 7. Monthly Trend for Orders
select monthname(new_order_date) as Month_Name, count(distinct order_id) as Total_Orders
from pizza_sales
group by monthname(new_order_date)
order by Total_Orders desc;

-- 8. Percentage of Sales by Pizza Category
select pizza_category, round(sum(total_price), 2) as Total_Sales, 
round(sum(total_price) * 100 / (select sum(total_price) from pizza_sales where month(new_order_date) = 1), 2) as PCT
from pizza_sales
where month(new_order_date) = 1
group by pizza_category
order by PCT desc;
/* Here month(new_order_date) = 1 indicates that the output is for the month of January */

-- 9. Percentage of Sales by Pizza Size
select pizza_size, round(sum(total_price), 2) as Total_Sales, 
round(sum(total_price) * 100 / (select sum(total_price) from pizza_sales where quarter(new_order_date) = 1), 2) as PCT
from pizza_sales
where quarter(new_order_date) = 1
group by pizza_size
order by PCT desc;
/* Here quarter(new_order_date) = 1 indicates that the output is for the first quarter. */

-- 10. Total Pizzas Sold by Pizza Category
select pizza_category, sum(quantity) as Total_Quantity_Sold
from pizza_sales
group by pizza_category
order by Total_Quantity_Sold desc;

-- 11. Top 5 Pizzas by Revenue
select pizza_name, sum(total_price) as Total_Revenue
from pizza_sales
group by pizza_name
order by Total_Revenue desc
limit 5;

-- 12. Bottom 5 Pizzas by Revenue
select pizza_name, sum(total_price) as Total_Revenue
from pizza_sales
group by pizza_name
order by Total_Revenue asc
limit 5;

-- 13. Top 5 Pizzas by Quantity
select pizza_name, sum(quantity) as Total_Pizza_Sold
from pizza_sales
group by pizza_name
order by Total_Pizza_Sold desc
limit 5;

-- 14. Bottom 5 Pizzas by Quantity
select pizza_name, sum(quantity) as Total_Pizza_Sold
from pizza_sales
group by pizza_name
order by Total_Pizza_Sold asc
limit 5;

-- 15. Top 5 Pizzas by Total Orders
select pizza_name, count(distinct order_id) as Total_Orders
from pizza_sales
group by pizza_name
order by Total_Orders desc
limit 5;

-- 16. Bottom 5 Pizzas by Total Orders
select pizza_name, count(distinct order_id) as Total_Orders
from pizza_sales
group by pizza_name
order by Total_Orders asc
limit 5;



