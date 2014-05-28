/***********************************************************************************************************************************
SP Name: sp_Rpt_ResponseRate
Version: 1.0.2
Part of:  Report Manager
Purpose:  Calculate the response rates for each sample unit of a given survey id
Input:  Survey_id
Output:  
Creation Date: 02/15/2000
Author(s): DS
Revision: Added outer join to account for surveys without outgo and/or returns
	04/24/2000 - DS - Added temp table for all sample unit ids of a study not just ones with outgo
	05/08/2000 - DS - Removed units with no target out of the equation and added error trapping for
		"divide by zero" errors.
***********************************************************************************************************************************/
CREATE PROCEDURE sp_rpt_ResponseRate
 @Survey_id INT
AS

select sampleunit_id, strsampleunit_nm 
into #units
from sampleunit su, sampleplan sp 
where su.sampleplan_id = sp.sampleplan_id 
and survey_id = @survey_id
and su.inttargetreturn > 0

select ss.sampleunit_id, count(*) as outgo
into #outgo
from selectedsample ss, sampleset sset, sampleunit su
where ss.sampleset_id = sset.sampleset_id
and sset.survey_id = @survey_id
and ss.strunitselecttype = 'D'
and ss.sampleunit_id = su.sampleunit_id
and su.inttargetreturn > 0
group by ss.sampleunit_id

select ss.sampleunit_id, count(distinct schm.samplepop_id) as undeliverable
into #undeliverable
from scheduledmailing schm, mailingstep ms, sentmailing sm, samplepop sp, selectedsample ss
where schm.mailingstep_id = ms.mailingstep_id
and schm.sentmail_id = sm.sentmail_id
and schm.samplepop_id = sp.samplepop_id
and sp.study_id = ss.study_id
and sp.pop_id = ss.pop_id
and sp.sampleset_id = ss.sampleset_id
and ss.strunitselecttype = 'D'
and sm.datundeliverable is not null
and ms.survey_id = @survey_id
and ss.sampleunit_id in(select sampleunit_id from #outgo)
group by ss.sampleunit_id

select ss.sampleunit_id, count(distinct schm.samplepop_id) as returned
into #returned
from scheduledmailing schm, mailingstep ms, sentmailing sm, samplepop sp, selectedsample ss, questionform qf
where schm.mailingstep_id = ms.mailingstep_id
and schm.sentmail_id = sm.sentmail_id
and schm.samplepop_id = sp.samplepop_id
and sp.study_id = ss.study_id
and sp.pop_id = ss.pop_id
and sp.sampleset_id = ss.sampleset_id
and sm.sentmail_id = qf.sentmail_id
and qf.datreturned is not null
and ss.strunitselecttype = 'D'
and ms.survey_id = @survey_id
and ss.sampleunit_id in(select sampleunit_id from #outgo)
group by ss.sampleunit_id

select u.sampleunit_id, strsampleunit_nm, isnull(outgo,0) as outgo
into #rpt1
from #units u left outer join #outgo o on u.sampleunit_id = o.sampleunit_id
order by u.sampleunit_id desc

select strsampleunit_nm as 'Sample Unit', outgo, isnull(undeliverable,0) as undeliverable, isnull(returned,0) as returned, 
'raw rr' = 
case when outgo = 0 
   then 0 
   else isnull(convert(decimal(5,2),convert(float,returned)/convert(float,outgo) * 100),convert(decimal(5,2),0)) 
end,
'adjusted rr' = 
case when outgo = 0
   then 0
   else isnull(convert(decimal(5,2),convert(float,returned)/convert(float,outgo-isnull(undeliverable,0)) * 100),convert(decimal(5,2),0)) 
end
from (#rpt1 r1 left outer join #undeliverable u on r1.sampleunit_id = u.sampleunit_id) left outer join #returned r on r1.sampleunit_id = r.sampleunit_id
order by r1.sampleunit_id desc


drop table #units
drop table #outgo
drop table #undeliverable
drop table #returned
drop table #rpt1


