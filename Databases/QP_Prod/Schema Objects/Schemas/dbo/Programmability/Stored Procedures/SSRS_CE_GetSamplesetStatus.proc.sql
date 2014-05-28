/***********************************************************************************
--Created by dknaus on 1/28/2008--



This procedure is used primarily for a Client Experience Reporting Services report
***********************************************************************************/
--exec ssrs_ce_getsamplesetstatus '3/1/2008','3/5/2008','C253'
CREATE procedure [dbo].[SSRS_CE_GetSamplesetStatus]
	@mindate datetime,@maxdate datetime,@selections varchar(8000)
as

declare @criteria varchar(8000),@sql varchar(8000),@selectiontype varchar(1)

set @maxdate=dateadd(ms,-3,dateadd(dd,1,@maxdate))

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

--build table with samplesets to be analyzed
create table #samplesets (client varchar(50),client_id int,study varchar(50),study_id int,
			              survey varchar(50),survey_id int,PM varchar(50),sampleset_id int)

if @selectiontype='P'
begin
set @sql=''
set @sql='insert #samplesets (Client,client_id,Study,study_id,Survey,survey_id,PM,Sampleset_id)'+char(10)+
'select distinct css.strclient_nm,css.client_id,css.strstudy_nm,s.study_id,css.strsurvey_nm,sd.survey_id,'+char(10)+
	'e.stremployee_first_nm+'' ''+e.stremployee_last_nm,ss.sampleset_id'+char(10)+
'from sampleset ss (nolock)'+char(10)+
    'inner join survey_def sd (nolock) on (sd.survey_id=ss.survey_id)'+char(10)+
	'inner join study s	(nolock) on (s.study_id=sd.study_id)'+char(10)+
	'inner join employee e (nolock) on (e.employee_id=s.ademployee_id)'+char(10)+
	'inner join (select distinct strclient_nm,client_id,strstudy_nm,study_id,strsurvey_nm,survey_id from clientstudysurvey_view) css on (css.survey_id=sd.survey_id)'+char(10)+
'where ss.datsamplecreate_dt between '''+convert(varchar,@mindate)+''' and '''+convert(varchar,@maxdate)+''' '+char(10)+
	'and '+@criteria

exec (@sql)
end

if @selectiontype='C'
begin
set @sql=''
set @sql='insert #samplesets (Client,client_id,Study,study_id,Survey,survey_id,PM,Sampleset_id)'+char(10)+
'select distinct css.strclient_nm,css.client_id,css.strstudy_nm,s.study_id,css.strsurvey_nm,sd.survey_id,'+char(10)+
	'e.stremployee_first_nm+'' ''+e.stremployee_last_nm,ss.sampleset_id'+char(10)+
'from sampleset ss (nolock) '+char(10)+
    'inner join survey_def sd (nolock) on (sd.survey_id=ss.survey_id)'+char(10)+
	'inner join study s	(nolock) on (s.study_id=sd.study_id)'+char(10)+
	'inner join employee e (nolock) on (e.employee_id=s.ademployee_id)'+char(10)+
	'inner join (select distinct strclient_nm,client_id,strstudy_nm,study_id,strsurvey_nm,survey_id from clientstudysurvey_view) css on (css.survey_id=sd.survey_id)'+char(10)+
'where ss.datsamplecreate_dt between '''+convert(varchar,@mindate)+''' and '''+convert(varchar,@maxdate)+''' '+char(10)+
	'and '+@criteria

exec (@sql)
end

select ss.client,ss.client_id,ss.study,ss.study_id,ss.survey,ss.survey_id,ss.pm,ss.sampleset_id,spw.sampleunit_id,spw.strsampleunit_nm,
	case when intOutgoNeededNow < 0 then 0 else intOutgoNeededNow end [OutgoNeeded],
	coalesce(intIndirectSampledNow,0) [IndirectSample],
	coalesce(intSampledNow,0) [Sampled],
	case when intShortfall < 0 or intOutgoNeededNow <0 then 0 when intshortfall is null then intOutgoNeededNow-0 else intshortfall end [Difference]
from #samplesets ss
	left outer join sampleplanworksheet spw (nolock)
		on (ss.sampleset_id=spw.sampleset_id)
order by ss.client,ss.study,ss.survey

/*
select ss.client,ss.study,ss.survey,
	sum(case when intOutgoNeededNow < 0 then 0 else intOutgoNeededNow end) [OutgoNeeded],
	--sum(coalesce(intIndirectSampledNow,0)) [IndirectSample],
	sum(coalesce(intSampledNow,0)) [Sampled],
	sum(case when intShortfall < 0 or intOutgoNeededNow <0 then 0 when intshortfall is null then intOutgoNeededNow-0 else intshortfall end) [Difference]
from #samplesets ss
	left outer join sampleplanworksheet spw (nolock)
		on (ss.sampleset_id=spw.sampleset_id)
group by ss.client,ss.study,ss.survey
order by ss.client,ss.study,ss.survey

*/

drop table #samplesets
/***********************************************************************************
***********************************************************************************/


