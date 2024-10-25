/*
Answer: What are the top skills based on salary?
- Look at the average salary associated with each skill for Data Analyst positions.
- Focuses on roles with specified salaries, regardless of location. (Anwhere, Remote work, etc.)
- Why? Highlight the most lucrative skills for Data Analysts to acquire or improve, offering insights.
*/

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

/*
Here are some insights and trends based on the top-paying skills for data analysts from the analysis:

    1. Cloud and Big Data Technologies
- Pyspark, Databricks, Couchbase, and GCP are all linked to big data processing and cloud computing. The rise of big data has made these technologies critical for data handling and analysis, reflecting their high salaries.
- Databricks and Pyspark are particularly significant due to their association with Apache Spark, a popular framework for big data processing, emphasizing the need for efficiency in large-scale data environments.
    2. Machine Learning and AI
- Skills like Watson and Datarobot indicate a strong trend toward incorporating machine learning and AI into data analysis. The demand for analysts who can leverage these tools for predictive analytics is increasing, leading to higher average salaries.
Scikit-learn also shows the importance of traditional machine learning libraries in data analysis.
    3. DevOps and Collaboration Tools
- Tools such as GitLab, Bitbucket, and Jenkins highlight the importance of collaboration and version control in data projects. As data analysis becomes more integrated with software development processes, familiarity with these tools can lead to higher pay.
- The mention of Kubernetes indicates a trend toward containerization in data workflows, reflecting the growing importance of managing applications in cloud environments.
    4. Programming Languages
- Swift and Golang show that expertise in versatile programming languages is valued, particularly in developing applications that interact with data systems or for data manipulation.
- Pandas and NumPy are foundational Python libraries for data manipulation, demonstrating that proficiency in Python remains essential for data analysts.
    5. Data Visualization and Workflow Management
- Tools like Airflow for orchestration and MicroStrategy for business intelligence indicate a growing need for skills that facilitate data visualization and management of data workflows.
- The use of Jupyter notebooks is significant in data exploration and sharing insights, emphasizing the trend toward reproducible and collaborative data analysis.
    6. Database Management
- Knowledge of PostgreSQL and Elasticsearch showcases the importance of handling both relational and NoSQL databases, reflecting the diversity in data storage solutions.
- The rise of database-related skills indicates that understanding how to store, retrieve, and manipulate data effectively is still a top priority for analysts.
    7. Emerging Technologies
- The presence of skills related to Twilio (for communication APIs) and Notion (for project management) indicates that data analysts are expected to be versatile and comfortable with integrating various tools into their workflows.
- The focus on Atlassian tools suggests that project management and team collaboration are increasingly critical components of data analysis roles.

    Conclusion
The trends highlight a growing demand for data analysts with diverse skills, particularly in cloud technologies, machine learning, and collaborative tools. As organizations rely more on data-driven decision-making, proficiency in these high-paying skills will likely continue to be a key factor in salary potential.
*/