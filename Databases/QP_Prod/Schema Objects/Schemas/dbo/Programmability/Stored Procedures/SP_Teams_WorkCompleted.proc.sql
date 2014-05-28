CREATE PROCEDURE SP_Teams_WorkCompleted    
AS    
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
    
--GET A LIST OF VALID SampleSetS    
SELECT Survey_id, SampleSet_id    
INTO #ValidSamples    
FROM SampleSet    
    
--DELETE ANY SampleSetS THAT ARE NO LONGER VALID    
DELETE wc    
FROM #ValidSamples t RIGHT OUTER JOIN TeamStatus_WorkCompleted wc    
ON t.Survey_id = wc.Surveyid    
AND t.SampleSet_id = wc.SampleSet    
WHERE t.SampleSet_id IS NULL    
    
SELECT SampleSet_id, Survey_id, datSampleCreate_dt, strSampleSurvey_nm     
INTO #SampleSets    
FROM SampleSet    
WHERE datSampleCreate_dt > DATEADD(MONTH,-2,GETDATE())    
AND datLastMailed IS NULL    
OR datLastMailed > DATEADD(DAY,-4,GETDATE())    
    
 CREATE TABLE #Sampled (    
   Dummy_id INT,    
   AcctDir VARCHAR(20),     
   strClient_nm VARCHAR (40),    
   Client_id INTEGER,    
   strStudy_nm CHAR (10),    
   Study_id INTEGER,    
   strSurvey_nm CHAR (10),    
   Survey_id INTEGER,    
   ProjectNumber VARCHAR(4),    
   MailFrequency CHAR(9),     
   ContractStart VARCHAR(10),     
   ContractEnd VARCHAR(10),    
   datSampleCreate_dt DATETIME,    
   Sampled CHAR(10),    
   DummySS_id INT)    
    
 INSERT #Sampled (AcctDir, strClient_nm, strStudy_nm, strSurvey_nm, Survey_id, datSampleCreate_Dt, Sampled, DummySS_id, Client_id, Study_id, ProjectNumber, MailFrequency, ContractStart, ContractEnd)    
 (SELECT AD.strNTLogin_nm, c.strClient_nm, s.strStudy_nm, sd.strSurvey_nm, ss.Survey_id,ss.datSampleCreate_dt, CONVERT(CHAR (10),COUNT(*)) AS Sampled, ss.SampleSet_id, c.Client_id, s.Study_id,    
 LEFT(strSampleSurvey_nm,4), strMailFreq, CONVERT(VARCHAR(10),datContractStart,120), CONVERT(VARCHAR(10),datContractEnd,120)    
  FROM #SampleSets ss(NOLOCK), Samplepop sp(NOLOCK), Survey_def sd(NOLOCK), Study s(NOLOCK), Client c(NOLOCK), Employee AD(NOLOCK)    
  WHERE s.ADEmployee_ID = ad.Employee_id    
    AND ss.SampleSet_id=sp.SampleSet_id    
    AND ss.Survey_id=sd.Survey_id    
    AND sd.Study_id=s.Study_id    
    AND s.Client_id=c.Client_id    
  GROUP BY AD.strNTLogin_nm, c.strClient_nm, s.strStudy_nm, sd.strSurvey_nm, ss.Survey_id,ss.datSampleCreate_dt,ss.SampleSet_id, c.Client_id, s.Study_id, ss.strSampleSurvey_nm,    
 sd.strMailFreq, s.datContractStart, s.datContractEnd)    
    
 DECLARE @i INTEGER    
 SELECT @i=(SELECT ISNULL(MAX(Dummy_id),0) FROM TeamStatus_WorkCompleted)    
 WHILE @@ROWCOUNT>0     
 BEGIN    
   SELECT @i=@i+1    
   UPDATE #Sampled    
   SET Dummy_id=@i    
   FROM (SELECT top 1 strClient_nm, strStudy_nm, strSurvey_nm, Survey_id, datSampleCreate_dt    
         FROM #Sampled    
         WHERE Dummy_id IS NULL    
         ORDER BY AcctDir, strClient_nm, strStudy_nm, strSurvey_nm, Survey_id, datSampleCreate_dt) sub    
   WHERE #Sampled.Survey_id=sub.Survey_id    
     AND #Sampled.datSampleCreate_dt=sub.datSampleCreate_dt         
 END    
    
 SELECT #Sampled.AcctDir, #Sampled.Client_id, #Sampled.Study_id, mm.Survey_id, #Sampled.datSampleCreate_dt, case when ms.bitfirstSurvey = 1 then '*'+ms.strMailingStep_nm else ms.strMailingStep_nm end strMailingStep_nm, ms.intSequence,    
    schm.datGenerate, sm.datGenerated, sm.datPrinted, sm.datMailed, 0 AS numGenerated, 0 AS numPrinted, 0 AS numMailed    
 INTO #ProdReport    
 FROM SentMailing SM(NOLOCK), ScheduledMailing schm(NOLOCK), MailingStep MS(NOLOCK), MailingMethodology MM(NOLOCK), Samplepop sp(NOLOCK), #Sampled (NOLOCK)    
 WHERE SM.ScheduledMailing_id=schm.ScheduledMailing_id    
   AND schm.MailingStep_id=MS.MailingStep_id    
   AND MS.Methodology_id=MM.Methodology_id    
   AND schm.Samplepop_id=sp.Samplepop_id    
   AND sp.SampleSet_id=#Sampled.DummySS_id    
    
 UPDATE #ProdReport SET numGenerated=1 WHERE datGenerated IS NOT NULL    
 UPDATE #ProdReport SET numPrinted=1 WHERE datPrinted IS NOT NULL    
 UPDATE #ProdReport SET numMailed=1 WHERE datMailed IS NOT NULL    
    
 SELECT s.Dummy_id, s.AcctDir, s.strClient_nm AS Client, CONVERT(CHAR(5),s.Client_id) AS ClientID,     
    s.strStudy_nm AS Study, CONVERT(CHAR(5),s.Study_id) AS StudyID, s.strSurvey_nm AS Survey,     
    CONVERT(CHAR(5),s.Survey_id) AS SurveyID, ProjectNumber, MailFrequency, ContractStart, ContractEnd, s.Sampled,    
