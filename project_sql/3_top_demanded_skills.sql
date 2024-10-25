/* 
Question: What are the top demanded skills for data analyst jobs?
- Join job postings to inner join table similar to query 2
- Identify the top 5 in-demand skills for Data Analyst roles.
- Focus on all job postings
- Why? Highlight the most sought-after skills for Data Analysts, offering insights.
*/

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

-- In-Demand skills for Data Analysts and Remote Work --
SELECT 
  skills,
  COUNT(skills_job_dim.job_id) AS demand_count
FROM 
  job_postings_fact AS jp  
INNER JOIN 
  skills_job_dim ON jp.job_id = skills_job_dim.job_id 
INNER JOIN 
  skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
  job_title_short = 'Data Analyst'  AND
  job_work_from_home = True  
GROUP BY
  skills  
ORDER BY
    demand_count DESC
LIMIT 5;   
