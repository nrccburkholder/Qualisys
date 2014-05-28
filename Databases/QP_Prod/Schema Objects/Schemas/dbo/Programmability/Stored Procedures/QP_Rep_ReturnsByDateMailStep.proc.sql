CREATE PROCEDURE QP_Rep_ReturnsByDateMailStep
 @Associate varchar(50),  
 @Client varchar(50),  
 @Study varchar(50),  
 @Survey varchar(50),  
 @FirstSampleSet varchar(50),  
 @LastSampleSet varchar(50)  
AS  
		-- 
		-- DECLARE  @Associate varchar(50),  
		--  @Client varchar(50),  
		--  @Study varchar(50),  
		--  @Survey varchar(50),  
		--  @FirstSampleSet varchar(50),  
		--  @LastSampleSet varchar(50)  
		-- 
		-- SELECT 
		--  @Client 				= 'BOZEMAN DEACONESS HOSPITAL'
		--  ,@Study 				= 'BOZEDEAIOE'	
		--  ,@Survey 			= '7343OP'
		--  ,@FirstSampleSet 		= '8/24/2001 4:52:02 PM'
		-- -- ,@FirstSampleSet 		= '1/25/2005 2:53:21 PM'
		--  ,@LastSampleSet 		= '1/25/2005 2:53:21 PM' 

set transaction isolation level read uncommitted  
--Insert record into Dashboard log table  
Declare @ProcedureBegin datetime  
SET @ProcedureBegin = getdate()  
INSERT INTO DashboardLog (Report, Associate, Client, Study, Survey, ProcedureBegin)   
SELECT 'Returns By Date Mailstep', @Associate, @Client, @Study, @Survey, @ProcedureBegin  
  
  
-- Declare variables  
Declare @sSql varchar(8000)  
Declare @sSqlRepData varchar(8000)  
Declare @sSqlSumData varchar(8000)  
Declare @Survey_id int  
Declare @Study_id int  
Declare @FrstSampleSet_id int  
Declare @LastSampleSet_id int  
DECLARE @MethodologyID int
Declare @MailingStepID int
DECLARE @SequenceID int
Declare @MailingStepName varchar(30)  
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
  
  
--Returns Step 1 table  
CREATE TABLE #RtnStep1 ( [Date Returned] varchar(10), MethodologyID INT, MailingStepID int, SequenceID INT, MailingStepName varchar(20), Quantity int )  
  
--Get the date and mailstep info  
SET @sSql = 'INSERT INTO #RtnStep1 ( [Date Returned], MethodologyID, MailingStepID, SequenceID, MailingStepName, Quantity ) ' +  
            'SELECT Convert(varchar, qf.datReturned, 101), ' +  
            '       ms.methodology_id, ms.mailingstep_id, ms.intSequence, ms.strMailingStep_Nm, Count(*) ' +  
            'FROM QuestionForm qf, SamplePop sp, ScheduledMailing sc, SentMailing sm, ' +  
            '     MailingStep ms ' +  
            'WHERE sm.SentMail_id = qf.SentMail_id ' +  
            '  AND qf.SamplePop_id = sp.SamplePop_id ' +  
            '  AND qf.Survey_id = ' + Convert(varchar, @Survey_id) + ' ' +  
            '  AND qf.datReturned IS NOT NULL ' +  
            '  AND sp.Study_id = ' + Convert(varchar, @Study_id) + ' ' +  
            '  AND sp.SampleSet_id Between ' + Convert(varchar, @FrstSampleSet_id) + ' and ' + Convert(varchar, @LastSampleSet_id) + ' ' +  
            '  AND sm.SentMail_id = sc.SentMail_id ' +  
            '  AND sc.MailingStep_id = ms.MailingStep_id ' +  
            'GROUP BY Convert(varchar, qf.datReturned, 101), ms.methodology_id, ms.mailingstep_id, ms.intSequence, ms.strMailingStep_Nm'  
EXEC (@sSql)  
  
