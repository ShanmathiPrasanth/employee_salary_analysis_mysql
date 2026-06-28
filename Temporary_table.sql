/*====================================================
PROJECT: Employee Promotion Eligibility Report

Business Problem:
Identify employees eligible for promotion based on
performance, experience, and department average salary.

Eligibility Criteria:
✔ Performance Rating >= 4
✔ Experience >= 5 years
✔ Salary <= Department Average Salary

Concepts Used:
✔ Temporary Table
✔ Derived Table
✔ Aggregate Function
✔ INNER JOIN
====================================================*/
use employee_salary_analysis;

drop temporary table if exists promotion_eligibility;

create temporary table promotion_eligibility as

select e.employee_name as employee,
       d.department_name as department,
       e.experience_years as experience,
       e.salary as salary,
       p.performance_rating as performance_rating,
       p.bonus as bonus,
       round(avg_sal.salary_avg,2) as department_average_salary
from employees e

inner join department d
on e.department_id = d.department_id

inner join
(
    select department_id,
           avg(salary) as salary_avg
    from employees
    group by department_id
) as avg_sal
on e.department_id = avg_sal.department_id

inner join performance p
on e.employee_id = p.employee_id

where p.performance_rating >= 4
and e.experience_years >= 5
and e.salary <= avg_sal.salary_avg;

-- view the temporary table
select *
from promotion_eligibility;


/*=========================================================
END OF PROJECT

Thank you for reviewing this project.

Author:
Shanmathi Sampath

Skills Demonstrated:
✔ Database Design
✔ SQL Joins
✔ Aggregate Functions
✔ GROUP BY
✔ HAVING
✔ CTE
✔ Window Functions
✔ CROSS JOIN
✔ CASE Statements
✔ Stored Procedures
✔ Temporary Tables

=========================================================*/