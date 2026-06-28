/*=========================================================
EMPLOYEE SALARY ANALYSIS USING MYSQL

Author: Shanmathi Sampath

Description:
This project demonstrates SQL concepts by solving real-world
HR and employee salary analysis problems using MySQL.

Database:
employee_salary_analysis
=========================================================*/

USE employee_salary_analysis;

/*============================================
 SECTION 1 - Salary Analysis

Business Objective:
Analyze employee salaries to identify compensation trends,
department-wise expenditure, and employees earning above
average salaries.

Concepts Used:
✔ Aggregate Functions
✔ GROUP BY
✔ INNER JOIN
✔ CTE
✔ CROSS JOIN
✔ Subqueries
==============================================*/
/*Query 1: Total Employee Count

Business Problem:
Determine the total number of employees currently working in the organization.*/

SELECT COUNT(*)
FROM employees;

/*Query 2: Department-wise Employee Count

Business Problem:

Determine the number of employees working in each department for workforce planning and resource allocation.*/

select d.department_id,d.department_name, COUNT(e.employee_id) AS emp_count
from employees e
inner join department d
ON e.department_id = d.department_id
group by d.department_id,
         d.department_name;

/*---------------------------------------------------------
Query 3: Department-wise Average Salary

Business Problem:
Calculate the average salary of employees in each department
to compare compensation levels across different departments.
---------------------------------------------------------*/
select d.department_id,d.department_name, ROUND(avg(e.salary),2) AS average_salary
from employees e
inner join department d
ON e.department_id = d.department_id
group by d.department_id,
		d.department_name;

/*Query 4: Department-wise Salary Expenditure

Business Problem:
Calculate the total salary expenditure for each department
to support departmental budget planning.*/

select d.department_id,d.department_name, SUM(e.salary) AS salary_expenditure
from employees e
inner join department d
ON e.department_id = d.department_id
group by d.department_id,
         d.department_name;
         
/*Query 5: Employees Earning Above Company Average Salary
(Using CROSS JOIN)

Business Problem:
Identify employees whose salary is greater than the overall
company average salary. 	*/

with cte_1 as
(
select avg(employees.salary) AS company_avg_salary
from employees
)
select employee_name,salary ,company_avg_salary
from employees
cross join cte_1
where employees.salary > cte_1.company_avg_salary;


/*Query 6: Employees Earning Above Company Average Salary
(Using Subquery)

Business Problem:
Retrieve employees whose salary exceeds the company's
average salary using a subquery.*/

select employee_name,salary 
from employees
where salary >
 (
   select avg(employees.salary) as avg_salary
   from employees
 );

/*Query 7: Employees Earning Above Department Average Salary

Business Problem:
Identify employees earning more than the average salary
within their respective departments*/

WITH CTE_AVG_SAL as
(
  SELECT department.department_id,department.department_name,ROUND(avg(employees.salary),2) AS Avg_Salary
  from employees
  inner join department
  ON employees.department_id=department.department_id
  group by  department.department_id,
			department.department_name
  )

SELECT employees.employee_name,department.department_name, employees.salary,Avg_Salary
FROM employees
inner join department
ON employees.department_id=department.department_id
inner join CTE_AVG_SAL
ON employees.department_id=CTE_AVG_SAL.department_id
WHERE employees.salary>CTE_AVG_SAL.Avg_Salary ;

/*=========================================================
SECTION 2 - Window Functions

Business Objective:
Perform ranking analysis to identify top-paid employees
within each department.

Concepts Used:
✔ CTE
✔ Window Functions
✔ RANK()
✔ DENSE_RANK()
✔ ORDER BY
=========================================================*/
/*Query 8: Highest Paid Employee in Each Department

Business Problem:
Identify the employee receiving the highest salary in
every department.*/

with high_salary as
(
select employees.employee_name,department.department_name,employees.salary,
  rank() over(partition by department_name order by salary desc) as rank_no
  from employees
  inner join department
  on employees.department_id= department.department_id
  )
