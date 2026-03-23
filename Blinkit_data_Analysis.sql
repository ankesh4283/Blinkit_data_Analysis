                                         -- Blinkit Data Analysis --   
                                                   
CREATE TABLE blinkit_data (
    item_fat_content VARCHAR(50),
    item_identifier VARCHAR(50),
    item_type VARCHAR(50),
    outlet_establishment_year INT,
    outlet_identifier VARCHAR(50),
    outlet_location_type VARCHAR(50),
    outlet_size VARCHAR(50),
    outlet_type VARCHAR(50),
    item_visibility FLOAT,
    item_weight FLOAT,
    total_sales FLOAT,
    rating FLOAT
);


-- Data Cleaning

select * from blinkit_data;

select distinct item_fat_content from blinkit_data

update blinkit_data
set item_fat_content = 'Low Fat'
where item_fat_content in ('low fat','LF');

update blinkit_data
set item_fat_content = 'Regular'
where item_fat_content = 'reg';

-- Data Analysis

--KPI's

--Q1.The overall revenue generated from all items sold ?
select round(sum(total_sales)::numeric/1000000,2)as revenue_in_millions from blinkit_data; --::numeric -it is used to for Type Casting

--Q2.The average revenue per sale.
select round(avg(total_sales)::numeric,2) as  avg_revenue from blinkit_data;

--Q3.The total count of different items sold.
select count(*)as no_of_item_sold from blinkit_data ;

--Q4.The average customer rating for items sold
select round(avg(rating)::numeric,2)as avg_rating from blinkit_data

-- Granular Requirements

--Q5.Analyze the impact of fat content on total sales.
--KPIs (Average Sales, Number of Items, Average Rating) 
select 
	item_fat_content ,
	round(sum(total_sales)::numeric,2)as total_sales ,
	round(avg(total_sales)::numeric,2) as  avg_sales ,
	count(*)as no_of_item_sold ,
	round(avg(rating)::numeric,2)as avg_rating 
from blinkit_data 
group by item_fat_content
order by total_sales desc;

--Q6.Identify the performance of different item types in terms of total sales.
--KPIs (Average Sales, Number of Items, Average Rating) 
select 
	item_type,
	round(sum(total_sales)::numeric,2)as total_sales ,
	round(avg(total_sales)::numeric,2) as  avg_sales ,
	count(*)as no_of_item_sold ,
	round(avg(rating)::numeric,2)as avg_rating 
from blinkit_data 
group by item_type
order by total_sales desc;

--Q7.Compare total sales across different outlets segmented by fat content.
--other KPIs (Sales, Number of Items, Average Rating)
select outlet_location_type ,
	 round(sum(total_sales) filter(where  item_fat_content = 'Low Fat')::numeric,2)as low_fat_sales ,
	 round(sum(total_sales) filter(where  item_fat_content = 'Regular')::numeric,2)as regular_sales ,
	 count(*)               filter(where  item_fat_content = 'Low Fat')as low_fat_item_sold ,
	 count(*)               filter(where  item_fat_content = 'Regular')as regular_item_sold ,
	 round(avg(rating) filter(where  item_fat_content = 'Low Fat')::numeric,2)as avg_low_fat_rating,
	 round(avg(rating) filter(where  item_fat_content = 'Regular')::numeric,2)as avg_regular_rating 
from blinkit_data
group by outlet_location_type  
order by outlet_location_type;

--Q8.Evaluate how the outlet establishment influences total sales.
select  outlet_establishment_year,
	round(sum(total_sales)::numeric,2)as total_sales
from blinkit_data
group by outlet_establishment_year
order by outlet_establishment_year ;

--Q9.Analyze the correlation between outlet size and total sales.
select  outlet_size,
	round(sum(total_sales)::numeric,2)as total_sales,
	round(sum(total_sales)::numeric	
		/(sum(sum(total_sales)) over())::numeric*100,2) as sales_percentage
from blinkit_data
group by outlet_size
order by total_sales desc;

--Q10.Assess the geographic distribution of sales across different locations.
select outlet_location_type ,
	round(sum(total_sales)::numeric,2)as total_sales ,
	round(avg(total_sales)::numeric,2) as  avg_sales ,
	count(*)as no_of_item_sold ,
	round(avg(rating)::numeric,2)as avg_rating 
from blinkit_data
group by outlet_location_type
order by total_sales desc ;

--Q11.: Provide a comprehensive view of all key metrics (Total Sales, Average Sales, Number of 	Items, Average Rating) 
--broken down by different outlet types.
select outlet_type ,
	round(sum(total_sales)::numeric,2)as total_sales ,
	round(avg(total_sales)::numeric,2) as  avg_sales ,
	count(*)as no_of_item_sold ,
	round(avg(rating)::numeric,2)as avg_rating 
from blinkit_data
group by outlet_type
order by total_sales desc;

                                          -- Project End --

