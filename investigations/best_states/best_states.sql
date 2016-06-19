-- States being models of high-quality care
drop table if exists best_states;
create table best_states as
select
state,
sum(score)/count(score) as score
from provides
group by state
order by score DESC
;

select state, score from best_states limit 10;