CREATE procedure [dbo].[SSRS_CE_GetSurveyTracking_notused] @mindate datetime,@maxdate datetime,@selections varchar(8000)
as

declare @selectiontype varchar(10),@criteria varchar(8000),@sql varchar(8000),@intdategap int


--subtract 3 milliseconds from the next day so that it uses the date correctly in the date range
set @maxdate=dateadd(ms,-3,dateadd(dd,1,@maxdate))

--set number of days in date range for report
set @intdategap=datediff(dd,dateadd(dd,-1,@mindate),@maxdate)

--look at parameters from SSRS to see if it should be listed by PM or client
--build criteria based on that
if left(@selections,1)='P'
begin
set @selectiontype='P'
set @selections=replace(@selections,'P','')
set @criteria='e.employee_id in ('+@selections+')'
end

if left(@selections,1)='C'
begin
set @selectiontype='C'
set @selections=replace(@selections,'C','')
set @criteria='css.client_id in ('+@selections+')'
end

--create temp table with surveys with expected samples within the date range
create table #PeriodSampleInfo (survey_id int,[Expected Samples] int,[Completed Samples] int,[Remaining Samples] int)
	create clustered index idx_clustered_surveyid on #PeriodSampleInfo (survey_id)

--create temp table with survey_id and the next scheduled sample date
create table #NextSamplesPeriod (survey_id int,perioddef_id int,datNextSample datetime,[Period Name] varchar(100),[Sampling Freq] varchar(20),dk_ExpSamps float)
	create clustered index idx_clustered_surveyid on #NextSamplesPeriod (survey_id)

--create temp table to store actual sample information
create table #samples (survey_id int,[Total Samples] int,[Samples Rolled Back] int,[Samples Scheduled] int)
	create clustered index idx_clustered_surveyid on #samples  (survey_id)

--create temp table to store actual sample information
create table #datafiles (study_id int,total int,applied int,unapproved int,rolledback int,drgupdate int,abandoned int)
	create clustered index idx_clustered_studyid on #datafiles (study_id)

--create temp table to store actual sample information
create table #mailed (survey_id int,samplesmailed int,firstsmailed int)
	create clustered index idx_clustered_studyid on #mailed (survey_id)

--populate #PeriodSampleInfo
insert #PeriodSampleInfo (survey_id,[Expected Samples],[Completed Samples],[Remaining Samples])
select e.survey_id,
	e.[Expected Samples],
	isnull(a.[Conducted Samples],0),
	case when isnull(e.[Expected Samples],0)-isnull(a.[Conducted Samples],0)<0 then 0 
		else isnull(e.[Expected Samples],0)-isnull(a.[Conducted Samples],0) end
from (
select survey_id,sum(case when datscheduledsample_dt is null then 0 else 1 end) [Expected Samples]
from perioddef p (nolock)
	right outer join perioddates pd (nolock)
		on (p.perioddef_id=pd.perioddef_id)
where (datscheduledsample_dt between @mindate and @maxdate or datscheduledsample_dt is null)
group by survey_id) e
	left outer join 
	(select survey_id,sum(case when datsamplecreate_dt is null then 0 else 1 end) [Conducted Samples]
	from perioddef p (nolock)
	right outer join perioddates pd (nolock)
		on (p.perioddef_id=pd.perioddef_id)
	where datsamplecreate_dt between @mindate and @maxdate
	group by survey_id) a
		on (e.survey_id=a.survey_id)
where a.survey_id is not null

--populate #NextSamplesPeriod
insert #NextSamplesPeriod(survey_id,perioddef_id,p.datNextSample)
select p.survey_id,min(p.perioddef_id),min(pd.datscheduledsample_dt)
from perioddef p (nolock)
	right outer join perioddates pd (nolock)
		on (p.perioddef_id=pd.perioddef_id)
