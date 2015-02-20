set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[QCL_SelectStandardMethodologySteps]
 @StandardMethodologyId INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT StandardMailingStepId, StandardMethodologyID,intSequence,bitSurveyInLine,bitSendSurvey,
       intIntervalDays,bitThankYouItem,strMailingStep_nm,bitFirstSurvey,
       OverRide_Langid,MMMailingStep_id,MailingStepMethod_id,ExpireInDays,
       ExpireFromStep, Quota_ID, QuotaStopCollectionAt, DaysInField,
       NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call,
       Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang,
       CallbackUsingTTY, AcceptPartial, SendEmailBlast
FROM StandardMailingStep
WHERE StandardMethodologyID=@StandardMethodologyID 
ORDER BY intSequence

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[QCL_SelectMethodologyStepsByMethodologyId]
@MethodologyId INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT MailingStep_id, strMailingStep_nm, Methodology_id, Survey_id, intSequence, 
		SelCover_id, intIntervalDays, bitSendSurvey, bitThankYouItem, bitFirstSurvey, 
		Override_Langid, MMMailingStep_id, MailingStepMethod_id, ExpireInDays,
		ExpireFromStep, Quota_ID, QuotaStopCollectionAt, DaysInField,
		NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call,
		Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang,
		CallbackUsingTTY, AcceptPartial, SendEmailBlast, Vendor_ID
FROM MailingStep
WHERE Methodology_id=@MethodologyId
ORDER BY intSequence

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[QCL_InsertMethodologyStep]
@MethodologyId INT,
@SurveyId INT,
@SequenceNumber INT,
@CoverLetterId INT,
@IsSurvey BIT,
@DaysSincePreviousStep INT,
@IsThankYouLetter BIT,
@Name VARCHAR(42),
@IsFirstSurvey BIT,
@OverrideLanguageId INT,
@LinkedStepId INT,
@StepMethodId INT,
@ExpirationDays INT,
@ExpireFromStepId INT,
@QuotaId INT,
@QuotaStopCollectionAt INT,
@DaysInField INT,
@NumberOfAttempts INT,
@WeekDayDayCall BIT,
@WeekDayEveCall BIT,
@SatDayCall BIT,
@SatEveCall BIT,
@SunDayCall BIT,
@SunEveCall BIT,
@CallBackOtherLang BIT,
@CallbackUsingTTY BIT,
@AcceptPartial BIT,
@SendEmailBlast BIT,
@VendorID INT

AS

DECLARE @NewId INT

INSERT INTO MailingStep (Methodology_id,Survey_id,intSequence,SelCover_id,
          bitSurveyInLine,bitSendSurvey,intIntervalDays,bitThankYouItem,
          strMailingStep_nm,bitFirstSurvey,Override_LangId,MMMailingStep_id,
          MailingStepMethod_id,ExpireInDays,ExpireFromStep,
          Quota_ID, QuotaStopCollectionAt, DaysInField,
          NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call,
          Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang,
          CallbackUsingTTY, AcceptPartial, SendEmailBlast, Vendor_ID)
SELECT @MethodologyId,@SurveyId,@SequenceNumber,@CoverLetterId,
          0,@IsSurvey,@DaysSincePreviousStep,@IsThankYouLetter,
          @Name,@IsFirstSurvey,@OverrideLanguageId,@LinkedStepId,
          @StepMethodId,@ExpirationDays,@ExpireFromStepId,
          @QuotaId, @QuotaStopCollectionAt, @DaysInField, @NumberOfAttempts,
          @WeekDayDayCall, @WeekDayEveCall, @SatDayCall, @SatEveCall,
          @SunDayCall, @SunEveCall, @CallBackOtherLang, @CallbackUsingTTY,
          @AcceptPartial, @SendEmailBlast, @VendorID


SELECT @NewId=SCOPE_IDENTITY()  

UPDATE MailingStep 
SET MMMailingStep_id=CASE @LinkedStepId WHEN 0 THEN NULL ELSE @LinkedStepId END,
    ExpireFromStep=CASE @ExpireFromStepId WHEN 0 THEN @NewID ELSE @ExpireFromStepId END
WHERE MailingStep_id=@NewId

SELECT @NewId

GO



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[QCL_DeleteMethodologyStepsByMethodologyId]
@MethodologyId INT
AS



DELETE VendorFile_VoviciDetails
WHERE MailingStep_ID IN
	(SELECT MailingStep_ID
	FROM MailingStep
	WHERE Methodology_id=@MethodologyId)

DELETE MM_EmailBlast
WHERE MailingStep_ID IN
	(SELECT MailingStep_ID
	FROM MailingStep
	WHERE Methodology_id=@MethodologyId)

DELETE MailingStep
WHERE Methodology_id=@MethodologyId

END

GO



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go
IF OBJECT_ID(N'[dbo].[QCL_UpdateMethodologyStepVendor]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QCL_UpdateMethodologyStepVendor]
GO
CREATE PROCEDURE [dbo].[QCL_UpdateMethodologyStepVendor]
@MailingStepID INT,
@VendorID INT
AS

UPDATE MailingStep
SET Vendor_ID = @VendorID
WHERE MailingStep_ID = @MailingStepID

GO



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go
IF OBJECT_ID(N'[dbo].[QCL_SelectMethodologyStep]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QCL_SelectMethodologyStep]
GO
CREATE PROCEDURE [dbo].[QCL_SelectMethodologyStep]
@MailingStepID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT MailingStep_id, strMailingStep_nm, Methodology_id, Survey_id, intSequence, 
		SelCover_id, intIntervalDays, bitSendSurvey, bitThankYouItem, bitFirstSurvey, 
		Override_Langid, MMMailingStep_id, MailingStepMethod_id, ExpireInDays,
		ExpireFromStep, Quota_ID, QuotaStopCollectionAt, DaysInField,
		NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call,
		Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang,
		CallbackUsingTTY, AcceptPartial, SendEmailBlast, Vendor_ID
FROM MailingStep
WHERE MailingStep_id=@MailingStepID
ORDER BY intSequence

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO
