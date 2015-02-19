/*
Created 8/29/08 MWB
Purpose:  This proc returns a count of the eligible HCAHPS encounters and is used for the Proportional Sampling 
		  calculation to update the HCAHPS unit target
			1/14/2015 CJB: switched from HCAHPS specific table to new EligibleEncLog table    
*/
CREATE proc [dbo].[QCL_GetHCAHPSEligibleCount] (@Sampleset_ID int, @SampleUnit_ID int)
as

begin

	Select count(enc_ID) from EligibleEncLog
	where Sampleset_ID = @Sampleset_ID and SampleUnit_ID = @SampleUnit_ID

end
