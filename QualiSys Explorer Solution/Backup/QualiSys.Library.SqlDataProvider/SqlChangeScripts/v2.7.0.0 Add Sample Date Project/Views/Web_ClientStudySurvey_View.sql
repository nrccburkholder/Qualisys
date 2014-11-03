ALTER VIEW WEB_ClientStudySurvey_View     
AS    

-- 7/31/06 SJS: Added datHCAHPSReportable column  
-- 10/20/06 SJS: Added strSampleEncounterField for Export purposes.
SELECT DISTINCT strClient_nm, s.strStudy_nm, sd.strSurvey_nm strQSurvey_nm, ISNULL(strClientFacingName,sd.strSurvey_nm) strSurvey_nm, c.Client_id, s.Study_id, sd.Survey_id,     
 strNTLogin_nm, mf.strField_nm strReportDateField, mf2.strField_nm AS strSampleEncounterDateField, CASE WHEN datArchived IS NULL THEN 0 ELSE 1 END bitArchived, sd.datHCAHPSReportable, sd.SurveyType_id
FROM ClientStudySurvey_View c (NOLOCK)
INNER JOIN Study s (NOLOCK) ON c.Study_id=s.Study_id    
INNER JOIN Employee e (NOLOCK) ON s.ADEmployee_id=e.Employee_id    
INNER JOIN Survey_Def sd (NOLOCK) ON c.Survey_id=sd.Survey_id    
LEFT  JOIN MetaField mf(NOLOCK) ON sd.cutofffield_id=mf.field_id    
LEFT  JOIN MetaField mf2 (NOLOCK) ON sd.SampleEncounterField_id=mf2.field_id    
WHERE  sd.strCutOffResponse_CD=2    
UNION    
SELECT DISTINCT strClient_nm, s.strStudy_nm, sd.strSurvey_nm strQSurvey_nm, ISNULL(strClientFacingName,sd.strSurvey_nm) strSurvey_nm, c.Client_id, s.Study_id, sd.Survey_id,     
 strNTLogin_nm, CASE WHEN strCutOffResponse_cd=0 THEN 'SampleCreate'  
 WHEN strCutOffResponse_cd=1 THEN 'ReturnDate' END strReportDateField, mf.strField_nm AS strSampleEncounterDateField,
 CASE WHEN datArchived IS NULL THEN 0 ELSE 1 END bitArchived, sd.datHCAHPSReportable, sd.SurveyType_id
FROM ClientStudySurvey_View c (NOLOCK) 
INNER JOIN Study s (NOLOCK) ON c.Study_id=s.Study_id    
INNER JOIN Employee e (NOLOCK) ON s.ADEmployee_id=e.Employee_id    
INNER JOIN Survey_Def sd (NOLOCK) ON c.Survey_id=sd.Survey_id    
LEFT  JOIN MetaField mf (NOLOCK) ON sd.SampleEncounterField_id = mf.Field_id
WHERE sd.strCutOffResponse_CD IN (0,1)