/************************************************************************************  
This procedure populates tables that are used to provide information about what   
services we are sampling for for each unit and facility.  
**************************************************************************************/  
  
CREATE procedure SP_PopulateServiceTables   
as  
  
--This table will contain a list of problem score questions  
create table #pScorequestions (qstncore int)  
  
--Questions with core numbers lower than 8000 are legacy questions  
insert into #pScorequestions  
select distinct qstncore  
from DATAMART.qp_comments.dbo.lu_problem_score  
where qstncore >8000 and  
 problem_score_flag in (0,1)  
  
create index qstncore on #pScorequestions (qstncore)  
  
  
select survey_id, count(distinct q2.qstncore) as questioncount  
into #pickerSurveys  
from #pScorequestions q1, DATAMART.qp_comments.dbo.questions q2  
where q1.qstncore=q2.qstncore  
group by survey_id  
having count(distinct q2.qstncore) >=10  
  
insert into #pickersurveys  
select survey_id, 0  
from survey_def  
where survey_id not in   
 (select survey_id  
  from #pickersurveys)  
  
create table #services (service_id int, service_name varchar(84))  
  
insert into #services (service_id, service_name)  
 select service_id, rtrim(strservice_nm) + ' - Overall'   
 from service  
 where parentservice_id is null  
  
insert into #services  
 select s2.service_id, rtrim(s1.strservice_nm) + ' - ' + s2.strservice_nm  
 from service s1, service s2  
 where s2.parentservice_id=s1.service_id   
  
select u.*  
into #unitselecttype  
from DATAMART.qp_comments.dbo.unitselecttype u,   
 (select sampleunit_id, max(datsamplecreate_dt) as datsamplecreate_dt  
 from DATAMART.qp_comments.dbo.unitselecttype  
 group by sampleunit_id) d  
where u.sampleunit_id=d.sampleunit_id and  
 u.datsamplecreate_dt=d.datsamplecreate_dt and  
 d.datsamplecreate_dt>=dateadd(yy,-3,getdate())  
   
if exists (select 'x' from sysobjects where name = 'Norms_UnitsbyService')
begin  
	drop table Norms_UnitsbyService 
end
 
select distinct css.client_id,  
   rtrim(css.strclient_nm) + ' (' + convert(varchar,css.client_id) + ')' as client,   
   css.study_id,  
   rtrim(css.strstudy_nm) + ' (' + convert(varchar,css.study_id) + ')' as study,   
   css.survey_Id,  
   rtrim(css.strsurvey_nm) + ' (' + convert(varchar,css.survey_id) + ')' as survey,   
   s.sampleunit_Id,  
   rtrim(s.strsampleunit_nm) + ' (' + convert(varchar,s.sampleunit_id) + ')' as unit,   
   case  
   when substring(css.strsurvey_nm,5,1)<'a' then substring(css.strsurvey_nm,1,5)  
   when substring(css.strsurvey_nm,4,1)<'a' then substring(css.strsurvey_nm,1,4)  
   when substring(css.strsurvey_nm,3,1)<'a' then substring(css.strsurvey_nm,1,3)  
   when substring(css.strsurvey_nm,2,1)<'a' then substring(css.strsurvey_nm,1,2)  
   end as ProjectNumber,  
  AD,  
  sv.*,   
  sus.straltservice_nm as UserSpecifiedService,  
  case  
   --Canada and Sweden use picker  
   when css.client_id in (1033,1056,1060,1061,1062,1069,1071,1072,1076,1077,  
        1085,1090,1091,1092,1109,1110,1147,1154,1080) then 'Picker'  
   when ps.questioncount > 0 then 'Picker'  
   else 'Legacy'  
  end as PickervsLegacy,  
  AHA_ID,   
  strfacility_nm as HospitalName,   
  city,   
  state,   
  case  
   when css.client_id in (1033,1056,1060,1061,1062,1069,1071,1072,1076,1077,  
        1085,1090,1091,1092,1109,1110,1147,1154) Then 'Canada'  
   when css.client_id=1080 then 'Sweden'  
   else 'US'  
  end as Country,   
  strregion_nm as region,  
  AdmitNumber as Admissions,   
  BedSize,   
  case  
   when bedsize between 1 and 99 then '<100'  
   when bedsize between 200 and 299 then '200-299'  
   when bedsize between 300 and 399 then '300-399'  
   when bedsize between 400 and 499 then '400-499'  
   when bedsize between 500 and 599 then '500-599'  
   when bedsize between 600 and 699 then '600-699'  
   when bedsize between 700 and 799 then '700-799'  
   when bedsize >=800 then '>=800'  
   else null  
  end as BedSizeGroups,  
  bitTrauma as TraumaHospital,   
  --TraumaLevel,   
  bitGovernment as Government,   
  bitForProfit as ForProfit,   
  bitReligious as ReligiousAffiliation,   
  bitTeaching as Teaching,   
  bitRural as RURAL,  
  case  
   when strUnitSelectType in ('B','D') then 'Direct'  
   else 'Indirect'  
  end as sampleType   
into Norms_UnitsbyService  
from DATAMART.qp_comments.dbo.clientstudysurvey css join sampleplan sp  
 on css.survey_id=sp.survey_id and  
  css.client_id <> 443  
 join sampleunit s  
 on sp.sampleplan_id=s.sampleplan_id  
 join sampleunitservice sus  
 on sus.sampleunit_id=s.sampleunit_id  
 join #services sv  
 on sus.service_id=sv.service_id  
 join #PickerSurveys ps  
 on css.survey_id=ps.survey_id  
 join #unitselecttype u  
 on s.sampleunit_Id=u.sampleunit_id  
 left join sufacility f  
 on s.sufacility_id=f.sufacility_id  
 left join region r  
 on f.region_id=r.region_id  
order by 2, 4, 6, 8  
    
if exists (select 'x' from sysobjects where name = 'Norms_FacilitiesbyService')
begin   
	drop table Norms_FacilitiesbyService  
end
select distinct max(rtrim(css.strclient_nm) + ' (' + convert(varchar,css.client_id) + ')') as client,   
   /*case  
   when substring(css.strsurvey_nm,5,1)<'a' then substring(css.strsurvey_nm,1,5)  
   when substring(css.strsurvey_nm,4,1)<'a' then substring(css.strsurvey_nm,1,4)  
   when substring(css.strsurvey_nm,3,1)<'a' then substring(css.strsurvey_nm,1,3)  
   when substring(css.strsurvey_nm,2,1)<'a' then substring(css.strsurvey_nm,1,2)  
   end as ProjectNumber,  
  AD, */  
  --rtrim(css.strstudy_nm) + ' (' + convert(varchar,css.study_id) + ')' as study,   
  --rtrim(css.strsurvey_nm) + ' (' + convert(varchar,css.survey_id) + ')' as survey,  
  AHA_ID,   
  strfacility_nm as HospitalName,   
  city,   
  state,   
  case  
   when css.client_id in (1033,1056,1060,1061,1062,1069,1071,1072,1076,1077,  
        1085,1090,1091,1092,1109,1110,1147,1154) Then 'Canada'  
   when css.client_id=1080 then 'Sweden'  
   else 'US'  
  end as Country,   
  strregion_nm as region,  
  AdmitNumber as Admissions,   
  BedSize,   
  case  
   when bedsize between 1 and 99 then '<100'  
   when bedsize between 200 and 299 then '200-299'  
   when bedsize between 300 and 399 then '300-399'  
   when bedsize between 400 and 499 then '400-499'  
   when bedsize between 500 and 599 then '500-599'  
   when bedsize between 600 and 699 then '600-699'  
   when bedsize between 700 and 799 then '700-799'  
   when bedsize >=800 then '>=800'  
   else null  
  end as BedSizeGroups,  
  bitTrauma as TraumaHospital,   
  --TraumaLevel,   
  bitGovernment as Government,   
  bitForProfit as ForProfit,   
  bitReligious as ReligiousAffiliation,   
  bitTeaching as Teaching,   
  bitRural as RURAL,  
  sv.service_id,  
  sv.service_name,   
  --can't include because it causes duplicates  
  --sus.straltservice_nm as UserSpecifiedService,  
  max(case  
    --Canada and Sweden use picker  
    when css.client_id in (1033,1056,1060,1061,1062,1069,1071,1072,1076,1077,  
         1085,1090,1091,1092,1109,1110,1147,1154,1080) then 'Picker'  
    when ps.questioncount > 0 then 'Picker'  
    else 'Legacy'  
   end) as PickervsLegacy  
into Norms_FacilitiesbyService  
from DATAMART.qp_comments.dbo.clientstudysurvey css join sampleplan sp  
  on css.survey_id=sp.survey_id and  
   css.client_id <> 443  
  join sampleunit s  
  on sp.sampleplan_id=s.sampleplan_id  
  join sampleunitservice sus  
  on sp.sampleplan_id=s.sampleplan_id and  
   sus.sampleunit_id=s.sampleunit_id  
  join #services sv  
  on sus.service_id=sv.service_id  
  join sufacility f  
  on s.sufacility_id=f.sufacility_id  
  join #PickerSurveys ps  
  on css.survey_id=ps.survey_id  
  left join region r  
  on f.region_id=r.region_id  
group by AHA_ID,   
  strfacility_nm,   
  city,   
  state,   
  case  
   when css.client_id in (1033,1056,1060,1061,1062,1069,1071,1072,1076,1077,  
        1085,1090,1091,1092,1109,1110,1147,1154) Then 'Canada'  
   when css.client_id=1080 then 'Sweden'  
   else 'US'  
  end,   
  strregion_nm,  
  AdmitNumber,   
  BedSize,   
  case  
   when bedsize between 1 and 99 then '<100'  
   when bedsize between 200 and 299 then '200-299'  
   when bedsize between 300 and 399 then '300-399'  
   when bedsize between 400 and 499 then '400-499'  
   when bedsize between 500 and 599 then '500-599'  
   when bedsize between 600 and 699 then '600-699'  
   when bedsize between 700 and 799 then '700-799'  
   when bedsize >=800 then '>=800'  
   else null  
  end,  
  bitTrauma,   
  bitGovernment,   
  bitForProfit,   
  bitReligious,   
  bitTeaching,   
  bitRural,  
  sv.service_id,  
  sv.service_name  
order by 1, strfacility_nm  
  
drop table #pScorequestions  
drop table #pickersurveys  
drop table #services  
drop table #unitselecttype


