

use QP_Prod

SELECT DISTINCT
    study.study_id as StudyId,
    study.strstudy_nm as StudyName,
	F.SUFacility_id,
	Facility.SUFacility_id
    FROM [QP_Prod].[dbo].[CLIENT] AS c
INNER JOIN [QP_Prod].[dbo].[STUDY] AS study ON study.client_id = c.Client_id 
LEFT JOIN [QP_Prod].[dbo].[ClientSUFacilityLookup] AS f ON c.client_id = f.client_id
LEFT JOIN  [QP_Prod].[dbo].[SUFacility] AS facility ON f.SuFacility_id = facility.SuFacility_id
where F.SUFacility_id is null

SELECT DISTINCT
    study.study_id as StudyId,
    study.strstudy_nm as StudyName
    FROM [QP_Prod].[dbo].[CLIENT] AS c
INNER JOIN [QP_Prod].[dbo].[STUDY] AS study ON study.client_id = c.Client_id 
INNER JOIN [QP_Prod].[dbo].[ClientSUFacilityLookup] AS f ON c.client_id = f.client_id
INNER JOIN  [QP_Prod].[dbo].[SUFacility] AS facility ON f.SuFacility_id = facility.SuFacility_id



SELECT s.client_id, c.STRCLIENT_NM, s.STUDY_ID, s.STRSTUDY_NM, sd.SURVEY_ID, sd.STRSURVEY_NM, sp.SAMPLEPLAN_ID, su.SAMPLEUNIT_ID, su.STRSAMPLEUNIT_NM, suf.SUFacility_id, suf.strFacility_nm
from dbo.Study s
inner join dbo.client c on c.CLIENT_ID = s.CLIENT_ID
inner join dbo.Survey_Def sd on sd.STUDY_ID = s.STUDY_ID
inner join dbo.SamplePlan sp on sp.SURVEY_ID = sd.SURVEY_ID
inner join dbo.sampleunit su on su.SAMPLEPLAN_ID = sp.SAMPLEPLAN_ID
left join dbo.SUFacility suf on suf.SUFacility_id = su.SUFacility_id
where sd.survey_id in (15910, 16129, 16039)
order by s.STUDY_ID



select * from dbo.Survey_Def