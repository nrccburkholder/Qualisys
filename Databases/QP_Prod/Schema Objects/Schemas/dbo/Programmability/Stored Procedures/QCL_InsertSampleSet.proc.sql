/*  
Business Purpose:   
This procedure is used to support the Qualisys Class Library.  It creates a new  
sampleset record and also adds placeholders in the sampleplanworksheet table.  
  
Created:  2/23/2006 by DC  
  
Modified: 5/18/2006 by SS -- If Table_id or Field_id is passed as zero set it to NULL because of FK to metatable
Modified: 7/15/2009 by DRM -- Changed @@identity to Scope_Identity()  
  
*/   
  
CREATE PROCEDURE [dbo].[QCL_InsertSampleSet]   
 @intSurvey_id INT,  
 @intEmployee_id INT,  
 @vcDateRange_FromDate VARCHAR(24) = NULL,  
 @vcDateRange_ToDate VARCHAR(24) = NULL,  
 @tiOverSample_flag bit,  
 @tiNewPeriod_flag bit,  
 @intPeriodDef_id int,  
 @strSurvey_nm VARCHAR(10),   
 @intSampleEncounterDateRange_Table_id int,   
 @intSampleEncounterDateRange_Field_id int,  
 @SamplingAlgorithmId int,  
 @intSamplePlan_id INT,  
 @SurveyType_id INT,  
 @HCAHPSOverSample bit  
AS  
  
BEGIN  
  
  DECLARE @intSampleSet_id int  
  
 --If Table_id or Field_id is passed as zero set it to NULL because of FK to metatable  
  SELECT @intSampleEncounterDateRange_Table_id = CASE WHEN @intSampleEncounterDateRange_Table_id = -1 THEN NULL ELSE @intSampleEncounterDateRange_Table_id END,  
  @intSampleEncounterDateRange_Field_id = CASE WHEN @intSampleEncounterDateRange_Field_id = -1 THEN NULL ELSE @intSampleEncounterDateRange_Field_id END  
  
  
  INSERT INTO dbo.SampleSet  
   (SamplePlan_id, Survey_id, Employee_id, datSampleCreate_dt,   
    intDateRange_Table_id, intDateRange_Field_id,   
    datDateRange_FromDate,   
    datDateRange_ToDate, tiOverSample_flag, tiNewPeriod_flag, strSampleSurvey_nm,  
  SamplingAlgorithmId,surveytype_id, HCAHPSOverSample)  
  VALUES  
   (@intSamplePlan_id, @intSurvey_id, @intEmployee_id, GETDATE(),   
    @intSampleEncounterDateRange_Table_id, @intSampleEncounterDateRange_Field_id, @vcDateRange_FromDate,   
    @vcDateRange_ToDate, @tiOverSample_flag, @tiNewPeriod_flag, @strSurvey_nm,  
  @SamplingAlgorithmId,@SurveyType_id, @HCAHPSOverSample)  
                                                                                                                                                                           
  SELECT @intSampleSet_id = Scope_Identity()
  
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
  
 SELECT @intSampleSet_id AS intSampleSet_id  
END


