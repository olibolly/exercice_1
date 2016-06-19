-- States being models of high-quality care
select
state,
sum(score)/count(score) as score
from provides
group by state
order by score DESC
;