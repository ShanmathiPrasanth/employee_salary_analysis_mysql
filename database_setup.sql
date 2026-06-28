create database employee_salary_analysis;
USE employee_salary_analysis;

CREATE TABLE department
(
  department_id INT PRIMARY KEY,
  department_name varchar(50)
);

insert into department values (101,'IT');
insert into department values (102,'Finance');
insert into department values (103,'HR');
insert into department values (104,'Marketing');
insert into department values (105,'Sales');

CREATE TABLE jobs
(
  job_id INT PRIMARY KEY,
  job_title varchar(50)
);

insert into jobs values (201,'Data Analytics');
insert into jobs values (202,'Data scientist');
insert into jobs values (203,'AI Engineer');



CREATE TABLE employees
(
 employee_id INT PRIMARY KEY,
 employee_name varchar(50),
 gender varchar(50),
 department_id INT ,
 job_id INT,
 salary INT,
 hire_date DATE,
 experience_years INT,
 FOREIGN KEY (department_id)
 references department(department_id),
 FOREIGN KEY (job_id)
 references jobs(job_id)
);
INSERT INTO employees values ( 01, 'Aruna','Female',101,201,25000,'2021-05-01',5);
INSERT INTO employees values ( 02, 'Raj','Male',102,202,35000,'2020-06-03',6);
INSERT INTO employees values ( 03, 'John','Male',101,203,45000,'2019-07-05',7);
INSERT INTO employees values ( 04, 'Nandhini','Female',101,203,45000,'2018-07-05',8);
INSERT INTO employees values ( 05, 'Divya','Female',104,202,45000,'2017-07-05',9);
INSERT INTO employees values ( 06, 'Kumar','Male',105,203,70000,'2021-09-01',5);
INSERT INTO employees values ( 07, 'Deva','Male',105,203,45000,'2019-07-05',7);
INSERT INTO employees values ( 08, 'Anu','Female',102,201,45000,'2018-07-06',8);
INSERT INTO employees values ( 09, 'Karthi','Male',103,202,45000,'2021-07-01',5);
INSERT INTO employees values ( 10, 'Kalki','Female',101,203,70000,'2018-07-10',9);



CREATE TABLE performance(
	employee_id INT PRIMARY KEY,
  performance_rating INT,
  bonus INT,
  foreign key (employee_Id)
  references employees(employee_Id)
);

INSERT INTO performance values (01,1,1000); 
INSERT INTO performance values (02,2,2000); 
INSERT INTO performance values (03,5,5000); 
INSERT INTO performance values (04,4,4000); 
INSERT INTO performance values (05,1,1000); 
INSERT INTO performance values (06,2,2000); 
INSERT INTO performance values (07,5,5000); 
INSERT INTO performance values (08,4,4000); 
INSERT INTO performance values (09,3,3000); 
INSERT INTO performance values (10,3,3000); 

