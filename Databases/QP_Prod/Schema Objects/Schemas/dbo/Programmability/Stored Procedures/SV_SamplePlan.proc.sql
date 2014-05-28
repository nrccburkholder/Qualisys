CREATE PROCEDURE [dbo].[SV_SamplePlan]  
@Survey_id INT  
AS  

CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(100))

-- Is there a sampleplan defined?
IF (SELECT COUNT(*) 
      FROM SamplePlan sp, SampleUnit su 
      WHERE sp.survey_id=@Survey_id  
      AND sp.SamplePlan_id=su.SamplePlan_id  )=0

BEGIN
      INSERT INTO #M (Error, strMessage)
      SELECT 1 Error,'The SamplePlan is not defined'
      GOTO Report
END

--Make sure each sampleunit has a question section mapped to it.  
INSERT INTO #M (Error, strMessage)
SELECT DISTINCT 1 Error, 'Sample Unit "'+ SU.strSampleUnit_nm + '" not Mapped to a Question Section' strMessage  
FROM SamplePlan sp, SampleUnit su  
WHERE sp.survey_id=@Survey_id  
AND  sp.SamplePlan_id=su.SamplePlan_id  
AND  NOT EXISTS  
(SELECT * FROM SampleUnitSection sus, sel_qstns sq  
WHERE sus.selqstnssection=sq.section_id
	and sus.selqstnssurvey_id=sq.survey_id
	and su.SampleUnit_id=sus.SampleUnit_id)  

--Make sure each sampleunit has a service definition.
INSERT INTO #M (Error, strMessage)
SELECT 1,'Sample Unit "'+su.strSampleUnit_nm+'" does not have a service type.'
FROM SampleUnit su LEFT JOIN SampleUnitService sus ON su.SampleUnit_id=sus.SampleUnit_id, SamplePlan sp
WHERE sp.Survey_id=@Survey_id
AND sp.SamplePlan_id=su.SamplePlan_id
AND sus.SampleUnit_id IS NULL

IF (SELECT COUNT(*) FROM #M)=0
INSERT INTO #M (Error, strMessage)
SELECT 0 Error, 'Sample Unit validation' strMessage  

Report:
SELECT * FROM #M
DROP TABLE #M


