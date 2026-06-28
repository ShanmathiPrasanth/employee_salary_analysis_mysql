/*====================================================
PROJECT: Employee Salary Report using Stored Procedure

Business Problem:
Generate an employee report based on a minimum salary
entered by the HR manager.

Concepts Used:
✔ Stored Procedure
✔ Input Parameter
✔ INNER JOIN
✔ WHERE Clause
====================================================*/
use employee_salary_analysis;

delimiter //

create procedure fetch_employees_details(in min_salary int)
begin

select e.employee_name,
       d.department_name,
       j.job_title,
       e.salary,
       p.performance_rating,
       p.bonus
from employees e
inner join department d
on e.department_id = d.department_id
inner join jobs j
on e.job_id = j.job_id
inner join performance p
on e.employee_id = p.employee_id
where e.salary > min_salary;

end //

delimiter ;

-- example
call fetch_employees_details(35000);
