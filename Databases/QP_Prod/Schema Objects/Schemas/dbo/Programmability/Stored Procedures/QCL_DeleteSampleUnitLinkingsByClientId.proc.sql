CREATE PROCEDURE DBO.QCL_DeleteSampleUnitLinkingsByClientId
@ClientId INT
AS

DELETE sul
FROM SampleUnitLinkage sul, SampleUnit su, SamplePlan sp, Survey_Def sd, Study s
WHERE sul.LinkSampleUnit_id = su.SampleUnit_id
AND su.SamplePlan_id = sp.SamplePlan_id
AND sp.Survey_id = sd.Survey_id
AND sd.Study_id = s.Study_id
AND s.Client_id = @ClientId


