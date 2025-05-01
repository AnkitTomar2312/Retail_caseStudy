create database retail;
use retail;

 -- Removing duplicate transcations
 select TransactionID, count(*) as row_count
 from sales_transaction
 group by TransactionID
 having row_count>1;
 
 -- selecting distinct entries and creating a new table
 
create table sales_transaction_temp as select distinct * from sales_transaction;

-- checking for the duplicate values
select TransactionID, count(*) as row_count
 from sales_transaction_temp
 group by TransactionID
 having row_count>1;
 
-- deleting the sales_transaction table

drop table if exists sales_transaction;

-- changing the name of temp table
alter table sales_transaction_temp
rename sales_transaction ;
 
-- checking the number of rows
select count(*) from sales_transaction;

-- finding the difference between the sales_transaction Price and product_inventory Price

select st.TransactionID, st.ProductID,pi.ProductName, st.Price as tran_price,pi.Price as product_inventory_price
from sales_transaction as st
inner join 
product_inventory pi
on st.ProductID=pi.ProductID
where st.Price<>pi.Price;

savepoint error_find;

-- updating the tran_price discrepancies
update sales_transaction as st
set st.Price=(select pi.Price from product_inventory pi where pi.ProductID=st.ProductID)
where st.ProductID in 
(select pi.ProductID from product_inventory pi where st.Price <> pi.Price);

-- Identifying the null vlaues
select count(*)
from customer
where Location='';

select *
from customer;

-- replacing the empty string in location to 'Unknown'

update customer
set
Location='Unknown'
where Location= '';

-- updating the datatype of the Joindate column
alter table customer
modify JoinDate date;

desc customer;

-- checking the product_inventory

select * from product_inventory;

-- checking the missing values