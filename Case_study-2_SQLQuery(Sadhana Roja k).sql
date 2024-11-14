use case_study

---CREATE TABLE
create table locations
(Location_ID  int primary key,
city varchar(50))

---INSERT VALUES
insert into  locations values 
(122, 'New York'),
(123, 'Dallas'),
(124, 'Chicago'),
(167, 'Boston');

select* from locations;

---CREATE TABLE
create table departments
(Department_Id int primary key,
D_Name varchar(50),
Location_Id int foreign key references locations(location_id));

---INSERT VALUE
insert into departments values
(10, 'Accounting', 122),
(20, 'Sales', 124),
(30, 'Research', 123),
(40, 'Operations', 167);

select* from departments;

---CREATE TABLE
create table job
(Job_ID int Primary Key,
Designation varchar(50));

---INSERT VALUE
insert into job values
(667, 'Clerk'),
(668, 'Staff'),
(669,'Analyst'),
(670, 'Sales Person'),
(671 ,'Manager'),
(672, 'President')
;

select* from job;

---CREATE TABLE
create table employee
(
Employee_Id int ,
Last_Name varchar(100),
First_Name varchar(100),
Middle_Name varchar(100),
Job_Id int Foreign Key references  job(Job_ID),
Hire_Date date,
Salary money,
Comm int ,
Department_Id int foreign key references department(department_id)
);

---INSERT VALUE
insert into employee values
(7369, 'Smith', 'John', 'Q', 667 ,'17-Dec-84', 800 ,Null ,20),
(7499, 'Allen',' Kevin', 'J', 670, '20-Feb-85', 1600, 300, 30),
(755, 'Doyle', 'Jean', 'K', 671, '04-Apr-85', 2850, Null, 30),
(756, 'Dennis', 'Lynn', 'S', 671 ,'15-May-85', 2750 ,Null, 30),
(757, 'Baker', 'Leslie', 'D', 671, '10-Jun-85', 2200, Null, 40),
(7521, 'Wark', 'Cynthia',' D', 670, '22-Feb-85', 1250 ,50, 30);

select* from employee;
select* from locations;
select* from departments;
select* from job;


--Simple Queries:

--1. List all the employee details.
create view emp_full as
select [Employee_Id], [Last_Name], [First_Name], [Middle_Name], 
e.[Job_Id], [Hire_Date], [Salary], [Comm], e.[Department_Id],d.D_Name,l.[city],[designation]
from employee e inner join departments d on e.Department_Id=d.Department_Id 
inner join job j on j.Job_ID=e.Job_Id
inner join locations l on l.Location_ID=d.Location_Id;

select* from emp_full;

--2. List all the department details. 
select employee_id,first_name,department_id,d_name from emp_full;
select* from departments;

--3. List all job details.
select* from job;

--4. List all the locations.
select* from locations;

--5. List out the First Name, Last Name, Salary, Commission for allEmployees.
select First_Name,Last_Name,Salary,Comm
from emp_full;


--6. List out the Employee ID, Last Name, Department ID for all employees and alias
--Employee ID as "ID of the Employee", Last Name as "Name of the Employee", Department ID as "Dep_id". 
select Employee_ID as 'ID of the Employee',
Last_Name as 'Name of the Employee',
Department_ID as 'Dep_id'
from emp_full


--7. List out the annual salary of the employees with their  names only.
select (first_name+' '+last_name)as full_name ,(salary*12)as Annual_salary from employee

--WHERE Condition:
--1. List the details about "Smith". 
select*from emp_full where last_name='smith'

--2. List out the employees who are working in department 20. 
select* from emp_full where Department_Id=20

--3. List out the employees who are earning salaries between 3000 and4500.
select * from employee where Salary between 3000 and 4500


--4. List out the employees who are working in department 10 or 20.
select* from employee where Department_Id=10 or Department_Id=20

--5. Find out the employees who are not working in department 10 or 30. 
select* from emp_full where   Department_Id <>10 and Department_Id<>30

--6. List out the employees whose name starts with 'S'
select *from employee
where Last_Name like 'S%%'

--7. List out the employees whose name starts with 'S' and ends with 'H'.
select* from employee 
where Last_Name like 'S%%H'


--8. List out the employees whose name length is 4 and start with 'S'.
select * from employee
where last_name like 'S___'


--9. List out employees who are working in department 10 and draw salaries more
--than 3500.
select *from employee
where Department_Id=10 and Salary>3500

--10. List out the employees who are not receiving commission

select first_name from employee
where comm is null

--ORDER BY Clause:
--1. List out the Employee ID and Last Name in ascending order based on the
--Employee ID.
select Employee_Id,Last_Name
from employee
order by Employee_Id


