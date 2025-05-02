-- Exploratory Data Analysis (EDA)
use retail;
-- Get a summary of total sales and quantities sold per product.
-- Write a SQL query to summarize the total sales and quantities sold per product by the company.

select
p.ProductID,
round(sum(t.QuantityPurchased*t.Price),2) as total_sales,
sum(t.QuantityPurchased) as Toatal_Quantity
from product_inventory p
inner join
sales_transaction t
on p.ProductID=t.ProductID
group by p.ProductID;

-- Customer Purchase Frequency
-- Write a SQL query to count the number of transactions per customer to understand purchase frequency. 

select CustomerID, count(*)
from sales_transaction
group by CustomerID;

-- Product Categories Performance
-- Write a SQL query to evaluate the performance of the product categories based on the total sales which 
-- help us understand the product categories which needs to be promoted in the marketing campaigns.

select 
Category,
concat('$ ',round(sum(s.Price*s.QuantityPurchased),2)) as total_sales
from 
product_inventory p
inner join
sales_transaction s
on p.ProductID=s.ProductID
group by Category
order by total_sales desc;

-- High Sales Products
-- Write a SQL query to find the top 10 products with the highest total sales revenue from the sales transactions. 
-- This will help the company to identify the High sales products which needs to be focused to increase the revenue 
-- of the company.

select 
ProductName,
concat('$ ',round(sum(s.Price*s.QuantityPurchased),2)) as total_sales
from 
product_inventory p
inner join
sales_transaction s
on p.ProductID=s.ProductID
group by ProductName
order by total_sales desc
limit 10;

-- Low Sales Products
-- Write a SQL query to find the ten products with the least amount of units sold from the sales transactions, 
-- provided that atleast one unit was sold for those products.

select 
distinct p.ProductID,
s.QuantityPurchased
from 
product_inventory p
inner join
sales_transaction s
on p.ProductID=s.ProductID
where QuantityPurchased>=1
order by QuantityPurchased
limit 10;

-- Get the top 5 products from each category in terms of revenue generated
-- Write an SQL query to get top 5 performing products from each category by revenue

with temp as (
select
s.ProductID,
p.Category,
s.QuantityPurchased,
s.Price,
round((s.QuantityPurchased*s.Price),2) as sales
from 
product_inventory p
inner join
sales_transaction s
on p.ProductID=s.ProductID),
ranked as (
select 
*,
row_number() over(partition by Category order by sales desc) as product_rank
from temp)
select * from ranked
where product_rank<=5;

-- Get top 20 percent most ordered products from the entire data.
with temp as (select 
*,
ntile(10) over(order by QuantityPurchased desc) as tentile
from sales_transaction)
select * from temp 
where tentile<=2;

-- Sales Trends
-- Write a SQL query to identify the sales trend to understand the revenue pattern of the company.

alter table sales_transaction
modify TransactionDate date;

with rev as (
select 
year(TransactionDate) as year,
round(sum(QuantityPurchased*Price),2) as annual_revenue,
lag(round(sum(QuantityPurchased*Price),2)) over() as prev_year_revenue
from 
sales_transaction
group by year(TransactionDate))
select *,
concat(round((annual_revenue-prev_year_revenue)*100/prev_year_revenue,2),' %') as percentage
from rev;

-- Growth rate of sales M-o_M
-- Write a SQL query to understand the month on month growth rate of sales of the company which will help 
-- understand the growth trend of the company.

select 
*
from sales_transaction;
with temp as (
select 
year(TransactionDate) as year,
month(TransactionDate) as month,
round(sum(QuantityPurchased*Price),2) as monthly_revenue,
lag(round(sum(QuantityPurchased*Price),2)) over(partition by year(TransactionDate)) as prev_monthly_revenue
from sales_transaction
group by year,month
order by year)
select *,
round((monthly_revenue-prev_monthly_revenue)*100/prev_monthly_revenue,2) as percentage
from temp;

-- do same for the quantity purchased


select 
*
from sales_transaction;
with temp as (
select 
year(TransactionDate) as year,
month(TransactionDate) as month,
sum(QuantityPurchased) as monthly_orders,
lag(sum(QuantityPurchased)) over(partition by year(TransactionDate)) as prev_monthly_orders
from sales_transaction
group by year,month
order by year)
select *,
round((monthly_orders-prev_monthly_orders)*100/prev_monthly_orders,2) as percentage
from temp;

-- Customers - High Purchase Frequency and Revenue
-- Write a SQL query that describes the number of transaction along with the total amount spent by each 
-- customer which are on the higher side and will help us understand the customers who are the high frequency 
-- purchase customers in the company.


select CustomerID,count(*) as number_of_transaction,round(sum(QuantityPurchased*Price),2) 
as total_amount_spent from 
sales_transaction
group by CustomerID
having number_of_transaction>10 and total_amount_spent>1000
order by total_amount_spent desc;


-- Occasional Customers - Low Purchase Frequency
-- Write a SQL query that describes the number of transaction along with the total amount spent by each customer, 
-- which will help us understand the customers who are occasional customers in the company.

select CustomerID,count(*) as number_of_transaction,round(sum(QuantityPurchased*Price),2) 
as total_amount_spent from 
sales_transaction
group by CustomerID
having number_of_transaction<10 and total_amount_spent<1000
order by total_amount_spent;


-- Repeat Purchase Patterns
-- Write a SQL query that describes the total number of purchases made by each customer against each productID 
-- to understand the repeat customers in the company.


-- Loyalty Indicators
-- Write a SQL query that describes the duration between the first and the last purchase of the customer 
-- in that particular company to understand the loyalty of the customer.


-- Customer Segmentation based on quantity purchased
-- Write a SQL query that segments customers based on the total quantity of products they have purchased. 
-- Also, count the number of customers in each segment. 
