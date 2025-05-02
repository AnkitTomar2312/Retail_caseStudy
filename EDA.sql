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

