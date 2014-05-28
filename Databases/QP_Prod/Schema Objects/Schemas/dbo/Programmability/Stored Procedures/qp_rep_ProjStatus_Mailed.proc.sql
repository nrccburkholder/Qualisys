CREATE procedure dbo.qp_rep_ProjStatus_Mailed
 @Associate varchar(50),
 @Client varchar(50),
 @Study varchar(50),
 @ActivitySince datetime
AS
--select @associate= 'dgilsdorf', @client= 'Nebraska Methodist Hospital', @study= 'NMHS', @ActivitySince='10/1/03'
--select @Associate='Dgilsdorf', @Client='Baptist Healthcare System', @Study='IP/OP/ER', @ActivitySince='12/10/03'

select distinct css.survey_id,sampleset_id,css.strstudy_nm, css.STRSURVEY_nm, ss.datsampleCreate_dt as [Sampled On], 
convert(varchar,ss.datDateRange_FromDate,101)+' - '+convert(varchar,ss.datDateRange_ToDate,101) as [Date Range],
0 as SampledCnt
into #samples
from clientstudysurvey_view css, sampleset ss
where css.strclient_nm=@Client
  and css.strstudy_nm=case when @study='_ALL' then css.strStudy_nm else @Study end
  and css.survey_id=ss.survey_id
  and ss.datSampleCreate_dt > dateadd(week,-6,@ActivitySince)
  and ss.web_extract_flg is not null
order by ss.datsamplecreate_dt

create index tempSamples on #samples (sampleset_id)

update #samples
set SampledCnt=sub.sampledcnt
from (select sampleset_id,count(*) as Sampledcnt from samplepop group by sampleset_id) sub
where #samples.sampleset_id=sub.sampleset_id

select s.sampleset_id, left(ms.strMailingStep_nm,charindex('(',ms.strMailingStep_nm+'(')-1)+ space(5) as strMailingStep_nm, isnull(max(datmailed),'4172-12-30') as LastMail, count(*) as MailedCnt
into #mailings
	from #samples s, samplepop sp, scheduledmailing scm, sentmailing sm, mailingstep ms
	where s.sampleset_id=sp.sampleset_id
	and sp.samplepop_id=scm.samplepop_id
	and scm.sentmail_id=sm.sentmail_id
	and scm.mailingstep_id=ms.mailingstep_id
	and scm.overrideitem_id is null
	group by s.sampleset_id, ms.mailingstep_id, left(ms.strMailingStep_nm,charindex('(',ms.strMailingStep_nm+'(')-1)+ space(5)
	having isnull(max(datmailed),getdate())>=@ActivitySince
order by s.sampleset_id, ms.mailingstep_id

/*
update #samples
set MailedCnt=sub.MailedCnt, LastMail=sub.LastMail
from (	select sp.sampleset_id, max(datMailed) as LastMail, count(*) as MailedCnt
	from samplepop sp, scheduledmailing scm, sentmailing sm, mailingstep ms, #samples s
	where sp.samplepop_id=scm.samplepop_id
	and scm.sentmail_id=sm.sentmail_id
	and scm.mailingstep_id=ms.mailingstep_id
	and sp.sampleset_id=s.sampleset_id
	and ms.bitfirstsurvey=1
	group by sp.sampleset_id, ms.mailingstep_id, ms.strMailingStep_nm ) sub
where #samples.sampleset_id=sub.sampleset_id*/

insert into #mailings
	select sp.sampleset_id, '{'+rtrim(left(ms.strMailingStep_nm,charindex('(',ms.strMailingStep_nm+'(')-1))+'}', min(datGenerate), count(*)
	from #samples s, samplepop sp, scheduledmailing scm, mailingstep ms
	where s.sampleset_id=sp.sampleset_id
	and sp.samplepop_id=scm.samplepop_id
	and scm.sentmail_id is null
	and scm.mailingstep_id=ms.mailingstep_id
	group by sp.sampleset_id, '{'+rtrim(left(ms.strMailingStep_nm,charindex('(',ms.strMailingStep_nm+'(')-1))+'}'

/*
update #samples
set strMailingStep_nm=sub.strMailingStep_nm
from (	select sp.sampleset_id, ms.STRMAILINGSTEP_NM, min(datGenerate) as datGenerate, count(*) as nextCnt
	from #samples s, samplepop sp, scheduledmailing scm, mailingstep ms
	where s.sampleset_id=sp.sampleset_id
	and sp.samplepop_id=scm.samplepop_id
	and scm.sentmail_id is null
	and scm.mailingstep_id=ms.mailingstep_id
	group by sp.sampleset_id, ms.STRMAILINGSTEP_NM) sub
where #samples.sampleset_id=sub.sampleset_id
*/

create table #results (result_id int identity(1,1), Survey varchar(25), SampledOn varchar(30), DateRange varchar(63),
SampledCnt int, strMailingStep_nm varchar(35), MailDate varchar(30), MailCnt int, sampleset_id int)

insert into #results (Survey, SampledOn, DateRange, SampledCnt, strMailingStep_nm, MailDate, MailCnt, sampleset_id)
select 	rtrim(strStudy_nm)+' - '+strSurvey_nm, 
	convert(varchar,[Sampled On],101), 
	[Date Range], 
	SampledCnt, 
	rtrim(m.strMailingStep_nm),
	case when m.lastmail='4172-12-31' then 'unscheduled' when m.lastmail='4172-12-30' then 'in process' else convert(varchar,m.LastMail,101) end, 
	m.MailedCnt,
	s.sampleset_id
from #samples s left outer join #mailings m on s.sampleset_id=m.sampleset_id
where [Sampled On]>=@ActivitySince 
or m.LastMail>=@ActivitySince 
order by s.strStudy_nm, s.strSurvey_nm, s.SampleSet_id, isnull(m.lastmail,getdate())

update r
set survey=null, sampledon=null, daterange=null, sampledcnt=null
from #results r, (select sampleset_id, min(result_id) as result_id from #results group by sampleset_id) sub
where r.sampleset_id=sub.sampleset_id
and r.result_id <> sub.result_id

declare @SQL varchar(8000)
set @SQL = 
'select Survey as [Surveys mailed since '+left(convert(varchar, @ActivitySince, 7),6)+'], SampledOn as [Sampled On], DateRange as [Date Range], 
dbo.AddComma(SampledCnt) as [# Sampled], strMailingStep_nm as [Completed Step {Scheduled Step}], MailDate as [Mailed On], dbo.AddComma(MailCnt) as [# Pieces]
from #results
order by result_id'

exec (@SQL)

drop table #samples
drop table #mailings
drop table #results


