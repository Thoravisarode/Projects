Create database HR_Attrition;
use hr_attrition;

### Total Employees and Average Age
select count(EmployeeNumber)as Total_Emp, round(avg(ï»¿Age),0) as Avg_age
from hr_1;

### Average working years
select round(avg(YearsAtCompany),0) 
as 'Average working years'
from hr_2;

### Attrition Rate
Select concat(round(count(Attrition)/(select count(EmployeeNumber) from hr_1)*100,2),'%') as Attrition_rate
from hr_1
where Attrition = "Yes";

### Male Attrition rate
select
concat(
round(((select count(*) as Attrition_count
from hr_1
where attrition='yes' and Gender='Male')
/ 
(select count(distinct(EmployeeNumber))
from hr_1))*100,2),'%') AS 'Attrition rate';

### Female Attrition rate
select
concat(
round(((select count(*) as Attrition_count
from hr_1
where attrition='yes' and Gender='Female')
/ 
(select count(distinct(EmployeeNumber))
from hr_1))*100,2),'%') AS 'Attrition rate';

### Gender Count
select Gender, count(Gender) as Gender_count
from hr_1
group by Gender;

### Active Employees
select count(Attrition) as Active_Emp
from hr_1
where Attrition = "No";

### Attrition count
select count(*) as Attrition_count
from hr_1
where attrition='yes';

-- Charts
### 1. Education Field wise Employees
select EducationField,count(EmployeeNumber) as Employees
from hr_1
group by EducationField
order by Employees desc;

### 2. Average Attrition for all Depts
select Department,count(Attrition) as Attrition_count,
concat(round(count(Attrition)/(select count(EmployeeNumber) from hr_1)*100,2),'%') as Attrition_rate
from hr_1
where Attrition = "Yes"
group by Department
order by Attrition_count desc;

### 3. Average Hourly rate of Male Research Scientist
DELIMITER //
create procedure emp_role (in input_gender varchar(20), in input_jobrole varchar(30))
begin
 select Gender, round(avg(HourlyRate),2) as `Avg Hourly Rate` from hr_1
 where gender = input_gender and jobrole = input_jobrole
 group by gender;
end //
DELIMITER ;

call emp_role('male',"Research Scientist");

### 4. Attrition Rate Vs Monthly Income Status
select hr_1.department,
concat(round(count(hr_1.attrition)
/
(select count(hr_1.employeenumber) from hr_1)*100,2),'%') as `Attrition rate`,
round(avg(hr_2.MonthlyIncome),2) as average_income 
from hr_1 
join hr_2 
on hr_1.EmployeeNumber = hr_2.`ï»¿Employee ID`
where attrition = 'Yes'
group by hr_1.department;

### 5. Average Working Year for each dept
select hr_1.department,
Round(avg(hr_2.totalworkingyears),0) as Avr_Wrkg_Year 
from hr_1
join hr_2  
on hr_1.employeenumber = hr_2.`ï»¿Employee ID`
group by hr_1.department
order by Avr_Wrkg_Year;

### 6. Job Role vs Work Life Balance
select hr_1.jobrole,
hr_2.WorkLifeBalance, 
count(hr_2.WorkLifeBalance) as Employee_count
from hr_1  
join hr_2 
on hr_1.employeenumber = hr_2.`ï»¿Employee ID`
group by hr_1.jobrole,hr_2.WorkLifeBalance
order by hr_1.jobrole desc;

### 7. Bussiness travel wise attrition rate
select distinct(BusinessTravel) as 'Business Travel',
CONCAT(ROUND((                
sum(if(Attrition = 'Yes',1,0))                 
/                 
(select sum(EmployeeCount) from hr_1)                 
) * 100, 2),'%') AS 'Attrition rate' 
from hr_1
group by BusinessTravel
;

### 8. Distance vs Attrition
Select DistanceFromHome as Distance_Status, 
concat(round(count(attrition)
/
(select count(employeenumber) from hr_1)*100,2),'%') as attrition_rate 
from hr_1
where attrition = 'Yes'
group by Distance_Status
order by DistanceFromHome;