select employee_name,department_name,salary,rank_no
from  high_salary
where rank_no = 1;

/*Query 9: Second Highest Paid Employee in Each Department

Business Problem:
Retrieve the second highest-paid employee from each
department for salary benchmarking.*/
with high_salary as
(
select employees.employee_name,
	   department.department_name,
	   employees.salary,
  dense_rank() over(partition by department_name order by salary desc) as rank_no
  from employees
  inner join department
  on employees.department_id= department.department_id
  )
select employee_name,department_name,salary,rank_no
from  high_salary
where rank_no = 2;

/*=====================================================
Query 10: Top Two Highest Paid Employees in Each Department

Business Problem:
Identify the top two highest-paid employees in every
department to support compensation analysis.

Concepts Used:
✔ CTE
✔ DENSE_RANK()
✔ Window Functions
✔ ORDER BY
=======================================================*/

 with high_salary as
(
select e.employee_name,
       d.department_id,
       e.salary,
  dense_rank() over(partition by department_id order by salary desc) as rank_no
  from employees e
  inner join department d
  on e.department_id= d.department_id
 
  )
select employee_name,department_id,salary,rank_no
from  high_salary
where rank_no <=2
order by 2;


/*=====================================================
SECTION 3 - Performance Analytics

Business Objective:
Analyze employee performance and bonus distribution to
support HR decision-making.

Concepts Used:
✔ INNER JOIN
✔ Aggregate Functions
✔ Subqueries
✔ GROUP BY
✔ ORDER BY
=======================================================*/

/*Query 11: Employees with Excellent Performance and
Above-Average Bonus

Business Problem:
Identify employees who have an excellent performance
rating and receive bonuses greater than the company
average bonus.*/

select e.employee_name,
	d.department_name,
    p.performance_rating,
    p.bonus
from employees e
inner join performance p
on e.employee_id = p.employee_id
inner join department d
on e.department_id = d.department_id
where performance_rating = 5 
and bonus >
(
  SELECT avg(performance.bonus) AS Avg_bonus
  from performance
);

/*Query 12: Department-wise Performance Summary

Business Problem:
Generate a department-level performance report showing
average performance rating, bonus statistics, and employee
count for HR analysis.*/

select d.department_id,d.department_name,
      ROUND(avg(p.performance_rating),2) as Average_Rating,
      ROUND(avg(p.bonus),2) as Average_bonus,
      COUNT(e.employee_id) AS Employee_Count,
      SUM(p.bonus) AS Total_Bonus,
      MAX(p.bonus) AS Max_Bonus
from employees e
join department d
on e.department_id = d.department_id
join  performance p
on e.employee_id = p.employee_id
group by d.department_name,d.department_id
order by department_id;

/*=========================================================
SECTION 4 - Employee Master Report

Business Objective:
Generate a consolidated employee report by combining
employee, department, job, and performance information
into a single view for HR analysis.

Concepts Used:
✔ INNER JOIN
✔ CASE Statement
✔ ORDER BY
=========================================================*/

/*========================================================
Query: Employee Master Report

Business Problem:
Generate a comprehensive HR report displaying employee,
department, job role, salary, experience, performance
rating, bonus, and performance status.
====================================================*/

select e.employee_id,
	   e.employee_name,
       d.department_name,
       j.job_title,
       e.salary,
       e.experience_years,
       p.performance_rating,
       p.bonus,
       case
			when p.performance_rating = 1 then 'Needs Improvement'
            when p.performance_rating = 2 then 'Average'
            when p.performance_rating = 3 then 'Good'
            when p.performance_rating = 4 then 'Very Good'
            when p.performance_rating = 5 then 'Excellent'
	   end as performance_status
from employees e
inner join department d
on e.department_id = d.department_id
inner join jobs j
on e.job_id = j.job_id
inner join performance p
on e.employee_id = p.employee_id
order by e.employee_id;