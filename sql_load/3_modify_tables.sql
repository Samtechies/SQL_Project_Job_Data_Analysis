/* ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️
Database Load Issues (follow if receiving permission denied when running SQL code below)

NOTE: If you are having issues with permissions. And you get error: 

'could not open file "[your file path]\job_postings_fact.csv" for reading: Permission denied.'

1. Open pgAdmin
2. In Object Explorer (left-hand pane), navigate to `sql_course` database
3. Right-click `sql_course` and select `PSQL Tool`
    - This opens a terminal window to write the following code
4. Get the absolute file path of your csv files
    1. Find path by right-clicking a CSV file in VS Code and selecting “Copy Path”
5. Paste the following into `PSQL Tool`, (with the CORRECT file path)

\copy company_dim FROM 'C:\Users\user\Desktop\SQL_Project_Job_Data_Analysis\csv_files\company_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy skills_dim FROM 'C:\Users\user\Desktop\SQL_Project_Job_Data_Analysis\csv_files\skills_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy job_postings_fact FROM 'C:\Users\user\Desktop\SQL_Project_Job_Data_Analysis\csv_files\job_postings_fact.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy skills_job_dim FROM 'C:\Users\user\Desktop\SQL_Project_Job_Data_Analysis\csv_files\skills_job_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

*/

-- NOTE: This has been updated from the video to fix issues with encoding

COPY company_dim
FROM 'C:\Users\user\Desktop\SQL_Project_Job_Data_Analysis\csv_files\company_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY skills_dim
FROM 'C:\Users\user\Desktop\SQL_Project_Job_Data_Analysis\csv_files\skills_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY job_postings_fact
FROM 'C:\Users\user\Desktop\SQL_Project_Job_Data_Analysis\csv_files\job_postings_fact.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY skills_job_dim
FROM 'C:\Users\user\Desktop\SQL_Project_Job_Data_Analysis\csv_files\skills_job_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

SELECT *
FROM job_postings_fact
LIMIT 100;

SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time,
    EXTRACT(MONTH FROM job_posted_date) AS date_month,
    EXTRACT(YEAR FROM job_posted_date) AS date_year

FROM 
    job_postings_fact
LIMIT 5;  

SELECT
    COUNT(job_id) AS job_posted_count,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM
    job_postings_fact  
WHERE
    job_title_short = 'Data Analyst' 
GROUP BY
    month
ORDER BY
    job_posted_count DESC;       
    

-- Write a  Query to find the average salary both yearly (salary_year_avg) and hourly (salary_hour_avg) for all job postings that were posted after June 1,2023. Group the results by job schedule type -- 

SELECT
    job_schedule_type,
    AVG(salary_year_avg) AS avg_salary_yearly,
    AVG(salary_hour_avg) AS avg_salary_hourly
FROM
    job_postings_fact
WHERE
    job_posted_date > '2023-06-01'
GROUP BY
    job_schedule_type;         

-- Write a Query to count the number of job postings for each month in 2023, adjusting the job_posted_date to be in 'America/New' time zone before extracting (hint) the month. Assume the job_posted_date is stored in UTC. Group by and order by the month.
--     

SELECT
    COUNT(job_id) AS job_posted_count,
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS month
FROM 
    job_postings_fact
WHERE
    EXTRACT(YEAR FROM job_posted_date) = 2023
GROUP BY
    month
ORDER BY
    month DESC;        

SELECT
    COUNT(job_id) AS jobs_postings,
    EXTRACT(MONTH FROM job_posted_date) AS MONTH
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    MONTH     
ORDER BY
    MONTH DESC
LIMIT 10;            

-- PRACTICE PROBLEM 6 --
-- Create Tables from Other Tables --
-- Question: Create three tables: Jan 2023 jobs, Feb 2023 jobs, Mar 2023 jobs --
-- Foreshadowing: This will be used in another practice problem below --
-- Hints: Use CREATE TABLE table_name AS syntax to create table, Look at a way to filter out only specific months (EXTRACT) --

--January--
CREATE TABLE january_jobs AS
SELECT * 
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

--February--
CREATE TABLE february_jobs AS
SELECT * 
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

--March--
CREATE TABLE march_jobs AS
SELECT * 
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

DROP TABLE job_postings_march;

SELECT job_posted_date
FROM march_jobs
LIMIT 10;

SELECT
    job_title_short, job_location
FROM
    job_postings_fact;    
/*

Label new column as follows:
- 'Anywhere' jobs as 'Remote'
-'New York, NY' jobs as 'Local'
- Otherwise 'Onsite'

*/
-- ADVANCED CASE EXPRESSIONS

SELECT 
    COUNT(job_id) AS number_of_jobs,
    --job_title_short AS job_title,
    --job_location,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category    
FROM
    job_postings_fact
WHERE
job_title_short = 'Data Analyst'    
GROUP BY
        location_category;

--Practice Problem--
/*
I want to categorize the salaries from each job posting. To see if it fits in my desired salary range 
- Put salary into different buckets
-Define what's a high, standard, or low salary with your own conditions 
-Only want to look at Data Analyst Roles
-Order from highest to lowest
*/    --

