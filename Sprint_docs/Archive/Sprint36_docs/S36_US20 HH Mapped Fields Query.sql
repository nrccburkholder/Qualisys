/*
S36_US20 HH Mapped Fields Query.sql

user story 20 ICD-10 -- HH Mapped Fields Query 

As a Data Mgmt Associate, I want a query to identify QLoader packages that do and do not have the ICD-10 fields mapped, so I can ensure all updates are made during the transition. (non OCS)


Dave Gilsdorf

QP_Prod:

*/
use QP_Prod
go
select cg.clientgroup_nm, c.strClient_nm, s.strStudy_nm, mt.study_id, sd.survey_id, sd.strSurvey_nm, mt.strTable_nm
	, ql.strPackage_nm
	, sum(case when mf.strfield_nm like '%icd10%' then 1 else 0 end) as numICD10fields
	, min(ql.numMapped) as numMapped
from survey_def sd 
inner join surveytype st on sd.surveytype_id=st.surveytype_id
inner join metatable mt on mt.study_id=sd.study_id
inner join metastructure ms on ms.table_id=mt.table_id
inner join metafield mf on ms.field_id=mf.field_id
inner join study s on sd.study_id=s.study_id
inner join client c on s.client_id=c.client_id
left join ClientGroups cg on c.clientgroup_id=cg.clientgroup_id
left join (	select p.study_id, p.package_id, p.strPackage_nm, sum(case when d.formula like '%icd10%' then 1 else 0 end) as numMapped
			from qloader.qp_load.dbo.package p
			inner join qloader.qp_load.dbo.destination d on p.package_id=d.package_id
			where p.bitActive=1
			group by p.package_id, p.strPackage_nm, p.study_id) ql 
	on sd.study_id=ql.study_id
where st.surveytype_dsc ='Home Health CAHPS'
and mt.strTable_nm = 'ENCOUNTER'
and sd.strSurvey_nm not like 'xx%'
and sd.strSurvey_nm not like 'zz%'
and sd.Active=1
and s.Active=1
and c.Active=1
and isnull(cg.clientgroup_nm,'') <> 'OCS'
group by cg.clientgroup_nm, c.strClient_nm, s.strStudy_nm, sd.survey_id, sd.strSurvey_nm, mt.study_id, mt.strTable_nm, ql.strPackage_nm
order by cg.clientgroup_nm, c.strClient_nm, s.strStudy_nm, ql.strPackage_nm


