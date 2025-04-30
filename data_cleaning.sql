create database retail;
use retail;

 -- Removing duplicate transcations
 select TransactionID, count(*) as row_count
 from sales_transaction
 group by TransactionID
 having row_count>1;