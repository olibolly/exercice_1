-- Variability of procedures
drop table if exists hospital_variability;
create table hospital_variability as
select
m.measure_name as measure_name,
stddev_pop(score) as standard_deviation
from procedures as p
join measures as m
on m.measure_id = p.measure_id
group by measure_name
order by standard_deviation DESC
;

select measure_name, standard_deviation from hospital_variability limit 10;