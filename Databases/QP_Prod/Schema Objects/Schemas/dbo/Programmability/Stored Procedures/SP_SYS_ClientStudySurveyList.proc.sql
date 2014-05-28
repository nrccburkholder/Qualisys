CREATE PROCEDURE SP_SYS_ClientStudySurveyList @Associate VARCHAR(42)
AS

IF EXISTS (SELECT * FROM Employee e, Study_Employee se WHERE e.strNTLogin_nm=@Associate AND e.Employee_id=se.Employee_id)

SELECT DISTINCT STRClient_nm, c.Client_id, strStudy_nm, s.Study_id, strSurvey_nm, sd.Survey_id, CASE when t.Survey_id IS NULL then 'Inactive' eLSE 'Active' END Active
FROM Client c(NOLOCK), Study s(NOLOCK), 
Survey_Def sd(NOLOCK) LEFT OUTER JOIN (SELECT DISTINCT Survey_id FROM SampleSet(NOLOCK) WHERE datSampleCreate_dt>DATEDIFF(YEAR,-1,GETDATE())) t
ON sd.Survey_id=t.Survey_id, 
Study_Employee se(NOLOCK), Employee e(NOLOCK)
WHERE e.strNTLogin_nm=@Associate
AND e.Employee_id=se.Employee_id
AND se.Study_id=s.Study_id
AND s.Study_id=sd.Study_id
AND s.Client_id=c.Client_id
ORDER BY 1,3,5

ELSE

SELECT DISTINCT STRClient_nm, c.Client_id, strStudy_nm, s.Study_id, strSurvey_nm, sd.Survey_id, CASE when t.Survey_id IS NULL then 'Inactive' eLSE 'Active' END Active
FROM Client c(NOLOCK), Study s(NOLOCK), 
Survey_Def sd(NOLOCK) LEFT OUTER JOIN (SELECT DISTINCT Survey_id FROM SampleSet(NOLOCK) WHERE datSampleCreate_dt>DATEDIFF(YEAR,-1,GETDATE())) t
ON sd.Survey_id=t.Survey_id
WHERE s.Study_id=sd.Study_id
AND s.Client_id=c.Client_id
ORDER BY 1,3,5


