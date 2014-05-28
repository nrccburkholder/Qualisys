create procedure sp_Norms_HealthSouth
as

create table #nrcnorms (qstncore int, intresponseval int, UWNsize int, wNsize float)

insert into #nrcnorms
select qstncore, intresponseval,sum(NSize),sum(nsize)
from nrcnorms12312001 n left outer join (select su.sampleunit_id from sampleunit su, sampleplan sp, survey_def sd, study s
					where su.sampleplan_id = sp.sampleplan_id
					and sp.survey_id = sd.survey_id
					and sd.study_id = s.study_id
					and s.client_id = 113) hs 
					on n.sampleunit_id = hs.sampleunit_id
where hs.sampleunit_id is null
and bitmissing = 0
group by qstncore, intresponseval

insert into #nrcnorms
select qstncore, response, sum(uwNSize), sum(wNSize)
from HCMGNorm N, HCMGQuestionEquivalent QE
where N.HCMGYear=QE.HCMGYear and N.HCMGQNmbr=QE.HCMGQNmbr 
group by qstncore, response

select qstncore,intresponseval,sum(uwNSize) as uwNSize, sum(wNSize) as wNSize
into #all
from #nrcnorms
group by qstncore,intresponseval

drop table #nrcnorms

select count(*) from #all


