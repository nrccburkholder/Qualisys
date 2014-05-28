CREATE PROCEDURE QP_Rep_GenerationPlan    
  @Days INT,    
  @ReportingLevel VARCHAR(20) = 'Detail'    
AS    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
    
IF @reportinglevel = 'Count Only'    
BEGIN    
    
 CREATE TABLE #temp (generate varchar(10), release CHAR(1), sentmail_id INT)    
    
 INSERT INTO #temp    
  SELECT CONVERT(VARCHAR(10),datgenerate,120), bitFormGenRelease, sentmail_id    
  FROM   Survey_def SD(NOLOCK), ScheduledMailing SM(NOLOCK), mailingstep ms(NOLOCK)    
  WHERE  SM.SentMail_id IS NULL AND    
         SM.datGenerate <= DATEADD(DAY,@Days,GETDATE()) AND    
         MS.Survey_id = SD.Survey_id AND    
         SM.mailingstep_id = MS.mailingstep_id    
    
 UPDATE #temp SET generate = convert(varchar(10),dateadd(day,1,getdate()),120) where convert(datetime,generate) < dateadd(day,1,getdate())    
    
 SELECT generate, CASE release WHEN 1 THEN 'Released' ELSE 'OnHold' END Status, COUNT(*) Amount    
 into #summary    
 FROM #temp    
 GROUP BY generate, CASE release WHEN 1 THEN 'Released' ELSE 'OnHold' END    
    
 SELECT DISTINCT generate INTO #columns FROM #summary    
    
 CREATE TABLE #display (Status VARCHAR(10))    
    
 INSERT INTO #display (status)    
 SELECT 'Released'    
 INSERT INTO #display (status)    
 SELECT 'OnHold'    
    
 DECLARE @column VARCHAR(10), @sql VARCHAR(200)    
    
 WHILE (SELECT COUNT(*) FROM #columns) > 0    
  BEGIN    
    
   SET @column = (SELECT TOP 1 generate FROM #columns ORDER BY CONVERT(DATETIME,generate))    
    
   DELETE #columns WHERE generate = @column    
    
   SET @sql = 'ALTER TABLE #display ADD [' + @column + '] INT'    
    
   EXEC (@sql)    
    
  END    
    
 INSERT INTO #columns    
 SELECT DISTINCT generate     
 FROM #summary    
    
 WHILE (SELECT COUNT(*) FROM #columns) > 0    
  BEGIN    
    
   SET @column = (SELECT TOP 1 generate FROM #columns ORDER BY CONVERT(DATETIME,generate))    
    
   DELETE #columns WHERE generate = @column    
    
   SET @sql = 'UPDATE t SET t.[' + @column + '] = s.amount FROM #display t, #summary s WHERE s.generate = ''' + @column + ''' AND s.status = t.status'    
    
   EXEC (@sql)    
    
  END    
    
 SELECT * FROM #Display    
    
 DROP TABLE #Display    
 DROP TABLE #Temp    
 DROP TABLE #Summary    
 DROP TABLE #Columns    
    
END    
    
ELSE    
BEGIN    
    
--   SELECT c.strClient_nm AS Client, s.strStudy_nm AS Study, SD.Study_id AS StudyID, sd.strsurvey_nm AS Survey, SD.Survey_id AS SurveyID, SP.SampleSet_id AS SampleSet,     
--   ms.strmailingstep_nm AS MailingStep, MM.strMethodology_nm AS Methodology, sm.datgenerate AS Dategenerate, count(*) AS Cnt,     
--   ss.datDateRange_FromDate AS FromDate, ss.datDateRange_ToDate AS ToDate    
--   FROM   Survey_def SD(NOLOCK), SamplePop SP(NOLOCK), SampleSET SS(NOLOCK), ScheduledMailing SM(NOLOCK), MailingMethodology MM(NOLOCK), mailingstep ms(NOLOCK), study s(NOLOCK), client c(NOLOCK)    
--   WHERE  sd.study_id=s.study_id AND    
--          s.client_id=c.client_id AND     
--          SP.SamplePop_id = SM.SamplePop_id AND    
--   SP.SampleSet_ID = SS.SampleSet_ID AND    
--          SM.SentMail_id IS NULL AND    
--          SM.datGenerate <= DATEADD(DAY,@Days,GETDATE()) AND    
--          SD.bitFormGenRelease = 1 AND    
--          MM.Methodology_id = SM.Methodology_id AND    
--          MM.Survey_id = SD.Survey_id AND    
--          sm.mailingstep_id=ms.mailingstep_id    
--   GROUP BY c.strClient_nm, s.strStudy_nm, sd.strsurvey_nm, SD.Study_id, SD.Survey_id, SP.SampleSet_id, ms.strmailingstep_nm, MM.strMethodology_nm, sm.datgenerate, ss.datdaterange_fromdate, ss.datDateRange_ToDate    
--   ORDER BY sm.datgenerate    
  
  
CREATE TABLE #DisplayDetail (Status VARCHAR(10), Client VARCHAR(50), Study CHAR(50), StudyID INT, Survey CHAR(50), SurveyID INT, SampleSet INT, MailingStep VARCHAR(50), Methodology VARCHAR(42), Dategenerate DATETIME, Cnt INT, FromDate DATETIME, ToDate DATETIME)  
  
-- Released surveys  
INSERT INTO #DisplayDetail (Status, Client, Study, StudyID, Survey, SurveyID, SampleSet, MailingStep, Methodology, Dategenerate, Cnt, FromDate, ToDate)  
  SELECT 'Released' AS Status, c.strClient_nm AS Client, s.strStudy_nm AS Study, SD.Study_id AS StudyID, sd.strsurvey_nm AS Survey, SD.Survey_id AS SurveyID, SP.SampleSet_id AS SampleSet,     
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
  
-- Whitespace Break  
INSERT INTO #DisplayDetail (Status, Client, Study, StudyID, Survey, SurveyID, SampleSet, MailingStep, Methodology, Dategenerate, Cnt, FromDate, ToDate)  
 SELECT '','','',NULL,'',NULL,NULL,'','',NULL,0,NULL,NULL  
  
-- Surveys OnHold  
INSERT INTO #DisplayDetail (Status, Client, Study, StudyID, Survey, SurveyID, SampleSet, MailingStep, Methodology, Dategenerate, Cnt, FromDate, ToDate)  
  SELECT 'OnHold' AS Status, c.strClient_nm AS Client, s.strStudy_nm AS Study, SD.Study_id AS StudyID, sd.strsurvey_nm AS Survey, SD.Survey_id AS SurveyID, SP.SampleSet_id AS SampleSet,     
  ms.strmailingstep_nm AS MailingStep, MM.strMethodology_nm AS Methodology, sm.datgenerate AS Dategenerate, count(*) AS Cnt,     
  ss.datDateRange_FromDate AS FromDate, ss.datDateRange_ToDate AS ToDate    
  FROM   Survey_def SD(NOLOCK), SamplePop SP(NOLOCK), SampleSET SS(NOLOCK), ScheduledMailing SM(NOLOCK), MailingMethodology MM(NOLOCK), mailingstep ms(NOLOCK), study s(NOLOCK), client c(NOLOCK)    
  WHERE  sd.study_id=s.study_id AND    
         s.client_id=c.client_id AND     
         SP.SamplePop_id = SM.SamplePop_id AND    
  SP.SampleSet_ID = SS.SampleSet_ID AND    
         SM.SentMail_id IS NULL AND    
         SM.datGenerate <= DATEADD(DAY,@Days,GETDATE()) AND    
         SD.bitFormGenRelease = 0 AND    
         MM.Methodology_id = SM.Methodology_id AND    
         MM.Survey_id = SD.Survey_id AND    
         sm.mailingstep_id=ms.mailingstep_id    
  GROUP BY c.strClient_nm, s.strStudy_nm, sd.strsurvey_nm, SD.Study_id, SD.Survey_id, SP.SampleSet_id, ms.strmailingstep_nm, MM.strMethodology_nm, sm.datgenerate, ss.datdaterange_fromdate, ss.datDateRange_ToDate    
  ORDER BY sm.datgenerate    
  
SELECT * FROM #DisplayDetail  
DROP TABLE #DisplayDetail     
  
END    
    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


