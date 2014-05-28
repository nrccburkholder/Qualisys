/*
QCL_IsSamplingLocked_BySurveyID
Purpose:	checks to see if any medicare records are locked by Survey_ID
			You cannot recalculate propotional sampling percentage if ANY 
			HCAHPS sampleunit has been locked.  
			(Many sampleunits can be assigned to one facility and all 
			facilities must be unlocked)
		
CREATED by MWB 9/8/08

MODIFIED:

*/
Create proc QCL_IsSamplingLocked_BySurveyID (@Survey_IDs varchar(7000))
as

begin

	declare @SQL varchar(8000)
	SET @Survey_IDs = '''' + replace(@Survey_IDs, ',', ''',''') + ''''



		Select  @SQL = '
		SELECT	Distinct ml.MedicareNumber, ml.MedicareName, sd.Strsurvey_nm, sd.survey_ID
		FROM	Sampleunit su, suFacility f, sampleplan sp, medicareLookup ml, survey_Def sd
		WHERE	su.SUFacility_ID = f.SUFacility_ID and
				f.MedicareNumber = ml.medicareNumber and
				sp.sampleplan_ID = su.sampleplan_ID and
				sp.survey_ID = sd.survey_ID and
				sp.Survey_ID IN (' + @Survey_IDs + ') and
				ml.samplingLocked = 1'

	--print @SQL
	exec (@SQL)


end


