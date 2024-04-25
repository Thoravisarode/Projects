create database hr_analytics;
-- Cards
-- Total Employees
select count(distinct(EmployeeNumber)) as 'Total Employees'
from `merged dataset hr analytics`;

-- Male Employees
select count(distinct(EmployeeNumber)) as 'Male Employees'
from `merged dataset hr analytics`
where Gender='Male';

-- Female Employees
select count(distinct(EmployeeNumber)) as 'Female Employees'
from `merged dataset hr analytics`
where Gender='Female';

-- Attrition count 
select count(*) as Attrition_count
from `merged dataset hr analytics`
where attrition='yes';

-- Active employees
SELECT 
(SELECT count(distinct(EmployeeNumber)) as 'Total Employees'
from `merged dataset hr analytics`) - 
(SELECT COUNT(*) FROM `merged dataset hr analytics` 
where Attrition = 'yes') AS "Active Employees";

-- Average age
select round(avg(Age)) as Average_age
from `merged dataset hr analytics`;

-- Average working years 
select round(avg(`HR 2.TotalWorkingYears`),2) as Average_working_years
from `merged dataset hr analytics`;

-- Average monthly income 
select round(avg(`HR 2.MonthlyIncome`)) as Average_Salary
from `merged dataset hr analytics`;

-- Average job satisfaction
select round(avg(JobSatisfaction)) as Average_job_Satisfaction 
from `merged dataset hr analytics`;

-- Total Attrition rate
select
concat(
round(((select count(*) as Attrition_count
from `merged dataset hr analytics`
where attrition='yes')
/ 
(select count(distinct(EmployeeNumber))
from `merged dataset hr analytics`))*100,2),'%') AS 'Attrition rate';

-- Male Attrition rate
select
concat(
round(((select count(*) as Attrition_count
from `merged dataset hr analytics`
where attrition='yes' and Gender='Male')
/ 
(select count(distinct(EmployeeNumber))
from `merged dataset hr analytics`))*100,2),'%') AS 'Attrition rate';

-- Female Attrition rate
select
concat(
round(((select count(*) as Attrition_count
from `merged dataset hr analytics`
where attrition='yes' and Gender='Female')
/ 
(select count(distinct(EmployeeNumber))
from `merged dataset hr analytics`))*100,2),'%') AS 'Attrition rate';

-- Charts
-- 1. Education Field wise Active Employees
select EducationField,count(EmployeeNumber) as Employees
from `merged dataset hr analytics`
where Attrition='no'
group by EducationField
order by Employees desc;

-- 2. Department wise active employees
select department,count(EmployeeNumber) as Employees
from `merged dataset hr analytics`
where Attrition='no'
group by Department
order by Employees desc;

-- 3. Bussiness travel wise attrition rate
select distinct(BusinessTravel) as 'Business Travel',
CONCAT(ROUND((                
count(if(Attrition = 'Yes',1,0))                 
/                 
(select sum(EmployeeCount) from `merged dataset hr analytics`)                 
) * 100, 2),'%') AS 'Attrition rate' 
from `merged dataset hr analytics`
group by BusinessTravel
;

-- 4. Attrition by age group 
SELECT Gender,Age_Group,     
sum(if(Attrition='yes',1,0)) AS Attrition_Count,     
CONCAT(ROUND((                
sum(if(Attrition = 'Yes',1,0))                 
/                 
(select sum(EmployeeCount) from `merged dataset hr analytics`)                 
) * 100, 2),'%') AS 'Attrition rate' 
FROM (     
SELECT *,         
CASE             
WHEN Age BETWEEN 18 AND 25 THEN '18-25'            
 WHEN Age BETWEEN 26 AND 35 THEN '26-35'             
 WHEN Age BETWEEN 36 AND 45 THEN '36-45'             
 WHEN Age BETWEEN 46 AND 55 THEN '46-55'             
 ELSE '55+'         
 END AS Age_Group     
 FROM `merged dataset hr analytics` ) AS t 
 group by Age_Group, Gender 
 ORDER BY Age_Group, Gender;


-- 5. Employee count by year of joining 
select distinct(`Year of Joining`) as 'year of joining',sum(EmployeeCount) as Employee_count
from `merged dataset hr analytics`
group by `Year of Joining`
order by `Year of Joining`;

-- 6. job role wise job satisfaction
select JobRole,JobSatisfaction,count(distinct(EmployeeNumber)) as Employee_count
from `merged dataset hr analytics`
group by JobRole, JobSatisfaction;