--Debug code  
IF @Debugging = 1  
BEGIN  
    PRINT ' '  
    PRINT 'Contents of #RtnStep1:'  
    SELECT * FROM #RtnStep1  
END  
--End of debug code  
  
  
--Create the report data table  
CREATE TABLE #RepData ( [Date Returned] varchar(10), Total int default 0 )  
  
--Insert all the distinct dates into the report table  
INSERT INTO #RepData ( [Date Returned], Total )  
SELECT convert(varchar(10), qf.datReturned, 101), Count(*)   
FROM QuestionForm qf, SamplePop sp  
WHERE qf.SamplePop_id = sp.SamplePop_id  
  AND qf.Survey_id = @Survey_id  
  AND qf.datReturned IS NOT NULL  
  AND sp.Study_id = @Study_id   
  AND sp.SampleSet_id Between @FrstSampleSet_id and @LastSampleSet_id   
GROUP BY convert(varchar(10), datReturned, 101)  
  
--Debug code  
IF @Debugging = 1  
BEGIN  
    PRINT ' '  
    PRINT 'Contents of #RepData:'  
    SELECT * FROM #RepData  
END  
--End of debug code  
  
  
--Populate the report data table with the totals for each mailing step  
SET @sSqlRepData = ''  
SET @sSqlSumData = ''  

Declare TempCur Cursor For SELECT DISTINCT ms.methodology_id, ms.mailingstep_id, ms.intSequence, 'M' + CONVERT(VARCHAR,ms.methodology_id) +'_' + rtrim(ms.strMailingStep_Nm) 
	FROM MailingStep ms, #rtnstep1 r WHERE Survey_id = @Survey_id AND ms.methodology_id = r.methodologyID ORDER BY ms.methodology_Id, intSequence
Open TempCur  
Fetch Next From TempCur Into @methodologyID, @MailingStepID, @SequenceID, @MailingStepName   
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
                    'SET rd.[' + @MailingStepName + '] = r1.Quantity ' +  
                    'FROM #RepData rd, #RtnStep1 r1 ' +  
                    'WHERE rd.[Date Returned] = r1.[Date Returned] ' +  
                    '  AND r1.MailingStepID = ' + convert(varchar, @MailingStepID)  
        EXEC (@sSql)  
          
        --Set nulls to 0  
        SET @sSql = 'UPDATE #RepData ' +  
                    'SET [' + @MailingStepName + '] = 0 ' +  
                    'WHERE [' + @MailingStepName + '] IS NULL'  
        EXEC (@sSql)  
          
        --Fetch the next record in the cursor  
		Fetch Next From TempCur Into @methodologyID, @MailingStepID, @SequenceID, @MailingStepName   
    END  
Close TempCur  
Deallocate TempCur  
  
  
--Insert the totals  
SET @sSql = 'INSERT INTO #RepData ( [Date Returned], ' + @sSqlRepData + 'Total ) ' +  
            'SELECT ''12/31/2999'', ' + @sSqlSumData + 'Sum(Total) ' +  
            'FROM #RepData'  
EXEC (@sSql)  
  
  
--Select the report data  
SET @sSql = 'SELECT [Date Returned] = ' +  
            '    Case ' +  
            '        when convert(datetime, [Date Returned]) > ''12/30/2999'' ' +  
            '        then ''Totals'' ' +  
            '        else [Date Returned] ' +  
            '    End, ' + @sSqlRepData + 'Total ' +  
            'FROM #RepData ' +  
            'ORDER BY convert(datetime, [Date Returned])'  
EXEC (@sSql)  
  
  
--Cleanup  
DROP TABLE #RtnStep1  
DROP TABLE #RepData  
SET NOCOUNT OFF  
  
  
--Update the Dashboard log table  
UPDATE DashboardLog   
SET ProcedureEnd = getdate()  
WHERE Report = 'Returns By Date Mailstep'  
  AND Associate = @Associate  
  AND Client = @Client  
  AND Study = @Study  
  AND Survey = @Survey  
  AND ProcedureBegin = @ProcedureBegin  
  AND ProcedureEnd IS NULL  
  
set transaction isolation level read committed