--2. List out the Employee ID and Name in descending order based onsalary.
select Employee_Id,(last_name+' '+First_Name)as fullname 
from employee
order by salary


--3. List out the employee details according to their Last Name in ascending-order. 
select *from employee
order by Last_Name asc

--4. List out the employee details according to their Last Name in ascending
--order and then Department ID in descending order.
select* from employee
order by last_name asc , department_id desc;

--GROUP BY and HAVING Clause:
--1. How many employees are in different departments in theorganization?
select count(employee_id)as no_of_employee ,d_name from employee e inner join departments d 
on e.Department_Id=d.Department_Id
group by D_Name


--2. List out the department wise maximum salary, minimum salary and
--average salary of the employees.
select max(salary)as max_salary,
min(salary)as min_salary,
avg(salary)as avg_salary,d_name 
from employee e inner join departments d 
on e.Department_Id=d.Department_Id
group by D_Name;


--3. List out the job wise maximum salary, minimum salary and average
--salary of the employees. 
select max(salary)as max_salary,
min(salary)as min_salary,
avg(salary)as avg_salary,designation 
from employee e inner join job j on e.Job_Id=j.Job_ID
group by Designation;


--4. List out the number of employees who joined each month in ascendingorder.
select count(employee_id)as no_of_employee,
month(hire_date) as month from employee
group by Hire_Date;


--5. List out the number of employees for each month and year in
--ascending order based on the year and month.
select count(employee_id)as no_of_employee,YEAR(hire_date)as years,MONTH(hire_date)as months
from employee 
group by year(hire_date),month(hire_date)
order by year(hire_date),month(hire_date) 


--6. List out the Department ID having at least four employees.
select count(department_id)as dep from employee
group by Employee_Id
having count(employee_id)>4


--7. How many employees joined in the month of January?
select count(employee_id)as no_of_emp ,month(hire_date)as month
from employee 
group by month(hire_date)
having month(Hire_Date)=1;

--8. How many employees joined in the month of January orSeptember?
select count(employee_id)as no_of_emp ,month(hire_date)as month 
from employee
group by month(hire_date)
having month(hire_date)=1 or month(hire_date)=9


--9. How many employees joined in 1985?
select count(employee_id)as no_of_emp from employee
where year(hire_date)=1985


--10. How many employees joined each month in 1985?
select count(employee_id) as no_of_emp,year(hire_date)as year,month(hire_date)as month from employee
group by year(hire_date),month(hire_date)
having year(hire_date) = 1985


--11. How many employees joined in March 1985?
select count(employee_id)as no_of_emp ,datepart(month,hire_date)as month,datepart(year,hire_date)as year
from employee
group by datepart(month,hire_date),datepart(year,hire_date)
having datepart(month,hire_date)=3 and datepart(year,hire_date)=1985


--12. Which is the Department ID having greater than or equal to 3 employees
--joining in April 1985?

SELECT Department_id, COUNT(*) As No_of_Employees
FROM Employee
GROUP BY Department_id
HAVING count(*)>=3;

--Joins:
--1. List out employees with their department names.
select employee_id,last_name ,d_name from employee e inner join departments d
on e.Department_Id=d.Department_Id;


--2. Display employees with their designations.
select last_name ,designation from employee e join job j
on e.Job_Id=j.Job_ID


--3. Display the employees with their department names and regional groups.
select last_name ,d_name,l.city from employee e 
inner join departments d on e.Department_Id=d.Department_Id
join job j on j.Job_ID=e.Job_Id
join locations l on l.Location_ID=d.Location_Id

----select*from locations
----select*from employee
select*from departments
--4. How many employees are working in different departments? Display with
--department names.
select count(employee_id)no_of_emp,d.D_Name 
from employee e inner join departments d on e.Department_Id=d.Department_Id
group by D_name
having count(d_name)=1

--5. How many employees are working in the sales department?
select count(employee_id)as no_of_emp from employee e inner join departments d
on e.Department_Id=d.Department_Id
where D_Name='sales'


--6. Which is the department having greater than or equal to 5
--employees? Display the department names in ascending
--order. 
select d_name from departments d join employee e on d.Department_Id=e.Department_Id
group by D_Name
having count(d_name)>=5


--7. How many jobs are there in the organization? Display with designations.
select count(employee_id)as no_of_job ,d_name from employee e inner join departments d
on e.Department_Id=d.Department_Id
group by D_Name


--8. How many employees are working in "New York"?
select count(employee_id),city from employee e join departments d
on e.Department_Id=d.Department_Id join locations l on l.Location_ID=d.Location_Id
group by city
having city='new york'
--------select*from locations
--------select*from employee
--------select* from departments

