CREATE PROCEDURE QP_Rep_GenerationPlan_new
  @Days INT,
  @ReportingLevel VARCHAR(20) = 'Detail'
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

IF @reportinglevel = 'Count Only'
BEGIN

	CREATE TABLE #temp (release CHAR(1), sentmail_id INT)

	INSERT INTO #temp
	 SELECT bitFormGenRelease, sentmail_id
	 FROM   Survey_def SD(NOLOCK), ScheduledMailing SM(NOLOCK), mailingstep ms(NOLOCK)
	 WHERE  SM.SentMail_id IS NULL AND
	        SM.datGenerate <= DATEADD(DAY,2,GETDATE()) AND
	        MS.Survey_id = SD.Survey_id AND
	        SM.mailingstep_id = MS.mailingstep_id

	SELECT CASE release WHEN 1 THEN 'Released' ELSE 'On Hold' END, COUNT(*)
	FROM #temp
	GROUP BY CASE release WHEN 1 THEN 'Released' ELSE 'On Hold' END

	DROP TABLE #temp

END

ELSE
BEGIN

	 SELECT c.strClient_nm AS Client, s.strStudy_nm AS Study, SD.Study_id AS StudyID, sd.strsurvey_nm AS Survey, SD.Survey_id AS SurveyID, SP.SampleSet_id AS SampleSet, 
		ms.strmailingstep_nm AS MailingStep, MM.strMethodology_nm AS Methodology, sm.datgenerate AS Dategenerate, count(*) AS Cnt, 
		ss.datDateRange_FromDate AS FromDate, ss.datDateRange_ToDate AS ToDate
	 FROM   Survey_def SD(NOLOCK), SamplePop SP(NOLOCK), SampleSET SS(NOLOCK), ScheduledMailing SM(NOLOCK), MailingMethodology MM(NOLOCK), mailingstep ms(NOLOCK), study s(NOLOCK), client c(NOLOCK)
	 WHERE  sd.study_id=s.study_id AND
	        s.client_id=c.client_id AND 
	        SP.SamplePop_id = SM.SamplePop_id AND
		SP.SampleSet_ID = SS.SampleSet_ID AND
	        SM.SentMail_id IS NULL AND
	        SM.datGenerate <= DATEADD(DAY,@Days,GETDATE()) AND
	        SD.bitFormGenRelease = 1 AND
	        MM.Methodology_id = SM.Methodology_id AND
	        MM.Survey_id = SD.Survey_id AND
	        sm.mailingstep_id=ms.mailingstep_id
	 GROUP BY c.strClient_nm, s.strStudy_nm, sd.strsurvey_nm, SD.Study_id, SD.Survey_id, SP.SampleSet_id, ms.strmailingstep_nm, MM.strMethodology_nm, sm.datgenerate, ss.datdaterange_fromdate, ss.datDateRange_ToDate
	 ORDER BY sm.datgenerate

END

SET TRANSACTION ISOLATION LEVEL READ COMMITTED


