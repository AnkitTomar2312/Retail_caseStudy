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