--9. Display the employee details with salary grades. Use conditional statementto
--create a grade column. 
select employee_id,last_name,salary,
case
WHEN salary >= 1000 AND salary < 1500THEN 'Grade A'
WHEN salary >= 1500 AND salary < 2500THEN 'Grade B'
WHEN salary >= 2500 AND salary < 3500 THEN 'Grade C'
WHEN salary >= 3500 THEN 'Grade D' ELSE 'Grade F'
END AS grade
from employee;



--10. List out the number of employees grade wise. Use conditional statementto
--create a grade column. 
select count(employee_id)as no_of_emp,
case 
when salary>=1000 and salary<1500 then 'Grade A'
when salary>=1500 and salary<2500 then 'Grade B'
when salary>=2500 and salary<3500 then 'Grade C'
else 'Grade F' end as grade
from employee 
group by salary;


--11.Display the employee salary grades and the number of employees
--between 2000 to 5000 range of salary.
with cte as
(
select employee_id,salary,
case 
when salary>=1000 and salary<1500 then 'Grade A'
when salary>=1500 and salary<2500 then 'Grade B'
when salary>=2500 and salary<3500 then 'Grade C'
else 'Grade F' end as Grade
from employee
)
select count(employee_id)as no_of_emp,grade,salary from cte
group by Salary,Grade
having Salary between 2000 and 5000;

--12. Display all employees in sales or operation departments
select employee_id,last_name from employee e join departments d
on e.Department_Id=d.Department_Id
where D_Name='sales' or D_Name= 'operation';


--SET Operators:
--1. List out the distinct jobs in sales and accounting departments.


select designation from job 
where Job_ID=(select Job_ID from employee 
where Department_Id =(select Department_Id from departments where D_Name='sales'))
union 
select designation from job 
where Job_ID=(select Job_ID from employee 
where Department_Id=(select Department_Id from departments where D_Name='accounting'));


--2. List out all the jobs in sales and accounting departments. 
select designation from job 
where job_id =(select job_id from employee 
where Department_Id=(select Department_Id from departments where d_name='sales'))
union all
select designation from job
where job_id =(select Job_ID from employee 
where Department_Id=(select Department_Id from departments where D_Name='accounting'));


--3. List out the common jobs in research and accounting
--departments in ascending order.
select designation from job
where job_id in(select job_id from employee
where Department_Id=(select Department_Id from departments where D_Name='research' ))
intersect
select designation from job
where job_id in(select job_id from employee
where Department_Id=(select Department_Id from departments where D_Name ='accounting'))
order by Designation;


--Subqueries:

--1. Display the employees list who got the maximum salary
select employee_id,last_name from employee where Salary=(select max(salary) from employee)

--2. Display the employees who are working in the sales department.
select employee_id ,last_name from employee 
where Department_Id=(select Department_Id from departments where D_Name='sales')

--3. Display the employees who are working as 'Clerk'.
select Employee_Id,Last_Name  from employee where Job_Id=(select Job_Id from job where Designation='clerk')

--4. Display the list of employees who are living in "New York". 
select Employee_Id,Last_Name
from employee 
where Department_Id=(select Department_Id from departments 
where Location_Id=(select Location_Id from locations where city='new york'))

--5. Find out the number of employees working in the sales department. 
select count(employee_id),last_name from employee where Department_Id=(select Department_Id from departments where D_Name='sales')
group by Department_Id,Last_Name

--6. Update the salaries of employees who are working as clerks on the basis of 10%.
update employee set Salary=(salary +(Salary*0.10))
where Job_Id=(select job_Id from job where designation= 'clerk');

select* from employee;
--7. Delete the employees who are working in the accounting department.
delete from employee where department_id=(select department_id from departments where D_Name='accounting')


--8. Display the second highest salary drawing employee details.
with cte1 as 
(
select employee_id,last_name,salary,
row_number()over(order by salary desc)as salaryrank
from employee 
)
select * from cte1 where salaryrank=2;


--9. Display the nth highest salary drawing employee details.
select* from employee where salary=(select max(Salary)from employee)


--10. List out the employees who earn more than every employee in department 30.
select * from employee where Salary=(select max(salary)from employee where Department_Id=30)

--11. List out the employees who earn more than the lowest salary in
--department.
select employee_id,last_name,d_name from employee e inner join departments d on e.Department_Id=d.Department_Id
where salary>(select min(Salary)from employee) order by D_Name;
 

--12. Find out which department has no employees.
select department_id ,d_name from departments 
where department_id not in (select Department_Id from employee)

--13. Find out the employees who earn greater than the average salary for
--their department
select *,d_name from employee e join departments d on e.Department_Id=d.Department_Id
where salary>(select avg(Salary)from employee);




--select* from employee;
--select* from locations;
--select* from departments;
--select* from job;