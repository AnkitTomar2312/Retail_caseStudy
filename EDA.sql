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