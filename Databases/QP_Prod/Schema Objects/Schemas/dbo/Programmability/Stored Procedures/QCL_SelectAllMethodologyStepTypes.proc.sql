CREATE PROCEDURE dbo.QCL_SelectAllMethodologyStepTypes  
AS  
  
SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
SELECT	MethodologyStepTypeId,bitSurveyInLine,bitSendSurvey,bitThankYouItem,strMailingStep_nm,
		MailingStepMethod_id,CoverLetterRequired,ExpireInDays,Quota_ID,QuotaStopCollectionAt,
		DaysInField,NumberOfAttempts,WeekDay_Day_Call,WeekDay_Eve_Call,Sat_Day_Call,Sat_Eve_Call,
		Sun_Day_Call,Sun_Eve_Call,CallBackOtherLang,CallbackUsingTTY,AcceptPartial,SendEmailBlast 
FROM MethodologyStepType  
ORDER BY strMailingStep_nm


