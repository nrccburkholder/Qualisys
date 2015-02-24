/*

S19 US20 Add three ICH more methodologies.

Tim Butler

20.1	alter table [dbo].[StandardMethodologybySurveyType] add expired (QP_PROD)
20.2	Insert new methodologies
20.3	ALTER PROCEDURE [dbo].[QCL_SelectStandardMethodologiesBySurveyTypeId]

*/



use [QP_Prod]
go
begin tran
go
if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'StandardMethodologybySurveyType' 
					   AND sc.NAME = 'bitExpired' )

	alter table [dbo].[StandardMethodologybySurveyType] add bitExpired bit
go

commit tran
go


use qp_prod
go

DECLARE @SurveyType_desc varchar(100)
DECLARE @SurveyType_ID int
DECLARE @SeededMailings bit
DECLARE @SeedSurveyPercent int
DECLARE @SeedUnitField varchar(42)
DECLARE @Country_id int


SET @SurveyType_desc = 'ICHCAHPS'
SET @SeededMailings = 0
SET @SeedSurveyPercent = NULL
SET @SeedUnitField = NULL

begin tran

/*
	Methodologies
*/

declare @StandardMethodologyID int
declare @StandardMailingStepID int

declare @StandardMethodology_nm varchar(50)
declare @MethodologyType varchar(30)

SET @StandardMethodology_nm = ''
SET @MethodologyType = ''

if not exists (select 1 
			  from StandardMethodology 
			  where strStandardMethodology_nm = @StandardMethodology_nm
			  and MethodologyType = @MethodologyType)
begin
	insert into standardmethodology (strStandardMethodology_nm, bitCustom, MethodologyType)
	values (@StandardMethodology_nm, 0, @MethodologyType)

	set @StandardMethodologyID=scope_identity()

	insert into standardmethodologybysurveytype (StandardMethodologyID, SurveyType_id, SubType_ID) values (@StandardMethodologyID, @SurveyType_ID, 0)

	insert into standardmailingstep (StandardMethodologyID, intSequence, bitSurveyInLine, bitSendSurvey, intIntervalDays, bitThankYouItem, strMailingStep_nm, bitFirstSurvey, MailingStepMethod_id, ExpireInDays, ExpireFromStep, Quota_ID, QuotaStopCollectionAt, DaysInField, NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call, Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang, CallbackUsingTTY, AcceptPartial, SendEmailBlast)
	values (@StandardMethodologyID, 1, 0, 1, 0, 0, '1st Survey', 1, 0, 84, -1, null, null, null, null, null, null, null, null, null, null, null, null, null, null)

	set @StandardMailingStepID = scope_identity()

	insert into standardmailingstep (StandardMethodologyID, intSequence, bitSurveyInLine, bitSendSurvey, intIntervalDays, bitThankYouItem, strMailingStep_nm, bitFirstSurvey, MailingStepMethod_id, ExpireInDays, ExpireFromStep, Quota_ID, QuotaStopCollectionAt, DaysInField, NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call, Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang, CallbackUsingTTY, AcceptPartial, SendEmailBlast)
	values (@StandardMethodologyID, 2, 0, 1, 18, 0, '2nd Survey', 0, 0, 84, -1, null, null, null, null, null, null, null, null, null, null, null, null, null, null)

	update StandardMailingStep set ExpireFromStep=@StandardMailingStepID where ExpireFromStep=-1

end


SET @StandardMethodology_nm = ''
SET @MethodologyType = ''

if not exists (select 1 
			  from StandardMethodology 
			  where strStandardMethodology_nm = @StandardMethodology_nm
			  and MethodologyType = @MethodologyType)
begin
	insert into standardmethodology (strStandardMethodology_nm, bitCustom, MethodologyType)
	values (@StandardMethodology_nm, 0, @MethodologyType)

	set @StandardMethodologyID=scope_identity()

	insert into standardmethodologybysurveytype (StandardMethodologyID, SurveyType_id, SubType_ID) values (@StandardMethodologyID, @SurveyType_ID, 0)

	insert into standardmailingstep (StandardMethodologyID, intSequence, bitSurveyInLine, bitSendSurvey, intIntervalDays, bitThankYouItem, strMailingStep_nm, bitFirstSurvey, MailingStepMethod_id, ExpireInDays, ExpireFromStep, Quota_ID, QuotaStopCollectionAt, DaysInField, NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call, Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang, CallbackUsingTTY, AcceptPartial, SendEmailBlast)
	values (@StandardMethodologyID, 1, 0, 1, 0, 0, '1st Survey', 1, 0, 84, -1, null, null, null, null, null, null, null, null, null, null, null, null, null, null)

	set @StandardMailingStepID = scope_identity()

	insert into standardmailingstep (StandardMethodologyID, intSequence, bitSurveyInLine, bitSendSurvey, intIntervalDays, bitThankYouItem, strMailingStep_nm, bitFirstSurvey, MailingStepMethod_id, ExpireInDays, ExpireFromStep, Quota_ID, QuotaStopCollectionAt, DaysInField, NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call, Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang, CallbackUsingTTY, AcceptPartial, SendEmailBlast)
	values (@StandardMethodologyID, 2, 0, 1, 7, 0, 'Reminder', 0, 0, 84, @StandardMailingStepID, null, null, null, null, null, null, null, null, null, null, null, null, null, null)


	insert into standardmailingstep (StandardMethodologyID, intSequence, bitSurveyInLine, bitSendSurvey, intIntervalDays, bitThankYouItem, strMailingStep_nm, bitFirstSurvey, MailingStepMethod_id, ExpireInDays, ExpireFromStep, Quota_ID, QuotaStopCollectionAt, DaysInField, NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call, Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang, CallbackUsingTTY, AcceptPartial, SendEmailBlast)
	values (@StandardMethodologyID, 3, 0, 1, 18, 0, '2nd Survey', 0, 0, 84, -1, null, null, null, null, null, null, null, null, null, null, null, null, null, null)

	update StandardMailingStep set ExpireFromStep=@StandardMailingStepID where ExpireFromStep=-1

end
commit tran


go


USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_SelectStandardMethodologiesBySurveyTypeId]    Script Date: 2/24/2015 11:22:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[QCL_SelectStandardMethodologiesBySurveyTypeId]
 @SurveyTypeID INT,
 @SubType_Id INT = NULL
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

IF @SubType_Id is NULL
	SELECT sm.StandardMethodologyId, sm.strStandardMethodology_nm, sm.bitCustom, smst.bitExpired
	FROM StandardMethodology sm 
	INNER JOIN StandardMethodologyBySurveyType smst ON smst.StandardMethodologyID=sm.StandardMethodologyID
	WHERE smst.SurveyType_id=@SurveyTypeID
	ORDER BY sm.strStandardMethodology_nm
ELSE
	SELECT sm.StandardMethodologyId, sm.strStandardMethodology_nm, sm.bitCustom, smst.bitExpired
	FROM StandardMethodology sm 
	INNER JOIN StandardMethodologyBySurveyType smst ON smst.StandardMethodologyID=sm.StandardMethodologyID
	WHERE smst.SurveyType_id=@SurveyTypeID
	AND smst.SubType_ID = @SubType_Id
	ORDER BY sm.strStandardMethodology_nm

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO