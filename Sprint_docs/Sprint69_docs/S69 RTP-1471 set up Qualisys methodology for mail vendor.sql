/*

S69 RTP-1471 set up Qualisys methodology for mail vendor.sql

Chris Burkholder

February 23, 2017

INSERT MAILINGSTEPMETHOD
INSERT STANDARDMETHODOLOGY
INSERT STANDARDMETHODOLOGYBYSURVEYTYPE
INSERT METHODOLOGYSTEPTYPE
INSERT STANDARDMAILINGSTEP

*/

USE [QP_Prod]
GO

BEGIN TRAN

delete from StandardMailingStep where strMailingStep_nm in ('1st Svy Vendor Mail','2nd Svy Vendor Mail')
delete from MethodologyStepType where strMailingStep_nm in ('1st Svy Vendor Mail','2nd Svy Vendor Mail')
delete from StandardMethodologyBySurveyType where StandardMethodologyID in (select StandardMethodologyID from StandardMethodology where strStandardMethodology_nm='HCAHPS + RT Mail Only')
delete from StandardMethodology where strStandardMethodology_nm='HCAHPS + RT Mail Only'
delete from MAILINGSTEPMETHOD where MailingStepMethod_nm='Vendor Mail'

declare @maxseed int

select @maxseed=max(MailingStepMethod_id) from MAILINGSTEPMETHOD
DBCC CHECKIDENT ('dbo.MAILINGSTEPMETHOD', RESEED, @maxseed);  

INSERT INTO [dbo].[MAILINGSTEPMETHOD]
			(MailingStepMethod_nm,CreateDataFileAtGeneration,IsNonMailGeneration)
	VALUES('Vendor Mail',1,1)

declare @VendorMailMailingStep int = IDENT_CURRENT('dbo.MailingStepMethod')

select @maxseed=max(StandardMethodologyID) from StandardMethodology
DBCC CHECKIDENT ('dbo.StandardMethodology', RESEED, @maxseed);  

INSERT INTO [dbo].[StandardMethodology]
           ([strStandardMethodology_nm],[bitCustom],[MethodologyType])
     VALUES ('HCAHPS + RT Mail Only',0,'Mail Only')

declare @VendorMailStandardMethodology int = IDENT_CURRENT('dbo.StandardMethodology')

declare @HCAHPSRTSubtype int = null

select @HCAHPSRTSubtype = st.SubType_id 
from SubType st inner join SurveyTypeSubType stst on st.Subtype_id = stst.Subtype_id
where Subtype_nm = 'RT' and stst.SurveyType_id = 2

INSERT INTO [dbo].[StandardMethodologyBySurveyType]
           ([StandardMethodologyID],[SurveyType_id],[SubType_ID],[bitExpired])
     VALUES (@VendorMailStandardMethodology,2,@HCAHPSRTSubType,0)

select @maxseed=max(MethodologyStepTypeId) from MethodologyStepType
DBCC CHECKIDENT ('dbo.MethodologyStepType', RESEED, @maxseed);  

INSERT INTO [dbo].[MethodologyStepType]
			(bitSurveyInLine,bitSendSurvey,bitThankYouItem,strMailingStep_nm,MailingStepMethod_id,CoverLetterRequired,ExpireInDays)
	VALUES(0,1,0,'1st Svy Vendor Mail',@VendorMailMailingStep,0,42),
		(0,1,0,'2nd Svy Vendor Mail',@VendorMailMailingStep,0,42)

select @maxseed=max(StandardMailingStepID) from StandardMailingStep
DBCC CHECKIDENT ('dbo.StandardMailingStep', RESEED, @maxseed);  

INSERT INTO [dbo].[StandardMailingStep]
			(StandardMethodologyID,intSequence,bitSurveyInLine,bitSendSurvey,intIntervalDays,bitThankYouItem,strMailingStep_nm,
			bitFirstSurvey,OverRide_Langid,MMMailingStep_id,MailingStepMethod_id,ExpireInDays,ExpireFromStep)
	VALUES(@VendorMailStandardMethodology,1,0,1,0,0,'1st Svy Vendor Mail',
			1,NULL,NULL,@VendorMailMailingStep,42,-1),
		(@VendorMailStandardMethodology,2,0,1,21,0,'2nd Svy Vendor Mail',
			0,NULL,NULL,@VendorMailMailingStep,42,-1)

declare @NewStandardMailingStepOne int = IDENT_CURRENT('dbo.StandardMailingStep') - 1

UPDATE [dbo].[StandardMailingStep] 
	set ExpireFromStep = @NewStandardMailingStepOne,
		Quota_ID = NULL,QuotaStopCollectionAt = NULL,DaysInField = NULL,
		NumberOfAttempts = NULL,WeekDay_Day_Call = NULL,WeekDay_Eve_Call = NULL,
		Sat_Day_Call = NULL,Sat_Eve_Call = NULL,Sun_Day_Call = NULL,
		Sun_Eve_Call = NULL,CallBackOtherLang = NULL,CallbackUsingTTY = NULL,
		AcceptPartial = NULL,SendEmailBlast = NULL,ExcludePII = NULL
	where StandardMailingStepID >= @NewStandardMailingStepOne
	and ExpireFromStep = -1

select * from StandardMethodology where StandardMethodologyID = @VendorMailStandardMethodology
select * from StandardMethodologyBySurveyType where StandardMethodologyID = @VendorMailStandardMethodology
select * from MethodologyStepType 
select * from StandardMailingStep where StandardMethodologyID = @VendorMailStandardMethodology
select * from MailingStepMethod 

COMMIT TRAN

GO