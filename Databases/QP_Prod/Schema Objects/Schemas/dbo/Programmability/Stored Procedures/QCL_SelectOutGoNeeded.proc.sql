/*  
Business Purpose:   
This procedure is used to support the Qualisys Class Library.  It returns 1 record   
for each sampleunit that needs to be sampled.  
  
Created:  02/24/2006 by DC  
  
Modified:  
--MWB 9/3/08  HCAHPS Prop Sampling Sprint 
--	Added a DontSampleUnit so users can "retire" a sampleunit without setting targets to 0 and renaming.
--	also added the ability to not sample the HCAHPS unit if it is a oversample.  All logic is controlled in the sampling app

*/    
  
CREATE  PROCEDURE [dbo].[QCL_SelectOutGoNeeded]  
 @SampleSet_id int,   
 @survey_id int,  
 @Period_id INT,   
 @SamplesInPeriod INT,  
 @SamplesRun INT,  
 @samplingMethod INT,  
 @ResponseRate_Recalc_Period INT,  
 @SampleHCAHPSUnit tinyint = 1
AS  

BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
	SET NOCOUNT ON  
	--Calculates the current response rate and updates the sampleunit table  
	EXEC QCL_CalcResponseRates @survey_id, @ResponseRate_Recalc_Period  
	--Calculates the targets for the current sampleset and saves in the SampleSetUnitTarget table  
	EXEC QCL_CalcTargets @SampleSet_id, @Period_id, @SamplesInPeriod, @SamplesRun,   
	  @Survey_id, @samplingMethod  


	--MWB 9/3/08  HCAHPS Prop Sampling Sprint 
	if @SampleHCAHPSUnit = 1
		begin
		 SELECT su.SampleUnit_ID, intTarget   
		 FROM	dbo.samplesetunittarget sssu, Sampleunit su   
		 WHERE	sssu.sampleunit_ID = su.sampleunit_ID and 
				sssu.SampleSet_id = @SampleSet_id  
				and su.DontSampleUnit = 0
		end
	else
		begin
		 SELECT su.SampleUnit_ID, intTarget   
		 FROM	dbo.samplesetunittarget sssu, Sampleunit su   
		 WHERE	sssu.sampleunit_ID = su.sampleunit_ID and 
				sssu.SampleSet_id = @SampleSet_id  
				and su.DontSampleUnit = 0
				and su.bitHCAHPS = 0
		end

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
	SET NOCOUNT OFF  

END


