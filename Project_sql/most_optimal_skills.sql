/*
Question: What are the most optimal skills to lear (high-demand and high-paying skills)?
- Identify skills in high-demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote postions with specified salaries
- Why? Target skills that offer job security and financial benefits,
        offering strategic insights for career development in data analysis. 
*/
    
WITH skills_demand AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM 
        job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL AND job_work_from_home = True
    GROUP BY
        skills_dim.skill_id
), salary_avg AS (
    SELECT 
        skills_job_dim.skill_id,
        ROUND(avg(salary_year_avg),0) AS salary
    FROM 
        job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL AND job_work_from_home = True
    GROUP BY
        skills_job_dim.skill_id
)

SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    salary
FROM
    skills_demand
INNER JOIN salary_avg ON skills_demand.skill_id = salary_avg.skill_id
ORDER BY    
    demand_count DESC
LIMIT 25;