SELECT 
    COUNT(job_id) AS job_postings,                    -- Count the number of job postings
    CASE
        WHEN salary_year_avg <= 80000 THEN 'Low Paying Job'      -- 80k and below
        WHEN salary_year_avg > 80000 AND salary_year_avg <= 150000 THEN 'Standard Paying Job'  -- Between 80k and 150k
        WHEN salary_year_avg > 150000 THEN 'High Paying Job'     -- Above 150k
    END AS salary_category                               -- Classify the jobs by salary
FROM 
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'                   -- Filter only for 'Data Analyst' jobs
GROUP BY 
    salary_category                                    -- Group by the salary classification
ORDER BY 
    salary_category;                                   -- Order the results by salary category (optional)

-- SUBQUERIES AND CTEs

SELECT *
FROM (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1 
  )  AS january_jobs;

--Using With
WITH january_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
)
SELECT *
FROM january_jobs;

--Example 2
SELECT 
    company_id,
    job_no_degree_mention
FROM 
    job_postings_fact        
WHERE
    job_no_degree_mention = TRUE
-- Using  Sub Queries
SELECT
    company_id,
    name AS company_name
FROM 
    company_dim
WHERE company_id IN(
    SELECT 
        company_id
    FROM
        job_postings_fact
    WHERE                 
        job_no_degree_mention = TRUE
    ORDER BY
        company_id    
     
)      
-- Using CTEs  
/*
Find the company with the most job openings.
-Get the total number of job postings per company id
-Return the total number of jobs with the company name
*/

WITH company_job_count AS (
    SELECT
        company_id,               -- Selecting company_id for counting
        COUNT(job_id) AS job_count -- Counting job postings per company
    FROM
        job_postings_fact          -- Using job_postings_fact table
    GROUP BY
        company_id                 -- Grouping by company_id
)

-- Solution 2

WITH company_job_count AS (
SELECT
    company_id,
    COUNT(*) AS total_jobs
FROM 
    job_postings_fact    
GROUP BY
    company_id    
)

SELECT 
    company_dim.name AS company_name, 
    company_job_count.total_jobs
FROM 
    company_dim
LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id
ORDER BY
    total_jobs DESC

/*
Find the count of the number of remote job postings per skill
    - Display the top 5 skills by their demand in remote jobs
    - Include skill ID, name, and count of postings requiring the skill
*/

SELECT 
    skills_dim
FROM 
    skills_job_dim AS skills_to_job    

-- UNION OPERATORS
-- UNION

-- Get jobs and Companies from January
SELECT 
    job_title_short AS job_title,
    company_id,
    job_location
FROM
    january_jobs

UNION ALL

-- Get jobs and Companies from February
SELECT 
    job_title_short AS job_title,
    company_id,
    job_location
FROM
    february_jobs    

UNION ALL   

-- Get jobs and Companies from March
SELECT 
    job_title_short AS job_title,
    company_id,
    job_location
FROM
    march_jobs        

/*
Find job postings from the first quarter that have a salary greater than $70,000    
- Combine job posting tables from the first quarter of 2023 (Jan, Feb, Mar)
- Get job postings with an average yearly salary > $70,000
*/

SELECT 
    job_title_short AS job_title,
    salary_year_avg AS avg_salary,
    job_location AS location,
    job_posted_date
FROM
    january_jobs
WHERE
    salary_year_avg > 70000    
    AND job_title_short = 'Data Analyst'

UNION ALL

SELECT 
    job_title_short AS job_title,
    salary_year_avg AS avg_salary,
     job_location AS location,
    job_posted_date
FROM
    february_jobs
WHERE
    salary_year_avg > 70000    
    AND job_title_short = 'Data Analyst'

UNION ALL    

SELECT 
    job_title_short AS job_title,
    salary_year_avg AS avg_salary,
     job_location AS location,
    job_posted_date
FROM
    march_jobs
WHERE
    salary_year_avg > 70000
    AND job_title_short = 'Data Analyst'    
ORDER BY
    avg_salary DESC;    

-- Solution 2 (Shorter Method)    
SELECT
    first_quarter_job_postings.job_title_short,
    first_quarter_job_postings.job_location,
    first_quarter_job_postings.salary_year_avg,
    first_quarter_job_postings.job_via,
    first_quarter_job_postings.job_posted_date::date
FROM (
    SELECT *
    FROM january_jobs

    UNION ALL

    SELECT *
    FROM february_jobs

    UNION ALL

    SELECT *
    FROM march_jobs
) AS first_quarter_job_postings  
WHERE
    salary_year_avg > 70000
    AND job_title_short = 'Data Analyst'
ORDER BY
    salary_year_avg DESC;   

-- Problem 7--
-- IN DEMAND SKILLS OF A DATA ANALYST
WITH remote_job_skills AS (
    SELECT
        skill_id,
        COUNT(*) AS skill_count
    FROM
        skills_job_dim AS skills_to_job
    INNER JOIN    
        job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id  
    WHERE
        job_postings.job_work_from_home = True AND
        job_postings.job_title_short = 'Data Analyst'
    GROUP BY
        skill_id 
)       

SELECT
    skills.skill_id,
    skills AS skill_name,
    skill_count
FROM
    remote_job_skills
INNER JOIN
    skills_dim AS skills ON skills.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 50;                  