DummySS_id AS SampleSet, CONVERT(VARCHAR,s.datSampleCreate_dt,100) AS [Sample Date], pr.intSequence AS Dummy_Step,     
    pr.strMailingStep_nm AS [Mailing Step],    
    CONVERT(VARCHAR,datGenerate,1) datGenerate,    
    CONVERT(VARCHAR,MIN(pr.datGenerated),1) AS [GENDate],     
    SUM(pr.numGenerated) AS Generated,     
    CONVERT(VARCHAR,MIN(pr.datPrinted),1) AS [PrintDate],     
    SUM(pr.numPrinted) AS Printed,    
    CONVERT(VARCHAR,MIN(pr.datMailed),1) AS [MailDate],     
    SUM(pr.numMailed) AS Mailed    
INTO #Completed    
 FROM #Sampled s, #ProdReport pr    
 WHERE s.Survey_id=pr.Survey_id AND s.datSampleCreate_dt=pr.datSampleCreate_dt    
 GROUP BY s.Dummy_id,s.AcctDir, s.strClient_nm,s.strStudy_nm,s.strSurvey_nm,s.Sampled,s.DummySS_id,s.datSampleCreate_dt,pr.intSequence,     
          pr.strMailingStep_nm, s.Client_id, s.Study_id, s.Survey_id, CONVERT(VARCHAR,datGenerate,1), s.ProjectNumber,     
   s.MailFrequency, s.ContractStart, s.ContractEnd    
 ORDER BY s.Dummy_id,pr.intSequence    
    
DELETE wc    
FROM TeamStatus_WorkCompleted wc, #SampleSets t    
WHERE t.sampleset_id = wc.sampleset    
    
INSERT INTO TeamStatus_WorkCompleted (Dummy_id,AcctDir,Client,ClientID,Study,StudyID,Survey,SurveyID,ProjectNumber,    
 MailFrequency,ContractStart,ContractEnd,Sampled,SampleSet,SampleDate,Dummy_Step,MailingStep,Scheduled,    
 GenDate,Generated,PrintDate,Printed,MailDate,Mailed)    
SELECT Dummy_id,AcctDir,Client,ClientID,Study,StudyID,Survey,SurveyID,ProjectNumber,MailFrequency,ContractStart,    
 ContractEnd,Sampled,SampleSet,[Sample Date],Dummy_Step,[Mailing Step],GenDate,GenDate,Generated,PrintDate,Printed,    
 MailDate,Mailed     
FROM #Completed    
ORDER BY Dummy_id    
    
-- Added 1/14/2005 -- Steve Spicka    
-- Commented out 4/13/2011 after the death of nrc32 -- DRM
 --EXEC dbo.sp_Teams_ProjectStartup @bitIncremental = 1    
    
DROP TABLE #SampleSets    
DROP TABLE #ProdReport    
DROP TABLE #Sampled    
DROP TABLE #Completed


