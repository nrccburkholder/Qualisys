/*
S51 ATL-425 Survey level setting for switchover - Rollback.sql

Chris Burkholder

ALTER TABLE MAILINGSTEP
ALTER PROCEDURE QCL_InsertMethodologyStep
ALTER PROCEDURE QCL_SelectMethodologyStep
ALTER PROCEDURE QCL_SelectMethodologyStepsByMethodologyId

*/

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_InsertMethodologyStep]    Script Date: 6/9/2016 3:27:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectMethodologyStep]    Script Date: 6/9/2016 3:28:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[QCL_SelectMethodologyStep]
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

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectMethodologyStepsByMethodologyId]    Script Date: 6/9/2016 3:29:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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

USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_SelectAllMethodologyStepTypes]    Script Date: 6/9/2016 4:48:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[QCL_SelectAllMethodologyStepTypes]  
AS  
  
SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
SELECT	MethodologyStepTypeId,bitSurveyInLine,bitSendSurvey,bitThankYouItem,strMailingStep_nm,
		MailingStepMethod_id,CoverLetterRequired,ExpireInDays,Quota_ID,QuotaStopCollectionAt,
		DaysInField,NumberOfAttempts,WeekDay_Day_Call,WeekDay_Eve_Call,Sat_Day_Call,Sat_Eve_Call,
		Sun_Day_Call,Sun_Eve_Call,CallBackOtherLang,CallbackUsingTTY,AcceptPartial,SendEmailBlast
FROM MethodologyStepType  
ORDER BY strMailingStep_nm

GO

USE [QP_Prod]
GO

ALTER TABLE MAILINGSTEP
DROP COLUMN ExcludePII 
GO

ALTER TABLE METHODOLOGYSTEPTYPE
DROP COLUMN ExcludePII 
GO
