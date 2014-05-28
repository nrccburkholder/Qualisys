CREATE PROCEDURE QP_Rep_VACutoffDates 
	@Associate 	VARCHAR(42),
	@Client 	VARCHAR(42),
	@Study		VARCHAR(42),
	@Survey		VARCHAR(42),
	@SampleSet	VARCHAR(42)
AS

DECLARE @SampleSetID INT, @SurveyID INT

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT @SurveyID=Survey_id
FROM Client c(NOLOCK), Study s(NOLOCK), Survey_def sd(NOLOCK)
WHERE c.strClient_nm=@Client
AND c.Client_id=s.Client_id
AND s.strStudy_nm=@Study
AND s.Study_id=sd.Study_id
AND sd.strSurvey_nm=@Survey

SELECT @SampleSetID=SampleSet_id
FROM SampleSet(NOLOCK)
WHERE Survey_id=@SurveyID
AND ABS(DATEDIFF(SECOND,datSampleCreate_dt,CONVERT(DATETIME,@SampleSet)))<1

SELECT SampleSet_id, ms.MailingStep_id, strMailingStep_nm, CONVERT(DATETIME,CONVERT(VARCHAR(10),datMailed,120)) datMailed, datExpire, COUNT(*) OutGo
FROM SamplePop sp(NOLOCK), ScheduledMailing schm(NOLOCK), SentMailing sm(NOLOCK), MailingStep ms(NOLOCK)
WHERE sp.SampleSet_id=@SampleSetID
AND sp.SamplePop_id=schm.SamplePop_id
AND schm.SentMail_id=sm.SentMail_id
AND schm.MailingStep_id=ms.MailingStep_id
GROUP BY SampleSet_id, ms.MailingStep_id, strMailingStep_nm, CONVERT(DATETIME,CONVERT(VARCHAR(10),datMailed,120)), datExpire
ORDER BY 1,2,3,4

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF


