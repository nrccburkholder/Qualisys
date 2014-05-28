CREATE PROCEDURE QP_Rep_NonDelByDateMailStep
	@Associate varchar(50),
	@Client varchar(50),
	@Study varchar(50),
	@Survey varchar(50),
	@FirstSampleSet varchar(50),
	@LastSampleSet varchar(50)
AS
set transaction isolation level read uncommitted
--Insert record into Dashboard log table
Declare @ProcedureBegin datetime
SET @ProcedureBegin = getdate()
INSERT INTO DashboardLog (Report, Associate, Client, Study, Survey, ProcedureBegin) 
SELECT 'NonDel By Date Mailstep', @Associate, @Client, @Study, @Survey, @ProcedureBegin


--Declare the required variables
Declare @Survey_id int
Declare @Study_id int
Declare @sSql varchar(8000)
Declare @sSqlRepData varchar(8000)
Declare @sSqlSumData varchar(8000)
Declare @FrstSampleSet_id int
Declare @LastSampleSet_id int
Declare @MailingStepID int
Declare @MailingStepName varchar(20)
Declare @Debugging bit


--Set the debugging flag
SET @Debugging = 0

--Debug code
IF @Debugging = 0
BEGIN
    SET NOCOUNT ON
END
--End of debug code


--Get the study_id and survey_id
SELECT @Survey_id = sd.Survey_id, @Study_id = st.Study_id 
FROM Survey_Def sd, Study st, Client cl
WHERE cl.strClient_Nm = @Client
  AND st.strStudy_Nm = @Study
  AND sd.strSurvey_Nm = @Survey
  AND cl.Client_id = st.Client_id
  AND st.Study_id = sd.Study_id

--Get the first SampleSet_id
SELECT @FrstSampleSet_id = SampleSet_id
FROM SampleSet
WHERE Survey_id = @Survey_id
  AND Abs(DateDiff(Second, datSampleCreate_Dt, Convert(datetime, @FirstSampleSet))) <= 1

--Get the last SampleSet_id
SELECT @LastSampleSet_id = SampleSet_id
FROM SampleSet
WHERE Survey_id = @Survey_id
  AND Abs(DateDiff(Second, datSampleCreate_Dt, Convert(datetime, @LastSampleSet))) <= 1

--Debug code
IF @Debugging = 1
BEGIN
    PRINT 'SurveyID:          ' + convert(varchar, @Survey_id)
    PRINT 'StudyID:           ' + convert(varchar, @Study_id)
    PRINT 'First SampleSetID: ' + convert(varchar, @FrstSampleSet_id)
    PRINT 'Last SampleSetID:  ' + convert(varchar, @LastSampleSet_id)
END
--End of debug code


--PND Step 1 table
CREATE TABLE #PNDStep1 ( Pop_id int, datUndeliverable datetime )

--Get the maximum date of the available PNDs for each pop_id
SET @sSql = 'INSERT INTO #PNDStep1 ( Pop_id, datUndeliverable ) ' +
            'SELECT po.Pop_id, MAX(sm.datUndeliverable) ' +
            'FROM s' + Convert(varchar, @Study_id) + '.Population po, ' +
            '     SamplePop sp, ScheduledMailing sc, SentMailing sm, QuestionForm qf ' +
            'WHERE po.Pop_id = sp.Pop_id ' +
            '  AND sp.Study_id = ' + Convert(varchar, @Study_id) + ' ' +
            '  AND sp.SampleSet_id Between ' + Convert(varchar, @FrstSampleSet_id) + ' and ' + Convert(varchar, @LastSampleSet_id) + ' ' +
            '  AND sp.SamplePop_id = sc.SamplePop_id ' +
            '  AND sc.SentMail_id = sm.SentMail_id ' +
            '  AND sm.SentMail_id = qf.SentMail_id ' +
            '  AND qf.survey_id = ' + Convert(varchar,@Survey_id) + 
            'GROUP BY po.Pop_id ' +
            'HAVING (MAX(sm.datUndeliverable) IS NOT NULL AND MAX(qf.datReturned) IS NULL)'
EXEC (@sSql)

--Debug code
IF @Debugging = 1
BEGIN
    PRINT ' '
    PRINT 'Contents of #PNDStep1:'
    SELECT * FROM #PNDStep1
END
--End of debug code


--PND Step 2 table
CREATE TABLE #PNDStep2 ( Undeliverable varchar(10), MailingStepID int, MailingStepName varchar(20), Quantity int )

