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