### 9. Education vs active employees and attrition
select EducationField, 
sum(EmployeeCount)
-
(select sum(if(attrition='yes',1,0))) as 'Active Employees',
sum(if(Attrition='yes',1,0)) as 'Attrition count',
concat(round((sum(if(Attrition='yes',1,0))
/
(select sum(EmployeeCount)
from hr_1))*100,2),'%') as 'Attrition Rate'
from hr_1
group by EducationField;

### 10. Attrition by age group 
create view Attrition_by_age as
SELECT Gender,Age_Group,     
sum(if(Attrition='yes',1,0)) AS Attrition_Count,     
CONCAT(ROUND((                
sum(if(Attrition = 'Yes',1,0))                 
/                 
(select sum(EmployeeCount) from hr_1)                 
) * 100, 2),'%') AS 'Attrition rate' 
FROM (     
SELECT *,         
CASE             
WHEN ï»¿Age BETWEEN 18 AND 25 THEN '18-25'            
 WHEN ï»¿Age BETWEEN 26 AND 35 THEN '26-35'             
 WHEN ï»¿Age BETWEEN 36 AND 45 THEN '36-45'             
 WHEN ï»¿Age BETWEEN 46 AND 55 THEN '46-55'             
 ELSE '55+'         
 END AS Age_Group     
 FROM hr_1 ) AS t 
 group by Age_Group, Gender 
 ORDER BY Age_Group, Gender;

### 11. gender & Marital status wise attrition rate
select Gender,MaritalStatus, sum(IF(Attrition = 'Yes', 1, 0)) as 'Attrition Count',
CONCAT(
ROUND((
sum(IF(Attrition = 'Yes', 1, 0))
/
(select sum(EmployeeCount) from hr_1)) * 100, 2),'%') AS 'Attrition rate'
from hr_1
group by Gender,MaritalStatus
order by Gender;

### 12. Department and job role wise monthly income 
select department,JobRole,
round(avg(MonthlyIncome),2) as "Monthly income"
from hr_1
join hr_2
on hr_1.EmployeeNumber = hr_2.`ï»¿Employee ID`
group by Department,JobRole
order by avg(MonthlyIncome) desc;

### 13. Attrition vs year since last promotion
select distinct(YearsSinceLastPromotion) as 'Year Since Last Promotion',
sum(if(Attrition='yes',1,0)) AS Attrition_Count,
   CONCAT(
        ROUND((
            sum(IF(Attrition = 'Yes', 1, 0))
            /
            (select sum(EmployeeCount) 
            from hr_1)
            ) * 100, 2),'%'
    ) AS 'Attrition rate'
from hr_2
join hr_1 
on hr_2.`ï»¿Employee ID`= hr_1.EmployeeNumber
group by YearsSinceLastPromotion
order by YearsSinceLastPromotion;

### 14. Average working years vs Attrition
select YearsAtCompany as 'Avg working years',
sum(if(attrition='yes',1,0)) as 'Attrition count',
concat(
round((
sum(if(attrition='yes',1,0)) 
/
(select sum(EmployeeCount) 
from hr_1)
)*100,2),'%') as 'Attrition rate'
from hr_2
join hr_1
on hr_2.`ï»¿Employee ID`= hr_1.EmployeeNumber
group by YearsAtCompany
order by YearsAtCompany;

-- 15. JobRole wise EnvironmentSatisfaction and PerformanceRating
select 
JobRole,
round(avg(EnvironmentSatisfaction),2) as 'Environment Satisfaction',
round(avg(PerformanceRating),2) as 'Performance Rating'
from hr_1
join hr_2 on hr_1.EmployeeNumber = hr_2.`ï»¿Employee ID`
group by JobRole,'Environment Satisfaction','Performance Rating'
order by 'Environment Satisfaction','Performance Rating' desc;

