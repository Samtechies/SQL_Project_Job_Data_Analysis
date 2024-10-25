# Introduction
Dive into the data job market! Focusing on data analyst roles, this project explores top-paying jobs, in-demand skills, and where high demand meets high salary in data analytics.

SQL queries? Check them out here: [project_sql folder](/project_sql/)
# Background
Driven by a quest to navigate the data analyst job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining others work to find optimal jobs.

Source Dataset [SQL Dataset](https://lukebarousse.com/sql)

### The Questions I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn? 

# Tools I Used
For my deep dive into the data analyst job market, I utilized the following tools:

- **SQL:** The backbone of my analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL:** The chosen database management system, ideal for handling the job postings data.
- **Visual Studio Code:** My go-to database management system and executing SQL queries
- **Git & Github:** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.
# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here's how I approached each question:

### 1. Top Paying Data Analyst Jobs
This query highlights the high paying copportunities in the field.

```sql
SELECT 
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN
    company_dim ON job_postings_fact.company_id = company_dim.company_id    
WHERE 
    job_title_short = 'Data Analyst' 
    AND job_location = 'Anywhere'
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;    

SELECT *
FROM job_postings_fact
```
![Top Paying Roles](assets\sql-top-paying-jobs.jpg)
*Bar graph visualizing the salary for the top 10 salaries for data analysts; ChatGPT generated this graph from my SQL query results*

### 2. What are the skills required for these top-paying roles?
To understand what skills are requiered for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

```sql
WITH top_paying_jobs AS (
    SELECT 
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN
        company_dim ON job_postings_fact.company_id = company_dim.company_id    
    WHERE 
        job_title_short = ('Data Analyst')
        AND job_location = 'Anywhere'
        AND salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
  top_paying_jobs.*,
  skills
FROM 
  top_paying_jobs
INNER JOIN 
  skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id 
INNER JOIN 
  skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id  
ORDER BY
  salary_year_avg DESC;  
```
Here's the breakdown of the most demanded skills for the top 10 highest paying data analyst jobs in 2023:
- **SQL** is leading with a count of 8
- **Python** follows closely with a bold count of 7.
- **Tableau** is also highly sought after, with a bold count of 6. Other skills like **R, Snowflake, Pandas** and **Excel** show vatying degrees of demand

### 3. In-Demand Skills for Data Analysts
This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
SELECT 
  skills,
  COUNT(skills_job_dim.job_id) AS demand_count
FROM 
  job_postings_fact AS jp  
INNER JOIN 
  skills_job_dim ON jp.job_id = skills_job_dim.job_id 
INNER JOIN 
  skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id  
GROUP BY
  skills  
ORDER BY
    demand_count DESC
LIMIT 5;
```

Here's the breakdown of the most demanded skills for data analysts in 2023
- **SQL** and **Excel** remain fundamental, emphasizing the need for strong foundational skills in data processing and spreadsheet manipulation.
- **Programming** and **Visualization Tools** like **Python**,**Tableau**, and **Power BI** are essential, pointing towards increasing importance of technical skills in data storytelling and decision support.

### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
SELECT 
  skills,
  ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM 
  job_postings_fact AS jp  
INNER JOIN 
  skills_job_dim ON jp.job_id = skills_job_dim.job_id 
INNER JOIN 
  skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
  job_title_short = 'Data Analyst'  
  AND salary_year_avg IS NOT NULL
  AND job_work_from_home = True  
GROUP BY
  skills 
ORDER BY
    avg_salary DESC
LIMIT 25;  
```
Here's a breakdown of the results for top paying skills for Data Analysts:
## Cloud and Big Data Technologies
- Pyspark, Databricks, Couchbase, and GCP are all linked to big data processing and cloud computing. The rise of big data has made these technologies critical for data handling and analysis, reflecting their high salaries.
- Databricks and Pyspark are particularly significant due to their association with Apache Spark, a popular framework for big data processing, emphasizing the need for efficiency in large-scale data environments.
## Machine Learning and AI
- Skills like Watson and Datarobot indicate a strong trend toward incorporating machine learning and AI into data analysis. The demand for analysts who can leverage these tools for predictive analytics is increasing, leading to higher average salaries.
- Scikit-learn also shows the importance of traditional machine learning libraries in data analysis.
## DevOps and Collaboration Tools
- Tools such as GitLab, Bitbucket, and Jenkins highlight the importance of collaboration and version control in data projects. As data analysis becomes more integrated with software development processes, familiarity with these tools can lead to higher pay.
- The mention of Kubernetes indicates a trend toward containerization in data workflows, reflecting the growing importance of managing applications in cloud environments.
## Programming Languages
- Swift and Golang show that expertise in versatile programming languages is valued, particularly in developing applications that interact with data systems or for data manipulation.
- Pandas and NumPy are foundational Python libraries for data manipulation, demonstrating that proficiency in Python remains essential for data analysts.
## Data Visualization and Workflow Management
- Tools like Airflow for orchestration and MicroStrategy for business intelligence indicate a growing need for skills that facilitate data visualization and management of data workflows.
- The use of Jupyter notebooks is significant in data exploration and sharing insights, emphasizing the trend toward reproducible and collaborative data analysis.
## Database Management
- Knowledge of PostgreSQL and Elasticsearch showcases the importance of handling both relational and NoSQL databases, reflecting the diversity in data storage solutions.
- The rise of database-related skills indicates that understanding how to store, retrieve, and manipulate data effectively is still a top priority for analysts.
## Emerging Technologies
- The presence of skills related to Twilio (for communication APIs) and Notion (for project management) indicates that data analysts are expected to be versatile and comfortable with integrating various tools into their workflows.
- The focus on Atlassian tools suggests that project management and team collaboration are increasingly critical components of data analysis roles.
# What I learned
Throughtout this adventure, I've enhanced my SQL toolkit with same serious firepower:

- **Complex Query Crafting:** Mastered the art of advanced SQL, merging tables like a pro and wielding WITH clauses for ninja-level manouvers
- **Data Aggregation:** Got cozy with GROUP BY clause and turned aggregate functions like COUNT() and AVG() into my data-summarizing sidekicks
- **Analytical Wizadry:** Leveled up my real-world puzzle-solving skills, turning questions into actionable, insightful SQL queries.
# Closing Thoughts
This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics
