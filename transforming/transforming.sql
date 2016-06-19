-- Aggregate all the hospitals data together
-- best hospitals
-- best states
-- variabilities
-- hospitals and patients

drop table if exists effective_care_clean;
Create table effective_care_clean as
select
provider_id,
hospital_name,
measure_id,
cast(score as INT) as score
from effective_care
where score not in ('Not Available', 'High (40,000 - 59,999 patients annually)', 
'Medium (20,000 - 39,999 patients annually)', 'Very High (60,000+ patients annually)', 'Low (0 - 19,999 patients annually)')
;

drop table if exists readmissions_clean;
Create table readmissions_clean as
select
provider_id,
hospital_name,
measure_id,
cast(score as INT) as score
from readmissions
where score not in ('Not Available')
;

drop table if exists procedures;
create table procedures as 
select * from effective_care_clean
UNION ALL
select * from readmissions_clean
;

drop table if exists procedures_avg;
create table procedures_avg as
select
provider_id,
hospital_name,
sum(score)/count(score) as score
from procedures
group by provider_id, hospital_name
;

-- Create provides - joining the entity hospitals and procedures
drop table if exists provides;
create table provides as 
select
h.provider_id as provider_id,
h.hospital_name as hospital_name,
h.state as state,
p.score as score
from hospitals as h
join procedures_avg as p
on h.provider_id = p.provider_id
--order by score DESC
;

drop table if exists surveys_responses_clean;
create table surveys_responses_clean as
select
provider_number as provider_id,
hospital_name,
cast(hcahps_base_score as INT) as survey_score
from surveys_responses
where hcahps_base_score not in ('Not Available')
;

-- Create About - joining the entity hospitals and survey
drop table if exists about;
create table about as
select 
p.provider_id as provider_id,
p.hospital_name as hospital_name,
p.score as score,
s.survey_score as survey_score
from provides as p
join surveys_responses_clean as s
on p.provider_id = s.provider_id
;