where p.survey_id in (select survey_id from #PeriodSampleInfo)
	and pd.datsamplecreate_dt is null
	--another date will go here
group by p.survey_id

--update period information
update nsp
set [Period Name]=p.strPerioddef_nm,
	 [Sampling Freq]=
		case 
		when (datediff(dd,p.datExpectedEncStart,p.datExpectedEncEnd)/(p.intexpectedsamples*1.0)) between 0 and 1.5 then 'Daily'
		when (datediff(dd,p.datExpectedEncStart,p.datExpectedEncEnd)/(p.intexpectedsamples*1.0)) between 6 and 8 then 'Weekly'
		when (datediff(dd,p.datExpectedEncStart,p.datExpectedEncEnd)/(p.intexpectedsamples*1.0)) between 12 and 16 then 'Bi-Monthly'
		when (datediff(dd,p.datExpectedEncStart,p.datExpectedEncEnd)/(p.intexpectedsamples*1.0)) between 26 and 33 then 'Monthly'
		when (datediff(dd,p.datExpectedEncStart,p.datExpectedEncEnd)/(p.intexpectedsamples*1.0)) between 85 and 95 then 'Quarterly'
		when (datediff(dd,p.datExpectedEncStart,p.datExpectedEncEnd)/(p.intexpectedsamples*1.0)) is null then 'Unknown'
		else 'Undefined'
		end,
	[dk_ExpSamps]=round(@intdategap/(datediff(dd,p.datExpectedEncStart,p.datExpectedEncEnd)/(p.intexpectedsamples*1.0)),0)
from #NextSamplesPeriod nsp
	inner join Perioddef p
		on (nsp.perioddef_id=p.perioddef_id)
where datediff(dd,p.datExpectedEncStart,p.datExpectedEncEnd)/(p.intexpectedsamples*1.0)<>0

--find sample/schedule information
insert #samples (survey_id,[Total Samples],[Samples Rolled Back],[Samples Scheduled])
select s.survey_id, s.samples+isnull(r.rollbacks,0),isnull(r.rollbacks,0), sch.Scheduled
from 
	(select survey_id,
		sum(case when sampleset_id is null then 0 else 1 end) as Samples
	from sampleset
	where datsamplecreate_dt between @mindate and @maxdate
	group by survey_id) s
	left outer join 
	(select survey_id,
		sum(case when datsamplecreate_dt is null then 0 else 1 end) as Rollbacks
	from rollbacks
	where datsamplecreate_dt between @mindate and @maxdate
	group by survey_id) r
		on s.survey_id=r.survey_id
	left outer join
	(select survey_id,
	sum(case when datscheduled is null then 0 else 1 end) as Scheduled
	from sampleset
	where datsamplecreate_dt between @mindate and @maxdate
	group by survey_id) sch
		on s.survey_id=sch.survey_id

--find sent information
insert #mailed (survey_id,samplesmailed,firstsmailed)
select ms.survey_id,
	sum(case when ms.sampleset_id is null then 0 else 1 end),
	sum(ms.mailcount)
from mailingsummary ms
	inner join mailingstep mst
		on (ms.survey_id=mst.survey_id and ms.mailingstep_id=mst.mailingstep_id)
where ms.datmailed between @mindate and @maxdate
	and mst.intsequence=1
group by ms.survey_id


/************************************************************************************
Begin get datafile information
************************************************************************************/
/*
insert #datafiles (study_id,total,applied,unapproved,rolledback,drgupdate,abandoned)
select p.study_id,
	sum(case when df.datafile_id is null then 0 else 1 end),
	sum(case when dfs.state_id=10 then 1 else 0 end),
	sum(case when dfs.state_id in (6,7) then 1 else 0 end),
	sum(case when dfs.state_id=12 then 1 else 0 end),
	sum(case when dfs.state_id=14 then 1 else 0 end),
	sum(case when dfs.state_id=11 then 1 else 0 end)	
from [qloader].[QP_Load].[dbo].[datafile] df
	right outer join [qloader].[QP_Load].[dbo].package p
		on (df.package_id=p.package_id)
	right outer join [qloader].[QP_Load].[dbo].datafilestate dfs
		on (df.datafile_id=dfs.datafile_id)
where df.datReceived between @mindate and @maxdate
group by p.study_id
/************************************************************************************
End get datafile information
************************************************************************************/
*/

--build results
set @sql=''
set @sql=
'select  e.strntlogin_nm [PM],'+char(10)+
	'	css.strclient_nm [Client],css.client_id,css.strstudy_nm [Study],css.study_id,css.strSurvey_nm [Survey],css.survey_id,'+char(10)+
	'	isnull(df.total,0) [Total Files],isnull(df.applied,0) [Files Applied],isnull(df.unapproved,0) [Files Unapproved],'+char(10)+
	'	isnull(df.rolledback,0) [Files Rolled Back],isnull(df.drgupdate,0) [Files DRG Update],'+char(10)+
	'	isnull(df.abandoned,0) [Files Abandoned],'+char(10)+
	'	psi.[Expected Samples],psi.[Completed Samples],psi.[Remaining Samples],'+char(10)+
	'	nsp.perioddef_id,nsp.datNextSample [Next Sample Date],nsp.[Period Name],nsp.[Sampling Freq],'+char(10)+
	'	nsp.dk_ExpSamps [Period Expected Samples],'+char(10)+
	'	s.[Total Samples],s.[Samples Rolled Back],s.[Samples Scheduled],'+char(10)+
	'	isnull(m.samplesmailed,0) [Samples Mailed],'+char(10)+
	'	isnull(m.firstsmailed,0) [Firsts Mailed]'+char(10)+
'from (select distinct strclient_nm,client_id,strstudy_nm,study_id,strsurvey_nm,survey_id from clientstudysurvey_view) css'+char(10)+
	'right outer join #PeriodSampleInfo psi'+char(10)+
	'	on (css.survey_id=psi.survey_id)'+char(10)+
	'right outer join #NextSamplesPeriod nsp'+char(10)+
	'	on (css.survey_id=nsp.survey_id)'+char(10)+
	'left outer join #samples s'+char(10)+
	'	on (css.survey_id=s.survey_id)'+char(10)+
	'left outer join #mailed m'+char(10)+
	'	on (css.survey_id=m.survey_id)'+char(10)+
	'left outer join #datafiles df'+char(10)+
	'	on (css.study_id=df.study_id)'+char(10)+
	'inner join study st'+char(10)+
	'	on (css.study_id=st.study_id)'+char(10)+
	'		inner join employee e'+char(10)+
	'			on (st.ademployee_id=e.employee_id)'+char(10)+
	'where '+@criteria+char(10)+
'order by [Client],[Study],[Survey]'
--print @sql
exec (@sql)

/***/--select '' PeriodSampleInfo,* from #PeriodSampleInfo order by survey_id
/***/--select '' nextsamplesperiod,* from #NextSamplesPeriod order by survey_id
/***/--select '' samples,* from #samples order by survey_id
/***/--select * from #datafiles

drop table #PeriodSampleInfo
drop table #NextSamplesPeriod
drop table #samples
drop table #datafiles
drop table #mailed


