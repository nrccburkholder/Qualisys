--============================================================


CREATE PROCEDURE QP_Rep_MonthlyScanning  
    @Associate varchar(50),  
    @BeginDate  datetime  
AS  

-- =======================================================  
-- Revision  
-- MWB - 1/15/09  Added ContractNumber to report for 
-- SalesLogix integration
-- =======================================================  

set transaction isolation level read uncommitted  
--Variable declarations  
DECLARE @EndDate datetime  
DECLARE @CurDate datetime  
  
--Determine the end date  
SELECT @EndDate = DateAdd(month, 1, @BeginDate)  
  
--Get the Survey_ids  
SELECT distinct qf.Survey_id  
INTO #Surveys  
FROM SentMailing sm LEFT JOIN QuestionForm qf ON sm.SentMail_id = qf.SentMail_id  
WHERE sm.datUndeliverable BETWEEN @BeginDate AND @EndDate   
   OR qf.datReturned BETWEEN @BeginDate AND @EndDate  
   OR (qf.datUnusedReturn BETWEEN @BeginDate AND @EndDate  
  AND qf.UnusedReturn_id <> 3)  
  
--Create the Dates table  
CREATE TABLE #Dates ( strDate char(10), Survey_id int )  
  
--Populate the Dates table  
SELECT @CurDate = @BeginDate  
WHILE @CurDate < @EndDate  
BEGIN  
    --Insert this date into the table  
    INSERT INTO #Dates (strDate, Survey_id)   
    SELECT Convert(char(10), @CurDate, 101), Survey_id FROM #Surveys  
    --Increment the date by one day  
    SELECT @CurDate = DateAdd(day, 1, @CurDate)  
END  
  
--Determine the Deliverable counts for Import  
SELECT dt.strDate, dt.Survey_id, Count(qf.QuestionForm_id) AS Deliverable  
INTO #Delivr  
FROM #Dates dt, QuestionForm qf  
WHERE dt.strDate = Convert(char(10), qf.datReturned, 101)  
  AND dt.Survey_id = qf.Survey_id  
GROUP BY dt.strDate, dt.Survey_id  
  
--Determine the Ignored counts for Import  
SELECT dt.strDate, dt.Survey_id, Count(qf.QuestionForm_id) AS Ignored  
INTO #Ignore  
FROM #Dates dt, QuestionForm qf  
WHERE dt.strDate = Convert(char(10), qf.datUnusedReturn, 101)  
  AND qf.UnusedReturn_id <> 3  
  AND dt.Survey_id = qf.Survey_id  
GROUP BY dt.strDate, dt.Survey_id  
  
--Determine the Non-Deliverable counts for Import  
SELECT dt.strDate, dt.Survey_id, Count(sm.SentMail_id) AS NonDeliverable  
INTO #NonDel  
FROM #Dates dt, SentMailing sm LEFT JOIN QuestionForm qf ON sm.SentMail_id = qf.SentMail_id  
WHERE dt.strDate = Convert(char(10), sm.datUndeliverable, 101)  
  AND dt.Survey_id = qf.Survey_id  
GROUP BY dt.strDate, dt.Survey_id  
  
--Build first part of the report  
SELECT dt.strDate AS [Date], cl.strClient_nm AS [Client Name], st.strStudy_nm AS [Study Name],   
       sd.strSurvey_nm AS [Survey Name], dt.Survey_id AS [Survey ID], 
	   isnull(sd.Contract, 'Missing') as [Contract Number],
       IsNull(Deliverable, 0) + IsNull(Ignored, 0) AS Deliverable,   
       IsNull(NonDeliverable, 0) AS NonDeliverable,   
       IsNull(Deliverable, 0) + IsNull(Ignored, 0) + IsNull(NonDeliverable, 0) AS [Total Imported]   
FROM Client cl, Study st, Survey_Def sd,   
     ((#Dates dt LEFT JOIN #Delivr de ON dt.strDate = de.strDate AND dt.Survey_id = de.Survey_id)  
                 LEFT JOIN #Ignore ig ON dt.strDate = ig.strDate AND dt.Survey_id = ig.Survey_id)  
                 LEFT JOIN #NonDel nd ON dt.strDate = nd.strDate AND dt.Survey_id = nd.Survey_id  
WHERE cl.Client_id = st.Client_id  
  AND st.Study_id = sd.Study_id   
  AND sd.Survey_id = dt.Survey_id   
  AND (Deliverable IS NOT NULL  
   OR Ignored IS NOT NULL  
   OR NonDeliverable IS NOT NULL)  
ORDER BY dt.strDate, cl.strClient_nm, st.strStudy_nm, sd.strSurvey_nm  
--COMPUTE SUM(IsNull(Deliverable, 0) + IsNull(Ignored, 0)), SUM(IsNull(NonDeliverable, 0)),   
--        SUM(IsNull(Deliverable, 0) + IsNull(Ignored, 0) + IsNull(NonDeliverable, 0)) BY dt.strDate  
  
--Cleanup the temp tables  
DROP TABLE #Dates  
DROP TABLE #Delivr  
DROP TABLE #NonDel  
DROP TABLE #Surveys  
DROP TABLE #Ignore  
  
set transaction isolation level read committed


