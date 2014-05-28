/**************************************************  
This report will return information about units  
and whether they have been defined for a service  
or not.  
**************************************************/  
  
CREATE procedure [dbo].[qp_rep_Sampleunitservice_old]
 @sampleunit_id int  
as  
select   
 AD,  
 css1.client_id,  
 css1.strclient_nm,  
 css1.study_id,   
 css1.strstudy_nm,  
 css1.survey_id,  
 css1.strsurvey_nm,  
 s.sampleunit_id,  
 s.strsampleunit_nm,  
 case  
  when ss.sampleunit_id is not null then 'Yes'  
  else 'No'  
 end as defined  
from sampleunit s left join  
 (select distinct sampleunit_Id  
  from sampleunitservice  
  where sampleunit_id>=@sampleunit_id) ss  
 on s.sampleunit_id=ss.sampleunit_id  
 join sampleplan sp  
 on s.sampleplan_id=sp.sampleplan_id  
 join (select distinct client_Id, strclient_nm, study_id, strstudy_nm, survey_id, strsurvey_nm   
   from clientstudysurvey_view) css1  
 on sp.survey_id=css1.survey_id  
 join datamart.qp_comments.dbo.sampleunit s2  
 on s.sampleunit_id=s2.sampleunit_id  
 join datamart.qp_comments.dbo.clientstudysurvey css  
 on s2.survey_id=css.survey_id  
where s.sampleunit_id>=@sampleunit_id and  
  css.client_id <> 443  
order by AD,  
 css1.client_id,  
 css1.strclient_nm,  
 css1.study_id,   
 css1.strstudy_nm,  
 css1.survey_id,  
 css1.strsurvey_nm,  
 s.sampleunit_id,  
 s.strsampleunit_nm


