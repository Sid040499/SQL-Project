use classicmodels;
/* Qusestion 1 */
SELECT employeenumber, firstname, lastname
FROM employees
WHERE jobtitle = 'Sales Rep' AND reportsTo = 1102;

/* Question 2 */
select distinct productline
from products
where productline like '%cars';

/* Question 3 */
SELECT 
    customerNumber,
    customerName,
    CASE 
        WHEN country IN ('USA', 'Canada') THEN 'North America'
        WHEN country IN ('UK', 'France', 'Germany') THEN 'Europe'
        ELSE 'Other'
    END AS CustomerSegment
FROM Customers;

/* Question 4 */
SELECT 
    productCode,
    SUM(quantityOrdered) AS totalQuantity
FROM 
    OrderDetails
GROUP BY 
    productCode
ORDER BY 
    totalQuantity DESC
LIMIT 10;

/* Question 5 */
SELECT 
    MONTHNAME(paymentdate) AS month_name,
    COUNT(*) AS payment_count
FROM 
    Payments
GROUP BY 
    MONTHNAME(paymentdate)
HAVING 
    COUNT(*) > 20;
    
/* Question 6 */
CREATE DATABASE Customers_Orders;
USE Customers_Orders;

CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone_number VARCHAR(20)
);

CREATE TABLE Orders 
(
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    CHECK (total_amount > 0)
);

/* Question 7 */
SELECT 
    c.country,COUNT(o.ordernumber) AS order_count
FROM 
    Customers c
JOIN 
    Orders o ON c.customernumber = o.customernumber
GROUP BY 
    c.country
ORDER BY 
    order_count DESC
LIMIT 5;

/* Question 8 */
CREATE TABLE project 
(
    EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
    FullName VARCHAR(50) NOT NULL,
    Gender ENUM('Male', 'Female') NOT NULL,
    ManagerID INT
);

insert into project values(1,'Pranaya','male',3),
                          (2,'Priyanka','female',1),
                          (3,'Preety','female',null),
                          (4,'Anurag','male',1),
                          (5,'Sambit','male',1),
                          (6,'Rajesh','male',3),
                          (7,'Hina','female',3);
                          
select * from project;

/* 2 */
SELECT m.FullName AS ManagerName,e.FullName AS EmployeeName
FROM 
    project e
 JOIN 
    project m ON m.EmployeeID=e.ManagerID;
    
/* Question 9 */
create table facility
(
facility_id int primary key auto_increment,
namess varchar(100),
city varchar(100)not null,
state varchar(100),
country varchar(100)
);

desc facility;

/* Question 10 */
SELECT
    pl.productLine AS productLine,
    SUM(od.quantityOrdered * od.priceEach) AS total_sales,
    COUNT(DISTINCT o.orderNumber) AS number_of_orders
FROM
    Products p
JOIN
    ProductLines pl ON p.productLine = pl.productLine
JOIN
    OrderDetails od ON p.productCode = od.productCode
JOIN
    Orders o ON od.orderNumber = o.orderNumber
GROUP BY
    pl.productLine;
    
/* Question 11 */
call classicmodels.Get_country_payments(2003, 'france');

/* Question 12 */
SELECT
    c.customerName,
    COUNT(o.orderNumber) AS order_count,
    RANK() OVER (ORDER BY COUNT(o.orderNumber) DESC) AS rnk
FROM
    Customers c
LEFT JOIN
    Orders o ON c.customerNumber = o.customerNumber
GROUP BY
    c.customerNumber, c.customerName
ORDER BY
    rnk;
    
/* Question 13 */
with X as (
select
year(ORDERDATE) as Year,
monthname(orderdate) as Month,
count(orderdate) as total_orders
from
orders
group by
year,month
)
select 
year,
month,
total_orders as'Total Orders',
concat(Round(100*((Total_orders-LAG(Total_Orders)over(Order By year))/LAG(Total_orders)over(Order By Year)),0),'%') 
as "% YoY Changes"
from X;

/* Question 14 */
select productline,count(*) as Total from products
where buyPrice>(select avg(buyPrice) from products)
group by productline;

/* Question 15 */
create table Emp_EH 
(
EmpID int primary key,
EmpName varchar(250),
EmailAddress varchar(250)
);

Delimiter //
create procedure exception_Handle()
begin
declare exit handler for 1048
select 'Error Occurred' as message;
select * from Emp_EH;
end//
Delimiter ;
drop procedure exception_Handle;

/* Question 16  */
create table emp_bit 
(
Name varchar(100),
Occupation varchar(250),
Working_date date,
Working_hours int
);

insert into emp_bit values ('Robin', 'Scientist', '2020-10-04', 12);
insert into emp_bit values ('Warner', 'Engineer', '2020-10-04', 10);
insert into emp_bit values ('Peter', 'Actor', '2020-10-04', 13); 
insert into emp_bit values ('Marco', 'Doctor', '2020-10-04', 14);
insert into emp_bit values ('Brayden', 'Teacher', '2020-10-04', 12);
insert into emp_bit values ('Antonio', 'Business', '2020-10-04', 11);

select * from  emp_bit;

Delimiter //
create trigger emp_bit_before_insert
before insert
on emp_bit for each row
begin
if new.working_hours<0 then
set new.working_hours=-new.working_hours;
end if;
end //

Delimiter ;
select * from emp_bit;