-- 7. Departmant wise attrition rate    
SELECT 
    Department,
    SUM(EmployeeCount) AS Employee,
    CONCAT(
        ROUND((
            count(IF(Attrition = 'Yes', 1, 0))
            /
            (select count(EmployeeCount) 
            from `merged dataset hr analytics`)
            ) * 100, 2),'%'
    ) AS 'Attrition rate'
FROM 
    `merged dataset hr analytics`
WHERE 
    Attrition = 'Yes'
GROUP BY 
    Department;


-- 8. Attrition vs year since last promotion
select distinct(`HR 2.YearsSinceLastPromotion`) as 'Year Since Last Promotion',
sum(if(Attrition='yes',1,0)) AS Attrition_Count,
   CONCAT(
        ROUND((
            sum(IF(Attrition = 'Yes', 1, 0))
            /
            (select sum(EmployeeCount) 
            from `merged dataset hr analytics`)
            ) * 100, 2),'%'
    ) AS 'Attrition rate'
from `merged dataset hr analytics`
group by `HR 2.YearsSinceLastPromotion`
order by `HR 2.YearsSinceLastPromotion`;


-- 9. Department and job role wise monthly income 
select department,JobRole,round(avg(`HR 2.MonthlyIncome`),2) as "Monthly income"
from `merged dataset hr analytics`
group by Department,JobRole
order by avg(`HR 2.MonthlyIncome`) desc;

-- 10. gender & Marital status wise attrition rate
select Gender,MaritalStatus, sum(IF(Attrition = 'Yes', 1, 0)) as 'Attrition Count',
    CONCAT(
        ROUND((
            sum(IF(Attrition = 'Yes', 1, 0))
            /
            (select sum(EmployeeCount) 
            from `merged dataset hr analytics`)
            ) * 100, 2),'%'
    ) AS 'Attrition rate'
from `merged dataset hr analytics`
group by Gender,MaritalStatus
order by Gender
;

-- 11. Average working years wise Attrition
select `HR 2.YearsAtCompany` as 'Avg working years',
sum(if(attrition='yes',1,0)) as 'Attrition count',
concat(
round((
sum(if(attrition='yes',1,0)) 
/
(select sum(EmployeeCount) 
from `merged dataset hr analytics`)
)*100,2),'%') as 'Attrition rate'
from `merged dataset hr analytics`
group by `HR 2.YearsAtCompany`
order by `HR 2.YearsAtCompany`;

-- 12. Job role wise job level, job satisfaction and worklife balance
select 
JobRole,
round(avg(JobLevel),0) as 'Job Level',
round(avg(JobSatisfaction),0) as 'Job Satisfaction',
round(avg(`HR 2.WorkLifeBalance`),0) as 'Work life balance'
from `merged dataset hr analytics`
group by JobRole;

-- 13. Education Field wise Active employees & Attrition
select EducationField, 
sum(EmployeeCount)
-
(select sum(if(attrition='yes',1,0))) as 'Active Employees',
sum(if(Attrition='yes',1,0)) as 'Attrition count',
concat(round((sum(if(Attrition='yes',1,0))
/
(select sum(EmployeeCount)
from `merged dataset hr analytics`))*100,2),'%') as 'Attrition Rate'
from `merged dataset hr analytics`
group by EducationField;

-- 14. Distance from home wise Attrition 
select DistanceFromHome,
sum(if(Attrition='yes',1,0)) as 'Attrition count',
concat(round(sum(if(Attrition='yes',1,0))
/
(select sum(EmployeeCount)as 'Attrition rate'
from `merged dataset hr analytics`)*100,2),'%') as 'Attrition Rate'
from `merged dataset hr analytics`
group by DistanceFromHome
order by DistanceFromHome;

-- 15. Employee Count & attrition by year of joining
select 
`Year of Joining`,`HR 2.Month of Joining`,
count(distinct(EmployeeNumber)) as 'Employee Count',
sum(if(attrition='yes',1,0)) as 'Attrition Count',
concat(round(sum(if(Attrition='yes',1,0))
/
(select sum(EmployeeCount)as 'Attrition rate'
from `merged dataset hr analytics`)*100,2),'%') as 'Attrition Rate'
from `merged dataset hr analytics`
group by `Year of Joining`,`HR 2.Month of Joining`
order by `Year of Joining`;

-- 16. Month wise HR 2.PercentSalaryHike
select `HR 2.Monthe Name`,
concat(round((sum(`HR 2.PercentSalaryHike`)/1000),2),'K') as 'Percent Salary Hike'
from `merged dataset hr analytics`
group by `HR 2.Monthe Name`
order by ROUND(SUM(`HR 2.PercentSalaryHike`) / 1000, 2) DESC;




