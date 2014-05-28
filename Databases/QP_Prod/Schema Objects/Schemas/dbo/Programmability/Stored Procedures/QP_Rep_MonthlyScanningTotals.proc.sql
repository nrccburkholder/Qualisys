CREATE PROCEDURE QP_Rep_MonthlyScanningTotals
    @Associate varchar(50),
    @BeginDate  datetime
AS
set transaction isolation level read uncommitted
--Variable declarations
DECLARE @EndDate datetime
DECLARE @CurDate datetime

--Determine the end date
SELECT @EndDate = DateAdd(month, 1, @BeginDate)

--Create the Dates table
CREATE TABLE #Dates ( strDate char(10) )

--Populate the Dates table
SELECT @CurDate = @BeginDate
WHILE @CurDate < @EndDate
BEGIN
    --Insert this date into the table
    INSERT INTO #Dates (strDate) VALUES (Convert(char(10), @CurDate, 101))
    --Increment the date by one day
    SELECT @CurDate = DateAdd(day, 1, @CurDate)
END

--Determine the Deliverable counts for Import
SELECT dt.strDate, Count(qf.QuestionForm_id) AS Deliverable
INTO #Delivr
FROM #Dates dt, QuestionForm qf
WHERE dt.strDate = Convert(char(10), qf.datReturned, 101)
GROUP BY dt.strDate

--Determine the Ignored counts for Import
SELECT dt.strDate, Count(qf.QuestionForm_id) AS Ignored
INTO #Ignore
FROM #Dates dt, QuestionForm qf
WHERE dt.strDate = Convert(char(10), qf.datUnusedReturn, 101)
  AND qf.UnusedReturn_id <> 3
GROUP BY dt.strDate

--Determine the Non-Deliverable counts for Import
SELECT dt.strDate, Count(sm.SentMail_id) AS NonDeliverable
INTO #NonDel
FROM #Dates dt, SentMailing sm 
WHERE dt.strDate = Convert(char(10), sm.datUndeliverable, 101)
GROUP BY dt.strDate

--Determine the Error counts for Import
SELECT dt.strDate, Count(DISTINCT se.strLithoCode) AS Errors
INTO #Errors
FROM #Dates dt, ScanExportError se 
WHERE dt.strDate = Convert(char(10), se.datErrorDate, 101)
  AND se.strLithoCode > 0 
GROUP BY dt.strDate

--Build first part of the report
SELECT dt.strDate AS [Date], 
       IsNull(Deliverable, 0) + IsNull(Ignored, 0) AS Deliverable, 
       IsNull(NonDeliverable, 0) AS NonDeliverable, 
       IsNull(Errors, 0) AS [Errors Encountered], 
       IsNull(Deliverable, 0) + IsNull(Ignored, 0) + IsNull(NonDeliverable, 0) + IsNull(Errors, 0) AS [Total] 
FROM (((#Dates dt LEFT JOIN #Delivr de ON dt.strDate = de.strDate)
                  LEFT JOIN #Ignore ig ON dt.strDate = ig.strDate)
                  LEFT JOIN #Errors er ON dt.strDate = er.strDate)
                  LEFT JOIN #NonDel nd ON dt.strDate = nd.strDate
WHERE (Deliverable IS NOT NULL
   OR Ignored IS NOT NULL
   OR Errors IS NOT NULL
   OR NonDeliverable IS NOT NULL)
ORDER BY dt.strDate

--Cleanup the temp tables
DROP TABLE #Dates
DROP TABLE #Delivr
DROP TABLE #NonDel
DROP TABLE #Errors
DROP TABLE #Ignore


update dashboardlog 
set procedureend = getdate()
where report = 'Monthly Scanning'
and associate = @Associate
and startdate = @BeginDate
and enddate = @EndDate
and procedureend is null

set transaction isolation level read committed


