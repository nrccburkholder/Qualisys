/*  
Business Purpose:   
  
This procedure is used to support the Qualisys Class Library.  It updates the   
contents of the sampleset table after the sampling algorithm has finished. 
  
Created:  02/28/2006 by DC  
  
Modified:  
*/      
CREATE PROCEDURE [dbo].[QCL_UpdateSampleSetPostSample]  
@sampleSetId INT,  
@preSampleTime INT,
@postSampleTime INT,
@seed INT,
@MinEncounterDate datetime = null,
@MaxEncounterDate datetime =null

AS 

if @MinEncounterDate is null
BEGIN 
  	UPDATE SampleSet  
	SET PreSampleTime=@preSampleTime,
		PostSampleTime=@postSampleTime,
		intSample_Seed=@seed
	WHERE SampleSet_id=@SampleSetid 
END
ELSE
BEGIN
  	UPDATE SampleSet  
	SET PreSampleTime=@preSampleTime,
		PostSampleTime=@postSampleTime,
		intSample_Seed=@seed,
		datDateRange_FromDate=@MinEncounterDate,
		datDateRange_ToDate=@MaxEncounterDate
	WHERE SampleSet_id=@SampleSetid 
END


