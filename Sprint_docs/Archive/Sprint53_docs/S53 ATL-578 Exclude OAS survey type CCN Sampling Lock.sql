/*
	S53 ATL-578 Exclude OAS survey type CCN Sampling Lock.sql

	Chris Burkholder

	7/7/2016

	ATL-578    Exclude OAS survey type in regards CCN Sampling Lock (make HCAHPS specific)
	
    ATL-603    Enhance Sampling Tool UI to only check locking for HCAHPS
	
*/


USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_IsSamplingLocked_BySurveyID]    Script Date: 7/7/2016 9:39:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
QCL_IsSamplingLocked_BySurveyID
Purpose:	checks to see if any medicare records are locked by Survey_ID
			You cannot recalculate propotional sampling percentage if ANY 
			HCAHPS sampleunit has been locked.  
			(Many sampleunits can be assigned to one facility and all 
			facilities must be unlocked)
		
CREATED by MWB 9/8/08

MODIFIED: CJB 7/7/2016 now only for HCAHPS (Surveytype_id = 2)

*/
ALTER proc [dbo].[QCL_IsSamplingLocked_BySurveyID] (@Survey_IDs varchar(7000))
as

begin

	declare @SQL varchar(8000)
	SET @Survey_IDs = '''' + replace(@Survey_IDs, ',', ''',''') + ''''


	
		Select  @SQL = '
				SELECT	Distinct ml.MedicareNumber, ml.MedicareName, sd.Strsurvey_nm, sd.survey_ID
		FROM	Sampleunit su 
			INNER JOIN sampleplan sp on su.samplePlan_id = sp.samplePlan_id
			INNER JOIN survey_Def sd on sd.survey_id = sp.survey_id
			INNER JOIN suFacility f on su.SUFacility_ID = f.SUFAcility_ID
			INNER JOIN medicareLookup ml on ml.medicarenumber = f.medicarenumber
		WHERE	sp.Survey_ID IN (' + @Survey_IDs + ') and
				sd.surveytype_id = 2 and 
				ml.samplingLocked = 1
'

	--print @SQL
	exec (@SQL)


end
GO