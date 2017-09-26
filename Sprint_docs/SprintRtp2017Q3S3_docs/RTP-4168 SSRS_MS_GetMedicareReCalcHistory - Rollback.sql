/*
	RTP-4168 SSRS_MS_GetMedicareReCalcHistory - Rollback.sql

	Ted Smidberg

	9/26/2017

	ALTER PROCEDURE dbo.SSRS_MS_GetMedicareReCalcHistory
*/
USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[SSRS_MS_GetMedicareReCalcHistory]    Script Date: 9/26/2017 12:42:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 
ALTER procedure [dbo].[SSRS_MS_GetMedicareReCalcHistory]    
 @MedicareNumber varchar(20)    
    
as    
    
--exec SSRS_MS_GetMedicareReCalcHistory '052802'    
--declare @MedicareNumber varchar(20),@MinDate datetime,@MaxDate datetime set @MedicareNumber='030010'    
    
select mrh.MedicareNumber,    
  mrh.MedicareName,    
  'HCAHPS Proportional Calculation' MedicarePropCalcTypeName, --mpct.MedicarePropCalcTypeName,
  isnull(md.MedicarePropDataType_nm,'Unknown') MedicarePropDataType_nm,    
  mrh.EstRespRate,    
  mrh.EstIneligibleRate,    
  mrh.EstAnnualVolume,    
  mrh.SwitchToCalcDate,    
  mrh.AnnualReturnTarget,    
  mrh.ProportionCalcPct,    
  case mrh.SamplingLocked when 0 then 'No' when 1 then 'Yes' else 'Unknown' end SamplingLocked,    
  mrh.ProportionChangeThreshold,    
  case mrh.CensusForced when 0 then 'No' when 1 then 'Yes' else 'Unknown' end CensusForced,        
  mrh.DateCalculated,    
  mrh.HistoricRespRate,
  mrh.historicAnnualVolume,    
  case mrh.ForcedCalculation when 0 then 'No' when 1 then 'Yes' else 'Unknown' end ForcedCalculation,    
  isnull(convert(varchar,mrh.PropSampleCalcDate,101),'Not Set') PropSampleCalcDate,
  m.strMember_nm,
  CONVERT(varchar, mrh.DateCalculated,101) as EventDate,    
  mrh.DateCalculated as EventDateOrder
from MedicareRecalc_History mrh    
 --inner join MedicarePropCalcTypes mpct    
 -- on (mrh.MedicarePropCalcType_ID=mpct.MedicarePropCalcType_ID)    
 inner join Security.NRCAuth.dbo.Member m    
  on (mrh.Member_id=m.Member_id)    
 left outer join MedicarePropDataType md
  on (mrh.MedicarePropDataType_ID = md.MedicarePropDataType_ID) 
where mrh.MedicareNumber=@MedicareNumber  

UNION

Select	s.MedicareNumber, 
		MedicareName, 
		'Sampling Unlocked' MedicarePropCalcTypeName,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		mbr.strMember_nm, 
		CONVERT(varchar, s.DateUnlocked,101) as EventDate,  
		DateUnlocked as EventDateOrder   
from	SamplingUnlocked_log s, MedicareLookup m, Security.NRCAuth.dbo.Member mbr
where	s.MedicareNumber = m.Medicarenumber and
		s.MemberID = mbr.member_ID and
		s.MedicareNumber=@MedicareNumber
order by EventDateOrder desc    

GO


