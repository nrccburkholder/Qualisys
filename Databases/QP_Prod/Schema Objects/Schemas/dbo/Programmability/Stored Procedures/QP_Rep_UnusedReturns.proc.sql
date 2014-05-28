CREATE PROCEDURE QP_Rep_UnusedReturns @Associate VARCHAR(20), @FirstDay DATETIME, @LastDay DATETIME  
AS  
  
-- DECLARE @FirstDay DATETIME, @LastDay DATETIME  
-- SELECT @FirstDay = '3/25/2005', @LastDay = '3/25/2005'  
  
SET @FirstDay = CONVERT(DATETIME,CONVERT(VARCHAR,@FirstDay,101))  
SET @LastDay = CONVERT(DATETIME,CONVERT(VARCHAR,@LastDay,101) + ' 23:59:59.997')  
  
-- GET DATA  
SELECT css.strClient_nm Client, css.strStudy_nm Study, css.strSurvey_nm Survey, sm.strlithocode Litho, CONVERT(VARCHAR,datUnusedReturn,101) AS 'Unused Date',  
CASE   
 WHEN qf.UnusedReturn_id = 0 THEN 'Undefined        (0)'     -- 'Undefined-0'  
 WHEN qf.UnusedReturn_id = 1 THEN 'Another MailStep (1)'-- 'Another mailing step was returndd'  
 WHEN qf.UnusedReturn_id = 2 THEN 'Survey Expired   (2)'  -- 'Returned after expiration'  
 WHEN qf.UnusedReturn_id = 3 THEN 'Already Scanned  (3)' -- 'Questionaire already scanned'  
 WHEN qf.UnusedReturn_id = 4 THEN 'QuestionResult2  (4)' -- 'Results stored in Questionresult2'  
 WHEN qf.UnusedReturn_id =88 THEN 'Undefined       (88)'  -- 'Undefined-88'  
 ELSE 'Undefined'  
END AS 'Unused Reason',  
css.client_id, css.study_id, qf.survey_id, qf.UnusedReturn_id  
INTO #WORK  
FROM questionform qf (NOLOCK), sentmailing sm (NOLOCK), clientstudysurvey_view css (NOLOCK)  
WHERE qf.sentmail_id = sm.sentmail_id AND  qf.survey_id = css.survey_id and sm.methodology_id = css.methodology_Id  
AND datunusedreturn BETWEEN @FirstDay AND @LastDay  
AND unusedreturn_id IS NOT NULL  
AND datunusedreturn IS NOT NULL  
ORDER BY qf.unusedreturn_id, css.client_id, css.study_id, css.survey_id  
  
-- ADD TOTAL TO DATA  
SELECT 'Total Unused Returns = ' + Convert(VARCHAR,COUNT(*)) Client , NULL Study, NULL Survey, NULL Litho, NULL 'Unused Date',  
 NULL  'Unused Reason', NULL client_id, NULL study_id, NULL survey_id, NULL UnusedReturn_id  
 FROM #WORK  
UNION ALL  
 SELECT NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL  
UNION ALL  
 SELECT Client, Study, Survey, Litho, [Unused Date], [Unused Reason], client_id, study_id, survey_id, unusedreturn_id FROM #WORK  
  
DROP TABLE #WORK


