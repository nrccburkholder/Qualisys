/*
Created 8/29/08 MWB
Purpose:  This proc returns a count of the eligible HCAHPS encounters and is used for the Proportional Sampling 
		  calculation to update the HCAHPS unit target
*/
Create proc QCL_GetHCAHPSEligibleCount (@Sampleset_ID int, @SampleUnit_ID int)
as

begin

	Select count(enc_ID) from HCAHPSEligibleEncLog
	where Sampleset_ID = @Sampleset_ID and SampleUnit_ID = @SampleUnit_ID

end


