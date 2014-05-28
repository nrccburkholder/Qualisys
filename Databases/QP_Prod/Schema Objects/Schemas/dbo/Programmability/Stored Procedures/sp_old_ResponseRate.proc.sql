/***********************************************************************************************************************************
SP Name: sp_Rpt_ResponseRate
Version: 1.0.1
Part of:  Report Manager
Purpose:  Calculate the response rates for each sample unit of a given survey id
Input:  Survey_id
Output:  
Creation Date: 02/15/2000
Author(s): DS
Revision: Added outer join to account for surveys without outgo and/or returns
***********************************************************************************************************************************/
CREATE PROCEDURE [dbo].[sp_old_ResponseRate]
 @Survey_id INT
AS

select ss.sampleunit_id, su.strsampleunit_nm, count(distinct schm.samplepop_id) as outgo 
into #outgo
from scheduledmailing schm, mailingstep ms, sentmailing sm, samplepop sp, selectedsample ss, sampleunit su
where schm.mailingstep_id = ms.mailingstep_id
and schm.sentmail_id = sm.sentmail_id
and schm.samplepop_id = sp.samplepop_id
and sp.study_id = ss.study_id
and sp.pop_id = ss.pop_id
and ss.sampleunit_id = su.sampleunit_id
and sm.datmailed is not null
and ms.intsequence = 1
and ms.survey_id = @survey_id
group by ss.sampleunit_id, su.strsampleunit_nm

select ss.sampleunit_id, count(distinct schm.samplepop_id) as undeliverable
into #undeliverable
from scheduledmailing schm, mailingstep ms, sentmailing sm, samplepop sp, selectedsample ss
where schm.mailingstep_id = ms.mailingstep_id
and schm.sentmail_id = sm.sentmail_id
and schm.samplepop_id = sp.samplepop_id
and sp.study_id = ss.study_id
and sp.pop_id = ss.pop_id
and sm.datundeliverable is not null
and ms.survey_id = @survey_id
group by ss.sampleunit_id

select ss.sampleunit_id, count(distinct schm.samplepop_id) as returned
into #returned
from scheduledmailing schm, mailingstep ms, sentmailing sm, samplepop sp, selectedsample ss, questionform qf
where schm.mailingstep_id = ms.mailingstep_id
and schm.sentmail_id = sm.sentmail_id
and schm.samplepop_id = sp.samplepop_id
and sp.study_id = ss.study_id
and sp.pop_id = ss.pop_id
and sm.sentmail_id = qf.sentmail_id
and qf.datreturned is not null
and ms.survey_id = @survey_id
group by ss.sampleunit_id

select strsampleunit_nm as 'Sample Unit', isnull(outgo,0) as outgo, isnull(undeliverable,0) as undeliverable, isnull(returned,0) as returned, 
isnull(convert(decimal(5,2),convert(float,returned)/convert(float,outgo) * 100),convert(decimal(5,2),0)) as 'raw rr', 
isnull(convert(decimal(5,2),convert(float,returned)/convert(float,outgo-isnull(undeliverable,0)) * 100),convert(decimal(5,2),0)) as 'adjusted rr'
from (#outgo o left outer join #undeliverable u on o.sampleunit_id = u.sampleunit_id) left outer join #returned r on o.sampleunit_id = r.sampleunit_id
order by r.sampleunit_id desc

drop table #outgo
drop table #undeliverable
drop table #returned


