create table #order (qstncore int, val int, rankOrder int,
		PRIMARY KEY (qstncore, val))

--Create a current rankings lookup table
select q.qstncore, q.label as report_text, s.val, s.label as response_label, scaleorder
into #currentRankings
from (select q.qstncore, q.label, q.survey_id, scaleid
		from questions q, (select q.qstncore, max(q.survey_id) as survey_id 
							from questions q join scales s
								on q.survey_id=s.survey_id
									and q.scaleid=s.scaleid
									--and s.scaleorder is not null
							where q.language=1
							group by q.qstncore) m
		where q.qstncore=m.qstncore 
			and q.survey_id=m.survey_id) q, scales s
where q.scaleid=s.scaleid
	and q.survey_id=s.survey_id
	and s.val <> -10

--create a problem score lookup table
select *
into #lu_problem_score
from lu_problem_score 

--Delete invalid question response values;  
delete #lu_problem_score
from #lu_problem_score ps left join #currentRankings cr
	on ps.qstncore=cr.qstncore
		and ps.val=cr.val
where cr.val is null and
	ps.qstncore in (select qstncore from #currentRankings)--Don't delete data for questions that don't exist on a survey

select ps.*, c.responsecount,
	case 
		when problem_score_flag=1 then 'Worst to Best'
		else 'Best to Worst' 
	end as ordering
into #OrderDirection
from #lu_problem_score ps,
	(select qstncore, min(val) as val
		from #lu_problem_score
		where problem_score_flag in (0,1)
		group by qstncore) m,
	(select qstncore, count(*) as responsecount
		from #lu_problem_score
		where problem_score_flag in (0,1)
		group by qstncore) c
where ps.qstncore=m.qstncore
	and ps.val=m.val
	and ps.qstncore=c.qstncore

--this join ensures that there are no gaps in the ordering
insert into #order
select ps.qstncore, ps.val, count(*) as rankOrder
from #lu_problem_score ps, #lu_problem_score ps2
where ps.qstncore=ps2.qstncore
	and ps.problem_score_flag in (0,1)
	and ps2.problem_score_flag in (0,1)
	and ps.val>=ps2.val
group by ps.qstncore, ps.val
order by 1,2

create index qstncore on #order (qstncore)

update #order
set rankOrder=responsecount-rankOrder+1
from #order o, #OrderDirection od
where o.qstncore=od.qstncore
	and ordering='Worst to Best'


--Insert undefined questions; Make sure all responses are marked as undefined since some questions exist in the problem
--score table with only a few response marked as undefined
select distinct qstncore
into #undefinedCores
from #lu_problem_score
where problem_score_flag =-1 
	and qstncore not in (select qstncore from #lu_problem_score where problem_score_flag <>-1)

insert into #order
select qstncore, val,-1
from (select q.qstncore, q.survey_id, scaleid
		from questions q, (select q.qstncore, max(q.survey_id) as survey_id 
							from questions q join scales s
								on q.survey_id=s.survey_id
									and q.scaleid=s.scaleid
									and s.scaleorder is not null
								join (select distinct qstncore
											from #undefinedCores) o
								on q.qstncore=o.qstncore
							where q.language=1
							group by q.qstncore) m
		where q.qstncore=m.qstncore 
			and q.survey_id=m.survey_id) q, scales s
where q.scaleid=s.scaleid
	and q.survey_id=s.survey_id
	and s.val<>-10


--Insert N/As
insert into #order
select qstncore, val, -9
from #lu_problem_score
where problem_score_flag in (9, -1)
	and qstncore not in (select qstncore from #undefinedCores) --ensures we don't add questions that were all -1s

--get remaining unmapped questions 
select q.qstncore, q.survey_id, q.scaleid, s.val, 
	case 
		when bitmissing=1 then null
		else s.scaleorder
	end as scaleorder
into #unmapped
from (select q.qstncore, q.survey_id, scaleid
		from questions q, (select q.qstncore, max(q.survey_id) as survey_id 
							from questions q join scales s
								on q.survey_id=s.survey_id
									and q.scaleid=s.scaleid
									--and s.scaleorder is not null
								left join (select distinct qstncore
											from #order) o
								on q.qstncore=o.qstncore
							where o.qstncore is null 
								and q.language=1
							group by q.qstncore) m
		where q.qstncore=m.qstncore 
			and q.survey_id=m.survey_id) q, scales s
where q.scaleid=s.scaleid
	and q.survey_id=s.survey_id
	and s.val <>-10

--this join ensures that there are no gaps in the ordering
select um.qstncore, um.scaleid, um.val, count(*) as rankOrder
into #unmappedOrdered
from #unmapped um, #unmapped um2
where um.qstncore=um2.qstncore
	and um.scaleorder>=um2.scaleorder
group by um.qstncore, um.scaleid, um.val
order by 1,2

--update scales that are listed as needing to be reversed
update o
set rankOrder=responsecount-rankOrder+1
from #unmappedOrdered o, 
		(select qstncore, max(rankOrder) as responsecount
			from #unmappedOrdered
			group by qstncore) o2, lu_reversescaleorder r
where o.scaleid=r.scaleid
	and o.qstncore=o2.qstncore

--update excellent to poor scales to make sure they are all consistent
update o
set rankOrder=case
				when label='Poor' then 5
				when label='Fair' then 4
				when label='Good' then 3
				when label='Very Good' then 2
				when label='Excellent' then 1
				else null
			  end
from #unmappedOrdered o, 
		--Find all of the excellent to poor questions
		(select distinct q.qstncore, q.survey_id, q.scaleid
			from #unmapped q, scales s
			where q.survey_id=s.survey_id
				and q.scaleid=s.scaleid
				and q.val=s.val
				and label='Excellent') q,
		 scales s
where o.qstncore=q.qstncore
	and q.scaleid=s.scaleid
	and q.survey_id=s.survey_id
	and o.val=s.val

insert into #order
select qstncore, val, rankOrder
from #unmappedOrdered

--Add all of the scaleorders that were null and didn't get added to the #unmappedOrdered table
insert into #order
select u.qstncore, u.val, -9
from #unmapped u left join #unmappedOrdered uo
	on u.qstncore=uo.qstncore
		and u.val=uo.val
where uo.qstncore is null

--Responses not in the problem score table that need a rank of N/A assigned
insert into #order
select q.qstncore, q.val, -9
from #order o full join #currentRankings q
	on o.qstncore=q.qstncore
		and o.val=q.val
where o.qstncore is null

--Set all -9s to -1s now
update #order
set rankorder=-1
where rankorder=-9

--Update all multiple response questions to N/A
update #order
set rankOrder=-1
from #order o, Questions q, 
		(select q.qstncore, max(q.survey_id) as survey_id 
		from questions q join scales s
			on q.survey_id=s.survey_id
				and q.scaleid=s.scaleid
				--and s.scaleorder is not null
		where q.language=1
		group by q.qstncore) m
where o.qstncore=q.qstncore
	and q.qstncore=m.qstncore
	and q.survey_id=m.survey_id
	and q.nummarkcount>1

truncate table ResponseRankOrder

insert into ResponseRankOrder (qstncore, val, rankOrder)
select *
from #order
order by 1,2
