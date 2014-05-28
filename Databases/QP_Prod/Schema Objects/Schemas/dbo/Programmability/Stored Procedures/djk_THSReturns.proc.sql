--exec djk_THSReturns '6666'  
  
CREATE procedure [dbo].[djk_THSReturns]  
 @project varchar(4)  
  
as  
  
declare @mindate datetime,@maxdate datetime  
  
set @mindate='1/1/2008'  
set @maxdate='3/31/2008 23:59:59.997'  
  
--set the project number here  
--set @project='A197'  
  
declare @ss table (study_id int,survey_id int)  
  
insert @ss (study_id,survey_id)  
select distinct study_id,survey_id  
from css_view   
where left(strSurvey_nm,4)=@project  
  
declare @returns table (survey_id int,sampleunit_id int,Returns int)  
  
insert @returns (survey_id,sampleunit_id,Returns)  
select survey_id,ses.sampleunit_id,count(*)  
from selectedsample ses (nolock)  
 inner join samplepop sp (nolock)  
  on (sp.sampleset_id=ses.sampleset_id and sp.study_id=ses.study_id and sp.pop_id=ses.pop_id)  
 inner join questionform qf (nolock)  
  on (qf.samplepop_id=sp.samplepop_id)  
where qf.datreturned between @mindate and @maxdate  
 and sp.study_id in (select study_id from @ss)  
 and qf.survey_id in (select survey_id from @ss)  
 and ses.sampleencounterdate>'1/1/2008'  
group by qf.survey_id,ses.sampleunit_id  
  
--/***/select * from @returns order by sampleunit_id  
  
select left(css.strSurvey_nm,4) Project,su.strSampleunit_nm,sum(r.Returns)  
from css_view css  
 inner join @returns r  
  on (css.survey_id=r.survey_id)  
 inner join sampleunit su  
  on (r.sampleunit_id=su.sampleunit_id)  
group by left(css.strSurvey_nm,4),su.strSampleunit_nm  
order by left(css.strSurvey_nm,4),su.strSampleunit_nm  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
--/***/select * from @ss  
  
/*  
select ses.selectedsample_id,ses.sampleunit_id,qf.questionform_id,qf.datreturned,  
  qf.survey_id,sp.samplepop_id,ses.sampleset_id,ses.study_id,  
  ses.pop_id,ses.enc_id,ses.reportdate,ses.sampleencounterdate  
from selectedsample ses  
 inner join samplepop sp  
  on (sp.sampleset_id=ses.sampleset_id and sp.study_id=ses.study_id and sp.pop_id=ses.pop_id)  
 inner join questionform qf (nolock)  
  on (qf.samplepop_id=sp.samplepop_id)  
where qf.datreturned between @mindate and @maxdate  
 and sp.study_id in (select study_id from #ss)  
 and qf.survey_id in (select survey_id from #ss)  
 and ses.sampleencounterdate>'1/1/2008'  
order by sp.samplepop_id  
*/


