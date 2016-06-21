/*
S33_US18 HHCAHPS studies with ICD10 fields.sql

HH ICD-10 Fields Query

As a Data Mgmt Associate, I want a query to identify HH studies that are missing ICD-10 fields, so that we ensure nothing is missed 
during the transition		

18.1	write query to identify HH studies with missing fields

Dave Gilsdorf

*/
use qp_prod
go
select c.strClient_nm, s.strStudy_nm, mt.study_id, sd.survey_id, sd.strSurvey_nm, mt.strTable_nm, sum(case when strfield_nm like '%icd10%' then 1 else 0 end) as numICD10fields
from survey_def sd 
inner join surveytype st on sd.surveytype_id=st.surveytype_id
inner join metatable mt on mt.study_id=sd.study_id
inner join metastructure ms on ms.table_id=mt.table_id
inner join metafield mf on ms.field_id=mf.field_id
inner join study s on sd.study_id=s.study_id
inner join client c on s.client_id=c.client_id
where st.surveytype_dsc ='Home Health CAHPS'
and mt.strTable_nm = 'ENCOUNTER'
and sd.strSurvey_nm not like 'xx%'
and sd.strSurvey_nm not like 'zz%'
and sd.Active=1
and s.Active=1
and c.Active=1
group by c.strClient_nm, s.strStudy_nm, sd.survey_id, sd.strSurvey_nm, mt.study_id, mt.strTable_nm
order by 1,2
