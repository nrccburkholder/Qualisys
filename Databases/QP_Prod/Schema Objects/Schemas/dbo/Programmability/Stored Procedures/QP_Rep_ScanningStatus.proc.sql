CREATE PROCEDURE QP_Rep_ScanningStatus    
    @Associate  VARCHAR(50),    
    @BeginDate  DATETIME,    
    @EndDate    DATETIME    
AS    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
    
--Add one day to end date    
--declare @BeginDate DATETIME, @enddate DATETIME    
--set @BeginDate='6/2/02'    
--set @enddate='6/12/02'    
    
CREATE TABLE #Today (datReturned DATETIME, Returns INT, NonDeliverables INT, Ignored INT, Rescanned INT, Transferred INT, NotTransferred INT)    
    
IF @EndDate=CONVERT(CHAR(10),GETDATE(),120)    
BEGIN    
 INSERT INTO #today (datReturned) SELECT CONVERT(CHAR(10),GETDATE(),120)    
    
 SELECT CONVERT(CHAR(10),qf.datReturned,101) datReturned, COUNT(qf.QuestionForm_id) Deliverable    
 INTO #Deliv    
 FROM QuestionForm qf (NOLOCK)    
 WHERE CONVERT(CHAR(10), qf.datReturned, 101)=@EndDate    
 AND strSTRBatchNumber not in ('OffTR', 'NewOffTr')  
 GROUP BY CONVERT(CHAR(10), qf.datReturned, 101)    
 ORDER BY CONVERT(CHAR(10), qf.datReturned, 101)    
    
 UPDATE t SET t.Returns=d.Deliverable    
 FROM #today t, #Deliv d    
 WHERE t.datReturned=d.datReturned    
    
 SELECT CONVERT(CHAR(10),sm.datunDeliverable,101) datReturned, COUNT(sm.SentMail_id) NonDeliverable    
 INTO #NonDel    
 FROM SentMailing sm (NOLOCK)    
 WHERE CONVERT(CHAR(10),sm.datunDeliverable,101)=@EndDate    
 GROUP BY CONVERT(CHAR(10),sm.datunDeliverable,101)    
    
 UPDATE t SET t.NonDeliverables=n.nonDeliverable    
 FROM #today t, #nondel n    
 WHERE t.datReturned=n.datReturned    
    
 SELECT CONVERT(CHAR(10), qf.datUnusedReturn, 101) datReturned, COUNT(qf.QuestionForm_id) Ignored    
 INTO #Ignore    
 FROM QuestionForm qf (NOLOCK)    
 WHERE CONVERT(CHAR(10), qf.datUnusedReturn, 101)=@EndDate    
 AND qf.UnusedReturn_id <> 3    
 AND strSTRBatchNumber not in ('OffTR', 'NewOffTr') 
 GROUP BY CONVERT(CHAR(10), qf.datUnusedReturn, 101)    
    
 UPDATE t SET t.Ignored=i.ignored    
 FROM #today t, #ignore i    
 WHERE t.datReturned=i.datReturned    
    
 SELECT CONVERT(CHAR(10), qf.datUnusedReturn, 101) DatReturned, COUNT(qf.QuestionForm_id) Rescanned    
 INTO #Rescan    
 FROM QuestionForm qf (NOLOCK)    
 WHERE CONVERT(CHAR(10), qf.datUnusedReturn, 101)=@EndDate    
 AND qf.UnusedReturn_id=3    
 AND strSTRBatchNumber not in ('OffTR', 'NewOffTr') 
 GROUP BY CONVERT(CHAR(10), qf.datUnusedReturn, 101)    
    
 UPDATE t SET t.rescanned=r.rescanned    
 FROM #today t, #rescan r    
 WHERE t.datReturned=r.datReturned    
    
 SELECT CONVERT(CHAR(10), qf.datResultsImported, 101) datReturned, COUNT(qf.QuestionForm_id) Transferred    
 INTO #Trnsfr    
 FROM QuestionForm qf (NOLOCK)    
 WHERE CONVERT(CHAR(10), qf.datResultsImported, 101)=@EndDate    
 AND strSTRBatchNumber not in ('OffTR', 'NewOffTr') 
 GROUP BY CONVERT(CHAR(10), qf.datResultsImported, 101)    
    
 UPDATE t SET t.transferred=tr.transferred    
 FROM #today t, #trnsfr tr    
 WHERE t.datReturned=tr.datReturned    
    
 SELECT CONVERT(CHAR(10), datReturned, 101) DatReturned, COUNT(QuestionForm_id) NotTransferred    
 INTO #nTrnsfr    
 FROM QuestionForm (NOLOCK)    
 WHERE datReturned IS NOT NULL     
 AND datResultsImported IS NULL    
 AND CONVERT(CHAR(10), datReturned, 101)=@EndDate    
 AND strSTRBatchNumber not in ('OffTR', 'NewOffTr') 
 GROUP BY CONVERT(CHAR(10), datReturned, 101)    
    
 UPDATE t SET t.nottransferred=ntr.nottransferred    
 FROM #today t, #ntrnsfr ntr    
 WHERE t.datReturned=ntr.datReturned    
    
 UPDATE #Today SET Returns=0 WHERE Returns IS NULL    
 UPDATE #Today SET NonDeliverables=0 WHERE NonDeliverables IS NULL    
 UPDATE #Today SET Ignored=0 WHERE Ignored IS NULL    
 UPDATE #Today SET Rescanned=0 WHERE Rescanned IS NULL    
 UPDATE #Today SET Transferred=0 WHERE Transferred IS NULL    
 UPDATE #Today SET NotTransferred=0 WHERE NotTransferred IS NULL    
    
 DROP TABLE #Deliv    
 DROP TABLE #NonDel    
 DROP TABLE #Ignore    
 DROP TABLE #Rescan    
 DROP TABLE #Trnsfr    
 DROP TABLE #nTrnsfr    
    
END    
ELSE    
BEGIN    
 SELECT @EndDate=DATEADD(DAY, 1, @EndDate)    
END    
    
--declare @BeginDate DATETIME, @enddate DATETIME    
--set @enddate='6/12/02'    
--set @BeginDate='6/1/02'    
  
SELECT CONVERT(CHAR(10),dat_dt,101) 'Date', CountReturned 'Returns', NonDeliverables, Ignored, Rescanned, CountReturned+nonDeliverables+ignored 'Total Imported', COUNTimported 'Transferred', nottransferred 'Not Transferred'    
FROM Capacity    
WHERE dat_dt>=@BeginDate    
AND dat_dt<@enddate    
UNION ALL    
SELECT CONVERT(CHAR(10),datReturned,101) 'Date', Returns, NonDeliverables, Ignored, Rescanned, Returns+nonDeliverables+ignored 'Total Imported', Transferred, NotTransferred 'Not Transferred'    
FROM #today    
ORDER BY [Date]    
    
DROP TABLE #today    
    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


