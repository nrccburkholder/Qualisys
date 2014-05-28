/****** Object:  Stored Procedure dbo.sp_QPAddSurveyDef    Script Date: 6/9/99 4:36:38 PM ******/  
/****** Object:  Stored Procedure dbo.sp_QPAddSurveyDef    Script Date: 3/12/99 4:16:09 PM ******/  
/****** Object:  Stored Procedure dbo.sp_QPAddSurveyDef    Script Date: 12/7/98 2:34:55 PM ******/  
-- 01/14/2009 Don Mayhew - Added Contract field
CREATE PROCEDURE sp_QPAddSurveyDef  
@mintStudy_id int,  
@mstrSurvey_nm varchar(10),  
@mstrSurvey_dsc varchar(40),  
@mintResponse_recalc_period int,  
@mintResurvey_period int,  
@mbitRepeatingEncounters_flg bit,  
@mbitPhysAssist_name_flg bit,  
@mbitMinor_except_flg bit,  
@mbitNewborn_flg bit,  
@mbitDoHousehold bit,  
@mdatSurvey_start_dt datetime,  
@mdatSurvey_end_dt datetime,  
@mstrMailFreq varchar(9),  
@mintSamplesInPeriod int,  
@mstrXmitRoute varchar(5),  
@mbitUseComments bit,  
@mstrCmntCopyType varchar(15),  
@mstrCmntSort varchar(40),  
@mbitSendCmntOut bit,  
@mstrSpecialInstructions varchar(1),  
@mstrCmntMailFreq varchar(9),  
@mstrCmntCarrier varchar(14),  
@mstrOtherInstructions varchar(40),  
@mstrCmntTyping_dbver varchar(40),  
@mbitCmntTyping_OnDisk bit,  
@mbitValidated_flg bit,  
@mdatValidated datetime,  
@mbitFormGenRelease bit,  
@mbitDynamic bit,  
@mbitLayoutValid bit,  
@IDKey int OUTPUT,
@Contract varchar(9) = NULL
AS  
BEGIN TRANSACTION  
	INSERT INTO Survey_Def  
	(Study_id, strSurvey_nm,  
	 strSurvey_dsc, intResponse_recalc_period,  
	 intResurvey_period, bitRepeatingEncounters_flg,  
	 bitPhysAssist_name_flg, bitMinor_except_flg,  
	 bitNewborn_flg, bitDoHousehold, datSurvey_start_dt,  
	 datSurvey_end_dt, strMailFreq, intSamplesInPeriod,   
	 strXmitRoute, bitUseComments,   
	 strCmntCopyType, strCmntSort, bitSendCmntOut,  
	 strSpecialInstructions, strCmntMailFreq,   
	 strCmntCarrier, strOtherInstructions,   
	 strCmntTyping_dbver, bitCmntTyping_OnDisk,   
	 bitValidated_flg, datValidated, bitFormGenRelease,   
	 bitDynamic, bitLayoutValid, Contract)  
	VALUES  
	(@mintStudy_id,  
	@mstrSurvey_nm,  
	@mstrSurvey_dsc,  
	@mintResponse_recalc_period,  
	@mintResurvey_period,  
	@mbitRepeatingEncounters_flg,  
	@mbitPhysAssist_name_flg,  
	@mbitMinor_except_flg,  
	@mbitNewborn_flg,  
	@mbitDoHousehold,  
	@mdatSurvey_start_dt,  
	@mdatSurvey_end_dt,  
	@mstrMailFreq,  
	@mintSamplesInPeriod,   
	@mstrXmitRoute,  
	@mbitUseComments,   
	@mstrCmntCopyType,  
	@mstrCmntSort ,  
	@mbitSendCmntOut,  
	@mstrSpecialInstructions,  
	@mstrCmntMailFreq,   
	@mstrCmntCarrier,  
	@mstrOtherInstructions,   
	@mstrCmntTyping_dbver,  
	@mbitCmntTyping_OnDisk,   
	@mbitValidated_flg,  
	@mdatValidated,  
	@mbitFormGenRelease,  
	@mbitDynamic,  
	@mbitLayoutValid,
	@Contract)  

	SELECT @IDKey = SCOPE_IDENTITY()  

COMMIT TRANSACTION


