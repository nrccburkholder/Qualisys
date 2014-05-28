CREATE PROCEDURE dbo.SV_AddressToUnit_Root  
@Survey_id INT  
AS  

IF (SELECT COUNT(*)   
      FROM SamplePlan sp, SampleUnit su   
      WHERE sp.survey_id=@Survey_id    
      AND sp.SamplePlan_id=su.SamplePlan_id  )=0  
  
BEGIN  
      SELECT 1 bitError,'Address Section is not mapped to a top level Sample Unit' strMessage  
      RETURN  
END  

SELECT DISTINCT 1 bitError, 'Address Section is not mapped to a top level Sample Unit' strMessage  
FROM SampleUnit su, SampleUnitSection sus  
WHERE su.SampleUnit_id=sus.SampleUnit_id  
AND sus.SelQstnsSection=-1  
AND sus.SelQstnsSurvey_id=@Survey_id  
and su.ParentSampleUnit_id IS NOT NULL  
IF @@ROWCOUNT=0  
SELECT 0 bitError, 'Address section mapped a top level sample unit' strMessage


