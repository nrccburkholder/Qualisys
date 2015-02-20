set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
/***********************************************************************************************************************************
SP Name: sp_Samp_AddSampleSetV2 
Part of:  Sampling Tool
Purpose:  
Input:  
 
Output:  
Creation Date: 02/01/2004
Author(s): DC 
Revision: First build - 02/01/2004
	05-28-2004 DC 
		Added a check to catch when the period selected is for a different survey
		then we are supposed to be sampling.
	01-30-2006 DC 
		Added code to populate the samplingAlgorithm field in sampleset
***********************************************************************************************************************************/
ALTER          PROCEDURE [dbo].[sp_Samp_AddSampleSetV2] 
 @intSurvey_id INT,
 @intEmployee_id INT,
 @vcDateRange_FromDate VARCHAR(24) = NULL,
 @vcDateRange_ToDate VARCHAR(24) = NULL,
 @tiOverSample_flag bit,
 @tiNewPeriod_flag bit,
 @intPeriodDef_id int
AS
 DECLARE @intSamplePlan_id INT, @intSampleSet_id int
 DECLARE @strSurvey_nm VARCHAR(10), @sampleEncounterDate_Table_id int, 
		@sampleEncounterDate_Field_id int, @sql varchar(5000), @SamplingAlgorithmId int


	--insert into dc_temp_timer (sp, starttime)
	--values ('sp_Samp_AddSampleSetV2', getdate())
CREATE TABLE #DATEFIELD (table_id int, field_id int)

IF NOT (@vcDateRange_FromDate is null or @vcDateRange_FromDate='')
BEGIN
	SET @SQL = 'INSERT INTO #DATEFIELD' +
	   ' SELECT ms.Table_id, ms.Field_id' +
	   ' FROM Survey_def sd, MetaStructure ms, MetaTable mt, MetaField mf' +
	   ' WHERE sd.Study_id = mt.Study_id' +
	   ' AND ms.Table_id = mt.Table_id' +
	   ' AND ms.table_id=sd.sampleEncountertable_id' +
	   ' AND ms.field_id=sd.sampleEncounterfield_id' +
	   ' AND ms.Field_id = mf.Field_id' +
	   ' AND mf.strFieldDataType = ''D''' +
	   ' AND sd.Survey_id = '  + CONVERT(VARCHAR,@intSurvey_id)

	EXECUTE (@SQL)

	SELECT @sampleEncounterDate_Table_id=Table_id,
			@sampleEncounterDate_Field_id=Field_id
	FROM #DATEFIELD

END

 SELECT @strSurvey_nm = strSurvey_nm,
		@SamplingAlgorithmId=case
								when bitdynamic=0 then 1
								when bitdynamic=1 then 2
								else 0
							 end
  FROM Survey_def 
  WHERE Survey_id = @intSurvey_id

 SELECT @intSamplePlan_id = SamplePlan_id 
  FROM dbo.SamplePlan
  WHERE Survey_id = @intSurvey_id

 INSERT INTO dbo.SampleSet
  (SamplePlan_id, Survey_id, Employee_id, datSampleCreate_dt, 
   intDateRange_Table_id, intDateRange_Field_id, datDateRange_FromDate, 
   datDateRange_ToDate, tiOverSample_flag, tiNewPeriod_flag, strSampleSurvey_nm,
	SamplingAlgorithmId)
 VALUES
  (@intSamplePlan_id, @intSurvey_id, @intEmployee_id, GETDATE(), 
   @sampleEncounterDate_Table_id, @sampleEncounterDate_Field_id, @vcDateRange_FromDate, 
   @vcDateRange_ToDate, @tiOverSample_flag, @tiNewPeriod_flag, @strSurvey_nm,
	@SamplingAlgorithmId)
                                                                                                                                                                        
-- SELECT @@IDENTITY as intSampleSet_id
 SELECT @intSampleSet_id = @@IDENTITY 
-- SELECT @intSampleSet_id = SCOPE_IDENTITY()

 --Check for Cases where a period for the wrong survey is passed in
 IF EXISTS (select s.sampleset_id
			from sampleset s, perioddef pd
			where s.sampleset_id=@intSampleSet_id and
				  pd.perioddef_id=@intPeriodDef_id and
				  s.survey_id <> pd.survey_id)
BEGIN
	RAISERROR ('Error: Invalid Period.  Please delete this sample, close sampling tool, and then try sampling again.  If this error happens again, please sumbit a helpdesk ticket.', 18, 1)
	Return
END
ELSE
BEGIN
	
	--Insert into SamplePlanWorkSheet table
	INSERT INTO SamplePlanWorkSheet (SampleSet_id, SampleUnit_id, strSampleUnit_nm, ParentSampleUnit_id, intPeriodReturnTarget, 
		numDefaultResponseRate, intSamplesInPeriod)
	SELECT @intSampleSet_id, SampleUnit_id, strSampleUnit_nm, ParentSampleUnit_id, intTargetReturn, 
		numInitResponseRate, intExpectedSamples
	FROM SampleUnit su, SamplePlan sp, Survey_def sd, Perioddef p
	WHERE sp.Survey_id = @intSurvey_id
	AND sp.SamplePlan_id = su.SamplePlan_id
	AND sp.Survey_id = sd.Survey_id 
	AND sd.survey_id=p.survey_Id
	AND p.periodDef_id=@intPeriodDef_id
END

SELECT @intSampleSet_id AS intSampleSet_id

DROP TABLE #DATEFIELD
