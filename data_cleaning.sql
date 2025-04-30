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
 