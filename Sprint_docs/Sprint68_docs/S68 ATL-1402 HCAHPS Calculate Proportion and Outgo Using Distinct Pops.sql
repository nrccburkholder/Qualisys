/*

S68 ATL-1402 HCAHPS Calculate Proportion & Outgo Using Distinct Pops

As an HCAHPS vendor, we need to calculate sampling proportion and outgo needed based on distinct population records rather than encounters, 
so that we sample according to protocols and comply with on-site visit action items.


QCL_PropSamp_GetHistoricalAnnualVolume
QCL_GetHCAHPSEligibleCount


Tim Butler

*/

USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_PropSamp_GetHistoricalAnnualVolume]    Script Date: 2/2/2017 10:03:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*                  
Business Purpose:                   
This procedure is used to support the Qualisys Class Library.    
It will take a medicare number and calculate the annual HCAHPS volume   
using the period dates (rolling 1 year from last complete quarter)               
  
logic for Finding Historic annual HCAHPS volume is used in   
HCAHPS proportional Sampling to create the proportional sample percentage  
                  
Created: 8/11/2008 by MB              
			1/14/2015 CJB: switched from HCAHPS specific table to new EligibleEncLog table 
			2/02/2017 TSB: S68 ATL-1402 HCAHPS Calculate Proportion & Outgo Using Distinct Pops   
             
*/  
ALTER Procedure [dbo].[QCL_PropSamp_GetHistoricalAnnualVolume](@MedicareNumber varchar(20), @PeriodDate datetime)  
as  
  
begin
	declare @EncDateStart datetime, @EncDateEnd datetime  
	exec QCL_CreateHCHAPSRollingYear @PeriodDate, @EncDateStart OUTPUT, @EncDateEnd OUTPUT  
	  
	select count(he.pop_ID)  
	from medicarelookup ml, sufacility sf, sampleunit su, EligibleEncLog hE , periodDef pd1, periodDates pd2  
	where ml.medicareNumber = sf.MedicareNumber and  
	  sf.SUFacility_ID = su.SuFacility_ID and  
	  su.Sampleunit_ID = he.sampleunit_ID and  
	  pd1.periodDef_Id = pd2.PeriodDef_ID and  
	  pd2.sampleset_ID = he.sampleset_ID and  
	  pd1.datExpectedEncStart >= @EncDateStart and pd1.datExpectedEncEnd <= @EncDateEnd and   
	  ml.medicareNumber = @MedicareNumber  
end

GO

USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_GetHCAHPSEligibleCount]    Script Date: 2/2/2017 10:04:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Created 8/29/08 MWB
Purpose:  This proc returns a count of the eligible HCAHPS encounters and is used for the Proportional Sampling 
		  calculation to update the HCAHPS unit target
			1/14/2015 CJB: switched from HCAHPS specific table to new EligibleEncLog table  
			2/02/2017 TSB: S68 ATL-1402 HCAHPS Calculate Proportion & Outgo Using Distinct Pops  
*/
ALTER proc [dbo].[QCL_GetHCAHPSEligibleCount] (@Sampleset_ID int, @SampleUnit_ID int)
as

begin

	Select count(pop_ID) from EligibleEncLog
	where Sampleset_ID = @Sampleset_ID and SampleUnit_ID = @SampleUnit_ID

end

GO