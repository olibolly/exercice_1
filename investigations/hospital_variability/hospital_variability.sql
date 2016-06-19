-- Variability of procedures
select
m.measure_name as measure_name,
stddev_pop(score) as standard_deviation
--sum(power((score - sum(score)/count(score)), 2))/(count(score) - 1) as variance
from procedures as p
join measures as m
on m.measure_id = p.measure_id
group by measure_name
order by standard_deviation DESC
;