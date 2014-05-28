-------------------------------------------------------------------------
-- Copyright © National Research Corporation
--
-- Project Name:	HCAHPS Sampling
--
-- Created By:		Jeffrey J. Fleming
--		   Date:	09-15-2008
--
-- Description:
-- This procedure returns the client, study, survey, and sampleunit
-- information for the specified MedicareNumber.
--
-- Revisions:
--		Date		By		Description
-------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[QCL_SelectClientStudySurveySampleUnitsByMedicareNumber]
    @MedicareNumber varchar(20)
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	SELECT cl.Client_id as ClientID, cl.strClient_Nm as ClientName, 
		   st.Study_id as StudyID, st.strStudy_Nm as StudyName, 
		   sd.Survey_id as SurveyID, sd.strSurvey_Nm as SurveyName, 
		   su.SampleUnit_id as SampleUnitID, su.strSampleUnit_Nm as SampleUnitName 
	FROM MedicareLookup ml, SUFacility sf, SampleUnit su, SamplePlan sp, 
		 Survey_Def sd, Study st, Client cl
	WHERE ml.MedicareNumber = sf.MedicareNumber
	  AND sf.SUFacility_id = su.SUFacility_id
	  AND su.SamplePlan_id = sp.SamplePlan_id
	  AND sp.Survey_id = sd.Survey_id
	  AND sd.Study_id = st.Study_id
	  AND st.Client_id = cl.Client_id
	  AND su.bitHCAHPS = 1
	  AND su.DontSampleUnit = 0
	  AND ml.MedicareNumber = @MedicareNumber

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	SET NOCOUNT OFF

END