--Get the date and mailstep info
SET @sSql = 'INSERT INTO #PNDStep2 ( Undeliverable, MailingStepID, MailingStepName, Quantity ) ' +
            'SELECT convert(varchar, sm.datUndeliverable, 101), ' +
            '       ms.intSequence, ms.strMailingStep_Nm, Count(*) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population po, ' +
            '     SamplePop sp, ScheduledMailing sc, SentMailing sm, ' +
            '     MailingStep ms, #PNDStep1 p1 ' +
            'WHERE po.Pop_id = sp.Pop_id ' +
            '  AND sp.Study_id = ' + convert(varchar, @Study_id) + ' ' +
	    '  AND sp.SampleSet_id Between ' + Convert(varchar, @FrstSampleSet_id) + ' and ' + Convert(varchar, @LastSampleSet_id) + ' ' +
            '  AND sp.SamplePop_id = sc.SamplePop_id ' +
            '  AND sc.SentMail_id = sm.SentMail_id ' +
            '  AND sc.MailingStep_id = ms.MailingStep_id ' +
            '  AND po.Pop_id = p1.Pop_id ' +
            '  AND sm.datUndeliverable = p1.datUndeliverable ' +
            '  AND ms.survey_id = ' + Convert(varchar,@Survey_id) + 
            'GROUP BY convert(varchar, sm.datUndeliverable, 101), ms.intSequence, ms.strMailingStep_Nm'
EXEC (@sSql)

--Debug code
IF @Debugging = 1
BEGIN
    PRINT ' '
    PRINT 'Contents of #PNDStep2:'
    SELECT * FROM #PNDStep2
END
--End of debug code


--Create the report data table
CREATE TABLE #RepData ( [Date Undeliverable] varchar(10), Total int default 0 )

--Insert all the distinct dates into the report table
INSERT INTO #RepData ( [Date Undeliverable] )
SELECT DISTINCT Undeliverable FROM #PNDStep2


--Populate the report data table with the totals for each mailing step
SET @sSqlRepData = ''
SET @sSqlSumData = ''
Declare TempCur Cursor For SELECT DISTINCT intSequence, strMailingStep_Nm FROM MailingStep WHERE Survey_id = @Survey_id ORDER BY intSequence
Open TempCur
Fetch Next From TempCur Into @MailingStepID, @MailingStepName
While @@fetch_status = 0
    BEGIN
        --Add the field to the table
        SET @MailingStepName = ltrim(rtrim(@MailingStepName))
        SET @sSql = 'ALTER TABLE #RepData ' +
                    'ADD [' + @MailingStepName + '] int'
        EXEC (@sSql)
        
        --Add this field to the select list
        SET @sSqlRepData = @sSqlRepData + '[' + @MailingStepName + '], '
        SET @sSqlSumData = @sSqlSumData + 'Sum([' + @MailingStepName + ']), '
        
        --Update the quantities for this mailing step
        SET @sSql = 'UPDATE rd ' +
                    'SET rd.[' + @MailingStepName + '] = p2.Quantity ' +
                    'FROM #RepData rd, #PNDStep2 p2 ' +
                    'WHERE rd.[Date Undeliverable] = p2.Undeliverable ' +
                    '  AND p2.MailingStepID = ' + convert(varchar, @MailingStepID)
        EXEC (@sSql)
        
        --Set nulls to 0
        SET @sSql = 'UPDATE #RepData ' +
                    'SET [' + @MailingStepName + '] = 0 ' +
                    'WHERE [' + @MailingStepName + '] IS NULL'
        EXEC (@sSql)
         
        --Update the total
        SET @sSql = 'UPDATE #RepData ' +
                    'SET Total = Total + [' + @MailingStepName + ']'
        EXEC (@sSql)
        
        --Fetch the next record in the cursor
        Fetch Next From TempCur Into @MailingStepID, @MailingStepName
    END
Close TempCur
Deallocate TempCur


--Insert the totals
SET @sSql = 'INSERT INTO #RepData ( [Date Undeliverable], ' + @sSqlRepData + 'Total ) ' +
            'SELECT "12/31/2999", ' + @sSqlSumData + 'Sum(Total) ' +
            'FROM #RepData'
EXEC (@sSql)


--Select the report data
SET @sSql = 'SELECT [Date Undeliverable] = ' +
            '    Case ' +
            '        when convert(datetime, [Date Undeliverable]) > "12/30/2999" ' +
            '        then "Totals" ' +
            '        else [Date Undeliverable] ' +
            '    End, ' + @sSqlRepData + 'Total ' +
            'FROM #RepData ' +
            'ORDER BY convert(datetime, [Date Undeliverable])'
EXEC (@sSql)


--Cleanup the mess
DROP TABLE #PNDStep1
DROP TABLE #PNDStep2
DROP TABLE #RepData
SET NOCOUNT OFF


--Update the Dashboard log table
UPDATE DashboardLog 
SET ProcedureEnd = getdate()
WHERE Report = 'NonDel By Date Mailstep'
  AND Associate = @Associate
  AND Client = @Client
  AND Study = @Study
  AND Survey = @Survey
  AND ProcedureBegin = @ProcedureBegin
  AND ProcedureEnd IS NULL

set transaction isolation level read committed


