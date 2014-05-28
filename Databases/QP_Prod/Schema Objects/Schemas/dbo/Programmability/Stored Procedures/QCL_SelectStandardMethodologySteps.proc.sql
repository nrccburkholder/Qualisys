CREATE PROCEDURE [dbo].[QCL_SelectStandardMethodologySteps]
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


