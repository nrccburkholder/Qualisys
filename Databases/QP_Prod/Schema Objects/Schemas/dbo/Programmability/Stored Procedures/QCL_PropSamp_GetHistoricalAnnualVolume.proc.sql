/*                  
Business Purpose:                   
This procedure is used to support the Qualisys Class Library.    
It will take a medicare number and calculate the annual HCAHPS volume   
using the period dates (rolling 1 year from last complete quarter)               
  
logic for Finding Historic annual HCAHPS volume is used in   
HCAHPS proportional Sampling to create the proportional sample percentage  
                  
Created: 8/11/2008 by MB              
			1/14/2015 CJB: switched from HCAHPS specific table to new EligibleEncLog table    
             
*/  
CREATE Procedure [dbo].[QCL_PropSamp_GetHistoricalAnnualVolume](@MedicareNumber varchar(20), @PeriodDate datetime)  
as  
  
begin
	declare @EncDateStart datetime, @EncDateEnd datetime  
	exec QCL_CreateHCHAPSRollingYear @PeriodDate, @EncDateStart OUTPUT, @EncDateEnd OUTPUT  
	  
	select count(he.enc_ID)  
	from medicarelookup ml, sufacility sf, sampleunit su, EligibleEncLog hE , periodDef pd1, periodDates pd2  
	where ml.medicareNumber = sf.MedicareNumber and  
	  sf.SUFacility_ID = su.SuFacility_ID and  
	  su.Sampleunit_ID = he.sampleunit_ID and  
	  pd1.periodDef_Id = pd2.PeriodDef_ID and  
	  pd2.sampleset_ID = he.sampleset_ID and  
	  pd1.datExpectedEncStart >= @EncDateStart and pd1.datExpectedEncEnd <= @EncDateEnd and   
	  ml.medicareNumber = @MedicareNumber  
end

