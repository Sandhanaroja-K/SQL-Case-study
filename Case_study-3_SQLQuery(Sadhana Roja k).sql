use case_study

select* from Transactions 
select* from Continent
select* from Customers

--1. Display the count of customers in each region who have done the
--transaction in the year 2020.
select count( c.customer_id)as No_of_cus_txn@2020,
region_name
from customers c join continent co on c.region_id=co.region_id 
left join [Transactions ] t on t.customer_id=c.customer_id
where year(txn_date) = 2020
group by co.region_name;

--2. Display the maximum and minimum transaction amount of each
--transaction type.
select max(txn_amount)as max_amount,
min(txn_amount)as min_amount,txn_type
from [Transactions ]
group by txn_type;


--3. Display the customer id, region name and transaction amount where
--transaction type is deposit and transaction amount > 2000.
select t.customer_id ,region_name ,txn_amount from [Transactions ] t
join Customers c on t.customer_id=c.customer_id
join Continent co on co.region_id=c.region_id
where txn_type='deposit' and txn_amount>2000;



--4. Find duplicate records in the Customer table.
with cte as
(
select customer_id,count(customer_id)as dup
from [Transactions ] 
group by customer_id
)
select customer_id from cte where dup>1;


--5. Display the customer id, region name, transaction type and transaction
--amount for the minimum transaction amount in deposit.
select c.customer_id,txn_type,txn_amount,co.region_name
from [Transactions ] t 
join Customers c on t.customer_id=c.customer_id
join Continent co on co.region_id=c.region_id
where txn_type='deposit' and txn_amount=(select min(txn_amount) from [Transactions ] t)



--6. Create a stored procedure to display details of customers in the
--Transaction table where the transaction date is greater than Jun 2020.
create proc p1 
as
begin 
   select customer_id from [Transactions ] 
   where txn_date>'june 2020'
end

exec p1


--7. Create a stored procedure to insert a record in the Continent table.
create proc insert_into_continent @region_id int,@region_name nvarchar(255)
as 
begin
   insert into Continent values
   (@region_id, @region_name)
end;

--select* from Continent
exec insert_into_continent @region_id =10, @region_name='Antarctica';
select* from Continent


--8. Create a stored procedure to display the details of transactions that
--happened on a specific day.
create proc txn_specific_day @spe_txn_date date
as
begin
    select * from [Transactions ]
	where txn_date=@spe_txn_date
end;

exec txn_specific_day @spe_txn_date='2020-01-10'


--9. Create a user defined function to add 10% of the transaction amount in a
--table.

create function addtenper
(@txn_amount money)
returns money
begin
    declare @add_10 money
	set @add_10=@txn_amount+(@txn_amount*0.10)
	return @add_10
end;
select* ,dbo.addtenper(100) as new from [Transactions ]


--10. Create a user defined function to find the total transaction amount for a
--given transaction type.
create function total_txn_amount (@txn_type varchar(50))
returns money
begin
    declare @total_txnamount money 
	set @total_txnamount=(select sum(txn_amount) from [Transactions ]
	where txn_type=(@txn_type))
	return @total_txnamount
end;

select * ,dbo.total_txn_amount('deposit') as total from [Transactions ];


--11. Create a table value function which comprises the columns customer_id,
--region_id ,txn_date , txn_type , txn_amount which will retrieve data from
--the above table.
create function combine() 
returns table
as
return
(
   select t.customer_id,region_id ,txn_date , txn_type , txn_amount
   from [Transactions ] t join Customers c on t.customer_id=c.customer_id
);
select * from dbo.combine();


--12. Create a TRY...CATCH block to print a region id and region name in a
--single column.
begin try 
     select region_id,region_name ,
	 concat(region_id,' _ ',region_name)as id_name
	 from Continent;
end try
begin catch
    select 
	0 as region_id,
	'error occurred' as region_name,
	'Error: ' + error_message() as combined
end catch;


--13. Create a TRY...CATCH block to insert a value in the Continent table.
begin try 
      insert into Continent values( 8, 'artic')
end try
begin catch
      select -1 as region_id
	  print('error')
end catch;

select* from Continent;

	
--14. Create a trigger to prevent deleting a table in a database.
create table ddllog
(
id int identity (1,1),
eventdate datetime,
eventtype nvarchar(100),
objectname nvarchar(100),
sqlcommand nvarchar(max),
sqlcomonly xml
);

select* from ddllog;



--select* from transactions
---create trigger to prevent deleting on table in a database
CREATE TRIGGER tr_prevent_table_drop12ON DATABASEFOR DROP_TABLEASBEGIN   RAISERROR ('Table drop is not allowed.', 16, 1)	--print error_message()    ROLLBACK;END;

drop table Continent



--15. Create a trigger to audit the data in a table.
create trigger audit_table
on transactions
after insert,update,delete
as
begin
    insert into ddllog(id,eventtype)
	select id,eventtype from  inserted 
end
    
--16. Create a trigger to prevent login of the same user id in multiple pages.
create trigger pre_multi_login
on login_table
after insert
as
begin
    if exists 
	 (select 1 from session_tracking 
	 where USER_ID=(select USER_ID from inserted) and
	 page_url<>(select page_url from inserted))
	 begin
	    raiseerror('User is already logged in a different page',16,1)
		rollback;
	end
end



--17. Display top n customers on the basis of transaction type.

SELECT TOP (10) customer_id, SUM(txn_amount) AS total_transaction_amount
FROM transactions
WHERE txn_type = 'deposit'
GROUP BY customer_id
ORDER BY total_transaction_amount DESC;

--18. Create a pivot table to display the total purchase, withdrawal and
--deposit for all the customers.

select * from 
(select customer_id, txn_type, txn_amount from transactions) as SourceTable
pivot 
(sum(txn_amount) for txn_type in ([purchase], [withdrawal], [deposit])) as PivotTable;







