CREATE PROCEDURE SP_DBM_DailyCapacity      
AS      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED       
DECLARE @strsql VARCHAR(8000), @lastdate VARCHAR(10)      
      
SET @lastdate=CONVERT(VARCHAR(10),DATEADD(d,-1,GETDATE()),120)      
      
INSERT INTO Capacity (dat_dt)      
SELECT @lastdate      
      
SELECT @strsql=' SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED SELECT MAX(DataSetMember_id) DataSetMember_id INTO #dsm FROM DataSetMember '+       
 ' SELECT MAX(SamplePop_id) SamplePop_id INTO #sp FROM SamplePop '+        
 ' SELECT MAX(SentMail_id) SentMail_id INTO #sm FROM SentMailing '+       
 ' UPDATE c SET c.DataSetMember_id=t.DataSetMember_id FROM Capacity c, #dsm t WHERE c.dat_dt='''+@lastdate+''''+      
 ' UPDATE c SET c.SentMail_id=t.SentMail_id FROM Capacity c, #sm t WHERE c.dat_dt='''+@lastdate+''''+      
 ' UPDATE c SET c.SamplePop_id=t.SamplePop_id FROM Capacity c, #sp t WHERE c.dat_dt='''+@lastdate+''''+     
 ' DROP TABLE #dsm DROP TABLE #sp DROP TABLE #sm '+     
 ' UPDATE Capacity SET countboth=(SELECT COUNT(*) FROM QuestionForm WHERE CONVERT(VARCHAR(10),datResultsImported,120)='''+      
 @lastdate+''' AND CONVERT(VARCHAR(10),datResultsImported,120)=CONVERT(VARCHAR(10),datReturned,120) AND strSTRBatchNumber not in (''OffTR'', ''NewOffTR'')) '+      
 ' WHERE dat_dt= '''+@lastdate+''''+      
 ' UPDATE Capacity SET countimported=(SELECT COUNT(*) FROM QuestionForm WHERE CONVERT(VARCHAR(10),datResultsImported,120)='''+       
 @lastdate+''' AND strSTRBatchNumber not in (''OffTR'', ''NewOffTR''))'+      
 ' WHERE dat_dt= '''+@lastdate+''''+      
 ' UPDATE Capacity SET countReturned=(SELECT COUNT(*) FROM QuestionForm WHERE CONVERT(VARCHAR(10),datReturned,120)='''+       
 @lastdate+''' AND (strSTRBatchNumber not in (''OffTR'', ''NewOffTR'') OR strSTRBatchNumber IS NOT NULL))'+      
 ' WHERE dat_dt= '''+@lastdate+''''+      
 ' UPDATE Capacity SET countunused=(SELECT COUNT(*) FROM QuestionForm WHERE CONVERT(VARCHAR(10),datunusedReturn,120)='''+       
 @lastdate+''' AND strSTRBatchNumber not in (''OffTR'', ''NewOffTR''))'+      
 ' WHERE dat_dt= '''+@lastdate+''''+      
 ' UPDATE Capacity SET notformGened=(SELECT COUNT(*) '+      
 ' FROM Survey_def SD, SamplePop SP, ScheduledMailing SM, MailingMethodology MM '+      
 ' WHERE  SP.SamplePop_id=SM.SamplePop_id '+      
 ' AND SM.SentMail_id IS NULL '+      
 ' AND SM.datGenerate<='''+@lastdate +''''+      
 ' AND SD.bitFormGenRelease=1  '+      
 ' AND MM.Methodology_id=SM.Methodology_id  '+      
 ' AND MM.Survey_id=SD.Survey_id  '+      
 ' AND SM.ScheduledMailing_id NOT IN (SELECT DISTINCT ScheduledMailing_id FROM FormGenerror '+      
 '      WHERE ScheduledMailing_id IS NOT NULL)) '+      
 ' WHERE CONVERT(VARCHAR(10),dat_dt,120)='''+@lastdate+''''+      
 ' UPDATE Capacity SET notpclGened=(SELECT COUNT(*) '+      
 ' FROM pclneeded '+      
 ' WHERE bitdone=0) '+       
 ' WHERE CONVERT(VARCHAR(10),dat_dt,120)='''+@lastdate+''''+      
 ' UPDATE Capacity SET formgenstart=(SELECT numParam_value FROM QualPro_Params WHERE Param_id=54)'+      
 ' WHERE CONVERT(VARCHAR(10),dat_dt,120)='''+@lastdate+''''+      
 ' UPDATE Capacity SET formGenend=(SELECT numParam_value FROM QualPro_Params WHERE Param_id=87) '+      
 ' WHERE CONVERT(VARCHAR(10),dat_dt,120)='''+@lastdate+''''+      
 ' UPDATE Capacity SET pclgenstart=(SELECT numParam_value FROM QualPro_Params WHERE Param_id=81) '+      
 ' WHERE CONVERT(VARCHAR(10),dat_dt,120)='''+@lastdate+''''+      
 ' UPDATE Capacity SET pclGenend=(SELECT numParam_value FROM QualPro_Params WHERE Param_id=82) '+      
 ' WHERE CONVERT(VARCHAR(10),dat_dt,120)='''+@lastdate+''''+      
 ' UPDATE Capacity SET countsampled=(SELECT COUNT(*) FROM SamplePop sp, sampleset ss WHERE CONVERT(VARCHAR(10),datsamplecreate_dt,120)='''+       
 @lastdate+''''+      
 ' AND sp.sampleset_id=ss.sampleset_id)'+      
 ' WHERE CONVERT(VARCHAR(10),dat_dt,120)='''+@lastdate+''''+      
 ' UPDATE Capacity SET samples=(SELECT COUNT(*) FROM sampleset WHERE CONVERT(VARCHAR(10),datsamplecreate_dt,120)='''+@lastdate+''')'+      
 ' WHERE CONVERT(VARCHAR(10),dat_dt,120)='''+@lastdate+''''+      
 ' UPDATE Capacity SET countloaded=(SELECT sum(intaddrcleaned) FROM Data_Set WHERE CONVERT(VARCHAR(10),datload_dt,120)='''+@lastdate+''')'+      
 ' WHERE CONVERT(VARCHAR(10),dat_dt,120)='''+@lastdate+''''+      
 ' UPDATE Capacity SET loads=(SELECT COUNT(*) FROM Data_Set WHERE CONVERT(VARCHAR(10),datload_dt,120)='''+@lastdate+''')'+      
 ' WHERE CONVERT(VARCHAR(10),dat_dt,120)='''+@lastdate+''''+     
 ' UPDATE Capacity SET univsampled=(SELECT sum(cnt) FROM SampleUniKeysCount WHERE CONVERT(VARCHAR(10),SampleDate,120)='''+@lastdate+''')'+      
 ' WHERE CONVERT(VARCHAR(10),dat_dt,120)='''+@lastdate+''''       
      
--print @strsql      
EXEC(@strsql)      
      
DECLARE @cnt INT      
      
SELECT @cnt=(SELECT COUNT(*)       
FROM ScheduledMailing schm, MailingStep ms, Survey_def sd      
WHERE datGenerate<=GETDATE()      
AND schm.MailingStep_id=ms.MailingStep_id      
AND ms.Survey_id=sd.Survey_id      
AND schm.SentMail_id IS NULL      
AND bitFormGenRelease=1      
AND ScheduledMailing_id NOT IN (      
SELECT DISTINCT ScheduledMailing_id FROM formGenerror      
WHERE ScheduledMailing_id IS NOT NULL))      
      
SET @cnt=@cnt+(SELECT COUNT(*)       
FROM SentMailing WHERE datGenerated>DATEADD(DAY, -1, GETDATE()))      
      
UPDATE Capacity      
SET scheduled=@cnt      
WHERE dat_dt=@lastdate      
      
UPDATE Capacity       
SET Generated=(SentMail_id - (SELECT SentMail_id FROM Capacity WHERE dat_dt=DATEADD(DAY,-1,@lastdate)))      
WHERE dat_dt=@lastdate      
      
UPDATE Capacity       
SET actualsampled=(SamplePop_id - (SELECT SamplePop_id FROM Capacity WHERE dat_dt=DATEADD(DAY,-1,@lastdate)))      
WHERE dat_dt=@lastdate      
      
UPDATE Capacity       
SET actualloaded=(DataSetMember_id - (SELECT DataSetMember_id FROM Capacity WHERE dat_dt=DATEADD(DAY,-1,@lastdate)))      
WHERE dat_dt=@lastdate      
      
-----ScanningStatus Report Added 6/10/02 by JPC ------------------        
        
SELECT CONVERT(CHAR(10),sm.datundeliverable,120) datReturned, COUNT(sm.SentMail_id) NonDeliverable        
INTO #NonDel        
FROM SentMailing sm (NOLOCK)        
WHERE CONVERT(CHAR(10),sm.datundeliverable,120)=@lastdate        
GROUP BY CONVERT(CHAR(10),sm.datundeliverable,120)        
        
UPDATE c SET c.NonDeliverables=n.nondeliverable        
FROM Capacity c, #nondel n        
WHERE c.dat_dt=n.datReturned        
        
SELECT CONVERT(CHAR(10), qf.datUnusedReturn, 120) datReturned, COUNT(qf.QuestionForm_id) Ignored        
INTO #Ignore        
FROM QuestionForm qf (NOLOCK)        
WHERE CONVERT(CHAR(10), qf.datUnusedReturn, 120)=@lastdate        
AND qf.UnusedReturn_id <> 3        
AND strSTRBatchNumber not in ('OffTR', 'NewOffTR')      
GROUP BY CONVERT(CHAR(10), qf.datUnusedReturn, 120)        
        
UPDATE c SET c.Ignored=i.ignored        
FROM Capacity c, #ignore i        
WHERE c.dat_dt=i.datReturned        
        
SELECT CONVERT(CHAR(10), qf.datUnusedReturn, 120) DatReturned, COUNT(qf.QuestionForm_id) Rescanned        
INTO #Rescan        
FROM QuestionForm qf (NOLOCK)        
WHERE CONVERT(CHAR(10), qf.datUnusedReturn, 120)=@lastdate        
AND qf.UnusedReturn_id=3        
AND strSTRBatchNumber not in ('OffTR', 'NewOffTR')      
GROUP BY CONVERT(CHAR(10), qf.datUnusedReturn, 120)        
        
UPDATE c SET c.rescanned=r.rescanned        
FROM Capacity c, #rescan r        
WHERE c.dat_dt=r.datReturned        
        
SELECT CONVERT(CHAR(10), datReturned, 120) DatReturned, COUNT(QuestionForm_id) NotTransferred        
INTO #nTrnsfr        
FROM QuestionForm (NOLOCK)        
WHERE datReturned IS NOT NULL         
AND datResultsImported IS NULL        
AND CONVERT(CHAR(10), datReturned, 120)=@lastdate        
AND strSTRBatchNumber not in ('OffTR', 'NewOffTR')      
GROUP BY CONVERT(CHAR(10), datReturned, 120)        
        
UPDATE c SET c.nottransferred=ntr.nottransferred        
FROM Capacity c, #ntrnsfr ntr        
WHERE c.dat_dt=ntr.datReturned        
        
UPDATE Capacity SET NonDeliverables=0 WHERE Nondeliverables IS NULL        
UPDATE Capacity SET Ignored=0 WHERE Ignored IS NULL        
UPDATE Capacity SET Rescanned=0 WHERE Rescanned IS NULL        
UPDATE Capacity SET NotTransferred=0 WHERE NotTransferred IS NULL        
        
DROP TABLE #NonDel        
DROP TABLE #Ignore        
DROP TABLE #Rescan        
DROP TABLE #nTrnsfr


