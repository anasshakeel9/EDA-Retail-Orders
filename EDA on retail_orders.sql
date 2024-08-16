SELECT DISTINCT region from df_orders

-- find top 10 highest generating products
select product_id, SUM(sale_price) as sales
from df_orders
group by 
product_id
order by sales DESC
LIMIT 10;

-- find top 5 highest selling products in each region
-- SELECT  * from df_orders
select product_id, region,SUM(sale_price) as sales
from df_orders
WHERE region = "west"
group by 
product_id,region
order by sales DESC
LIMIT 5;

select product_id, region,SUM(sale_price) as sales
from df_orders
WHERE region = "east"
group by 
product_id,region
order by sales DESC
LIMIT 5;

select product_id, region,SUM(sale_price) as sales
from df_orders
WHERE region = "south"
group by 
product_id,region
order by sales DESC
LIMIT 5;

select product_id, region,SUM(sale_price) as sales
from df_orders
WHERE region = "Central"
group by 
product_id,region
order by sales DESC
LIMIT 5;

-- find month over month growth comparision for 2022 vs 2023 for e.g jan 2022 vs jan 2023

with cte as(
select year(order_date) as order_year,month(order_date) as order_month,
sum(sale_price) as sales
from df_orders
group by year(order_date) , month (order_date)
-- order by year(order_date),month(order_date)
)
select order_month
,sum(case when order_year = 2022 then sales else 0 end) as sales_2022
,sum(case when order_year = 2023 then sales else 0 end) as sales_2023
from cte
group by order_month
order by order_month


-- for each category which month had highest sales?
with cte as (
select category, format (order_date, '%Y%m') as order_year_month,
sum(sale_price) as sales
from df_orders
group by category, format (order_date, '%Y%m')
-- order by category, format (order_date, '%Y%m')
)
select * from (
select *, 
row_number() over (partition by category order by sales desc) as rn 
from cte
) a
where rn = 1 



-- which subcategory had highest growth by profit in 2023 compared to 2022

with cte as(
select sub_category, year(order_date) as order_year,
sum(sale_price) as sales
from df_orders
group by sub_category, year(order_date) 
-- order by year(order_date),month(order_date)
)
, cte2 as (
select sub_category
,sum(case when order_year = 2022 then sales else 0 end) as sales_2022
,sum(case when order_year = 2023 then sales else 0 end) as sales_2023
from cte
group by sub_category
)
select *
, (sales_2023-sales_2022)
from cte2  
order by  (sales_2023-sales_2022) DESC
LIMIT 1