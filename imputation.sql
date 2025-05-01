use retail;

select * from customer;

-- imputing mode in the location attribute of the customer table
savepoint bef_imp;
drop table customer_temp;
create table customer_temp (select * from customer);

update customer
set
Location=(select Location
from customer_temp
group by Location
order by count(*) desc
limit 1
)
where Location='Unknown';

select *
from customer
where location='Unknown';

