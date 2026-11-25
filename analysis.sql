-- Diabetes in the Gulf states: all SQL used in this project (PostgreSQL / Supabase)

-- 1. Create the table, then import diabetes_prevalence.csv into it
drop table if exists diabetes_prevalence;

create table diabetes_prevalence (
  country        text,
  code           text,
  year           int,
  prevalence_pct numeric
);

-- 2. Quality check: find rows that should not be used (returns 35 rows)
--    - a value of 0 is impossible
--    - several small islands share exactly 12.1 in 2000: a filled-in estimate, not a measurement
--    - codes starting with OWID_ or WB_ are groups (World, regions, income groups), not countries
select country, code, year, prevalence_pct
from diabetes_prevalence
where prevalence_pct = 0
   or (year = 2000 and prevalence_pct = 12.1)
   or code like 'OWID_%'
   or code like 'WB_%'
order by code, year;

-- Finding: Kosovo (OWID_KOS) is a real country with a non-standard code,
-- so the group rule above wrongly catches it. It is kept in the clean view below.

-- 3. Clean view: the original table stays untouched (returns 421 rows)
create view diabetes_clean as
select country, code, year, prevalence_pct
from diabetes_prevalence
where prevalence_pct > 0
  and not (year = 2000 and prevalence_pct = 12.1)
  and (code not like 'OWID_%' or code = 'OWID_KOS')
  and code not like 'WB_%';

select count(*) from diabetes_clean;

-- 4. Analysis: Gulf states vs Denmark, 2011 vs 2024
select country,
  max(case when year = 2011 then prevalence_pct end) as pct_2011,
  max(case when year = 2024 then prevalence_pct end) as pct_2024,
  max(case when year = 2024 then prevalence_pct end)
    - max(case when year = 2011 then prevalence_pct end) as change
from diabetes_clean
where code in ('KWT','QAT','SAU','BHR','ARE','OMN','DNK')
group by country
order by pct_2024 desc;

-- 5. Dashboard data: same comparison plus the world average, rounded
--    (uses the original table because the world average is a group row, removed from the clean view)
select country,
  round(max(case when year = 2011 then prevalence_pct end), 1) as pct_2011,
  round(max(case when year = 2024 then prevalence_pct end), 1) as pct_2024,
  round(max(case when year = 2024 then prevalence_pct end)
      - max(case when year = 2011 then prevalence_pct end), 1) as change
from diabetes_prevalence
where code in ('KWT','QAT','SAU','BHR','ARE','OMN','DNK','OWID_WRL')
group by country
order by pct_2024 desc;
