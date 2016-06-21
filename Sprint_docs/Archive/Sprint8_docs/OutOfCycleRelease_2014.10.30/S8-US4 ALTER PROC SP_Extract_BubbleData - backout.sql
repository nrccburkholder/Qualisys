USE QP_Comments
go
ALTER PROCEDURE [dbo].[SP_Extract_BubbleData]                                                      
AS        
  
BEGIN                                                
/**************************************************************************************************************************************************/                                                      
-- Modified 6/24/04 SS -- Identify and include ONLY studies that have a Big_Table_NULL to move data from......                                                       
-- Modified 12/19/07 MB -- Added check to only create indexes (AggValues and QstnCoreSamplePop)                                           
--          on Study_Results_Vertical if it does not already exist.  This only causes a problem when                                          
--          extract dies and has to be manually restarted.                                          
-- Modified 7/18/2011 MWB          
--   for performance testing going to track numbers for the extract by counting distinct studys, surveys and samplepops processed.          
-- Modified 7/21/2011 MWB        
--   #return sql statements  having alot of issues with performance.        
--   Creating these indexes to see if it helps.        
-- Modified 1/8/2012 DRH - tuning stmts involving extract_sr_nonquestion and questionresult_work  
-- Modified 1/9/2012 DRH - to not create the tmpDedup on the #Dedup temp table ... seems to be causing performance issues on the deletes within the loop(s)  
-- Modified 02/27/2014 CB - added -5 and -6 as non-response codes. Phone surveys can code -5 as "Refused" and -6 as "Don't Know"  
-- Modified 06/16/2014 TSB - update *CAHPSDisposition table references to use SurveyTypeDispositions table  
/**************************************************************************************************************************************************/                                                      
    
SET NOCOUNT ON    
set arithabort on  
-- Modified 1/8/2012 DRH - tuning stmts involving extract_sr_nonquestion and questionresult_work  
--set arithabort on -- for stage only for now 1/8/2013        
                                
DECLARE @Nstrsql NVARCHAR(4000), @strsql VARCHAR(8000), @user VARCHAR(10), @Study INT, @Survey INT, @strfield VARCHAR(42)                                                      
DECLARE @cnt INT, @core INT, @strCore VARCHAR(20), @Server VARCHAR(50), @Gen DATETIME                         
DECLARE @HCAHPS_Complete INT, @HCAHPS_NotComplete INT, @HHCAHPS_NotComplete INT, @HHCAHPS_CompleteMail INT, @HHCAHPS_CompletePhone INT                                               
                                                
-- Need ID value for breakoff and complete dispositions (06) and (01) respectively.                                                
--SELECT @HCAHPS_NotComplete = d.disposition_id FROM DISPOSITION d, HCAHPSDispositions hd WHERE d.disposition_ID = hd.disposition_ID and  hd.HCAHPSValue = '06'                                                
--SELECT @HCAHPS_Complete = d.disposition_Id FROM DISPOSITION d, HCAHPSDispositions hd WHERE d.disposition_ID = hd.disposition_ID and  hd.HCAHPSValue = '01'                                                
                        
--SELECT @HHCAHPS_NotComplete = d.disposition_id FROM DISPOSITION d, HHCAHPSDispositions hd WHERE d.disposition_ID = hd.disposition_ID and  hd.HHCAHPSValue = '310'                                                
--SELECT @HHCAHPS_CompleteMail = d.disposition_Id FROM DISPOSITION d, HHCAHPSDispositions hd WHERE d.disposition_ID = hd.disposition_ID and  hd.HHCAHPSValue = '110'                                                
--SELECT @HHCAHPS_CompletePhone = d.disposition_Id FROM DISPOSITION d, HHCAHPSDispositions hd WHERE d.disposition_ID = hd.disposition_ID and  hd.HHCAHPSValue = '120'                                                
      
   
SELECT @HCAHPS_NotComplete = d.disposition_id FROM DISPOSITION d, SurveyTypeDispositions hd WHERE d.disposition_ID = hd.disposition_ID and  hd.Value = '06' and hd.SurveyType_ID = 2                                               
SELECT @HCAHPS_Complete = d.disposition_Id FROM DISPOSITION d, SurveyTypeDispositions hd WHERE d.disposition_ID = hd.disposition_ID and  hd.Value = '01' and hd.SurveyType_ID = 2                                                
                        
SELECT @HHCAHPS_NotComplete = d.disposition_id FROM DISPOSITION d, SurveyTypeDispositions hd WHERE d.disposition_ID = hd.disposition_ID and  hd.Value = '310' and hd.SurveyType_ID = 3                                               
SELECT @HHCAHPS_CompleteMail = d.disposition_Id FROM DISPOSITION d, SurveyTypeDispositions hd WHERE d.disposition_ID = hd.disposition_ID and  hd.Value = '110' and hd.SurveyType_ID = 3                                               
SELECT @HHCAHPS_CompletePhone = d.disposition_Id FROM DISPOSITION d, SurveyTypeDispositions hd WHERE d.disposition_ID = hd.disposition_ID and  hd.Value = '120' and hd.SurveyType_ID = 3     
                                                  
SELECT @Server=strParam_Value FROM Datamart_Params WHERE strParam_nm='QualPro Server'                                                    
      
insert into drm_tracktimes select getdate(), 'Call SP_Phase3_QuestionResult_For_Extract'      
                                                    
SELECT @strsql='EXEC '+@Server+'QP_Prod.dbo.SP_Phase3_QuestionResult_For_Extract'                                                     
                                                    
EXEC (@strsql)                                                     
         
TRUNCATE TABLE QuestionResult_work                                                      
TRUNCATE TABLE Extract_SR_NonQuestion                                                      
                              
CREATE TABLE #CoreFlds (strField_nm VARCHAR(20), QstnCore INT, Val INT, bitSingle BIT, bitUsed BIT)                                                      
CREATE TABLE #UpdateBigTable (SamplePop_id INT, TableSchema VARCHAR(10), TableName VARCHAR(200),                                                   
   bitComplete BIT, DaysFromFirstMailing INT, DaysFromCurrentMailing INT, LangID INT)                                        
-- CREATE TABLE #TableCheck (TableSchema VARCHAR(10), TableName VARCHAR(200))                                                  
                                  
print 'updating QuestionResult_Work'                      
                                                     
SELECT @strsql='INSERT INTO QuestionResult_Work (QuestionForm_id, strLithoCode, SamplePop_id, Val, '+CHAR(10)+                                                    
'   SampleUnit_id, QstnCore, datMailed, datImported, Study_id, datGenerated, Survey_id) '+CHAR(10)+                              
'SELECT QuestionForm_id, strLithoCode, SamplePop_id, Val, '+CHAR(10)+                                                    
'   SampleUnit_id, QstnCore, datMailed, datImported, Study_id, datGenerated, Survey_id '+CHAR(10)+                                                    
'FROM '+@Server+'QP_Prod.dbo.cmnt_QuestionResult_Work'                                                     
EXEC (@strsql)                                    
          
          
--************************************************************************************************          
--mwb 7/18/2011          
--for performance testing going to track numbers for the extract          
declare @studyCount int, @surveyCount int, @samplepopCount int          
select @StudyCount = count(distinct study_ID),           
  @SurveyCount = count(distinct Survey_ID),           
  @SamplePopCount = count(distinct Samplepop_ID)          
from QuestionResult_Work          
          
insert into Extract_processingCounts (datRun, studiesProcessed, SurveysProcessed, SamplePopsProcessed)          
Values (getdate(), @studyCount, @surveyCount, @samplepopCount)          
  
--mwb 12/28/2012  
--further performance code to tract survey Types by day  
Insert into Extract_surveyCounts (surveyType, SurveyCounts)      
select  st.surveytype_dsc, count(qrw.survey_ID)  
from    QuestionResult_Work qrw, qualisys.qp_prod.dbo.survey_Def sd, qualisys.qp_prod.dbo.surveyType st  
where qrw.survey_Id = sd.survey_ID and  
  sd.surveytype_ID = st.surveyType_ID  
group by st.surveytype_dsc     
      
--select * from Extract_processingCounts      
--************************************************************************************************          
                 
insert into drm_tracktimes select getdate(), 'INSERT INTO Extract_SR_NonQuestion'      
      
print 'Updating Extract_SR_NonQuestion'                                                  
--Now to insert into Extract_SR_NonQuestion for the datamart                                                      
--This is used at a later step in the extract                                                      
SELECT @strsql='INSERT INTO Extract_SR_NonQuestion (Study_id, Survey_ID, QuestionForm_id, SamplePop_id, SampleUnit_id, '+CHAR(10)+                                                    
'   strLithoCode, SampleSet_id, datReturned, datReportDate, strUnitSelectType, bitComplete, '+CHAR(10)+                                                  
'   DaysFromFirstMailing, DaysFromCurrentMailing, LangID, ReceiptType_ID) '+CHAR(10)+              
'SELECT Study_id, Survey_ID, QuestionForm_id, SamplePop_id, SampleUnit_id, '+CHAR(10)+                                                    
'   strLithoCode, SampleSet_id, datReturned, datReportDate, strUnitSelectType, bitComplete, '+CHAR(10)+                                                  
'   DaysFromFirstMailing, DaysFromCurrentMailing, LangID, ReceiptType_ID '+CHAR(10)+                                                    
'FROM '+@Server+'QP_Prod.dbo.Phase4_NonQuestion_View'                                                    
EXEC (@strsql)                                                     
                                                   
                                    
  print 'Running Sampleunit Fix made by Don'                    
--*******************************************************************************************                                    
--** temporary section to fix units from study 562, drm 6/10/2008          
--*******************************************************************************************                                    
--create table #tmp1 (oldsampleunit_id int, newsampleunit_id int)                                    
--insert into #tmp1 values (26965, 38168)                                    
--insert into #tmp1 values (26969, 38169)                                    
--insert into #tmp1 values (80827, 38170)                                    
--insert into #tmp1 values (32992, 38171)                                    
--insert into #tmp1 values (32993, 38172)                                    
--insert into #tmp1 values (32994, 38173)                                    
--insert into #tmp1 values (37988, 38174)                                    
--insert into #tmp1 values (37989, 38175)                                    
--insert into #tmp1 values (37990, 38176)                                    
--insert into #tmp1 values (37992, 38177)                                    
--insert into #tmp1 values (37993, 38178)                                    
--insert into #tmp1 values (37994, 38179)                                    
--insert into #tmp1 values (37996, 38181)                                    
--insert into #tmp1 values (37997, 38182)                                    
--insert into #tmp1 values (80820, 80894)                                    
--insert into #tmp1 values (80821, 80895)                                    
--insert into #tmp1 values (80822, 80896)                                    
--insert into #tmp1 values (80823, 80897)                                    
                                    
--select distinct samplepop_id, sampleunit_id into #tmp2 from Extract_SR_NonQuestion                                     
--where study_id = 562 and sampleunit_id in (select oldsampleunit_id from #tmp1)                  
                                    
----level 3                                    
--update a                                    
--set a.sampleunit_id = c.newsampleunit_id                                    
--from Extract_SR_NonQuestion a inner join #tmp2 b                                    
-- on a.samplepop_id = b.samplepop_id                                    
-- and a.sampleunit_id = b.sampleunit_id                                    
--inner join #tmp1 c                                    
-- on b.sampleunit_id = c.oldsampleunit_id                                    
                                    
----level 2                                    
--update Extract_SR_NonQuestion                                    
--set sampleunit_id = 38167                                    
--where sampleunit_id = 26964                                    
--and samplepop_id in (select samplepop_id from #tmp2)                                    
                                    
----level 1                                    
--delete Extract_SR_NonQuestion                                    
--where sampleunit_id = 26941                                    
--and samplepop_id in (select samplepop_id from #tmp2)                                    
--*******************************************************************************************                                    
--** end temporary section                                    
--*******************************************************************************************                                    
--print 'end of sampleunit fix'                                  
  
  
--DRM 03/06/2013  
--Check for missing big_table data  
exec sp_extract_bubbledata_errorcheck  
      
      
--Update bithasResults in clientStudySurvey so the Survey can be accessed via the applications                                                      
UPDATE ClientStudySurvey SET bitHasResults=1             
WHERE Survey_id IN                         
 (                        
 SELECT DISTINCT e.Survey_id                                                      
 FROM Extract_SR_NonQuestion e, SampleUnit su                                                      
 WHERE e.SampleUnit_id=su.SampleUnit_id                        
 )                                                      
                                    
--Delete records we don't want to keep.  They will join to the Sampleremove table.                                               
DELETE q                                                      
FROM Extract_SR_NonQuestion q, SampleRemove s                                                      
WHERE q.SampleSet_id=s.SampleSet_id                                                      
AND q.SampleUnit_id=s.SampleUnit_id                                                      
AND q.strUnitSelectType=s.strUnitSelectType                                            
                                                      
SELECT DISTINCT Study_id, QstnCore                                                      
INTO #Study                                                      
FROM QuestionResult_work                                                      
      
insert into drm_tracktimes select getdate(), 'Get distinct valid qstncores and vals'      
                                                      
--get the distinct QstnCore/Val that are Valid for each Study                        
SELECT DISTINCT t.Study_id, t.QstnCore, Val, nummarkcount     INTO #Valid                                 
FROM #Study t, clientStudySurvey css, Questions q, scales s                                                      
WHERE t.Study_id=css.Study_id                                                      
AND css.Survey_id=q.Survey_id                                 
AND t.QstnCore=q.QstnCore                                                      
AND q.Survey_id=s.Survey_id                                                      
AND q.scaleid=s.scaleid                                                      
AND q.language=1                                                      
AND q.language=s.language                                                      
                                                      
CREATE INDEX tmpValid ON #Valid (Study_id, QstnCore, Val)                                                      
      
insert into drm_tracktimes select getdate(), 'Log the inValid responses'      
                                                    
--Log the inValid responses                                                      
INSERT INTO InValid_Entries (QuestionForm_id,strLithoCode,SamplePop_id,Val,SampleUnit_id,QstnCore,datMailed,datImported,Study_id)                                                    
SELECT q.QuestionForm_id,q.strLithoCode,q.SamplePop_id,q.Val,q.SampleUnit_id,q.QstnCore,q.datMailed,q.datImported,q.Study_id                                                    
FROM QuestionResult_Work q LEFT OUTER JOIN #Valid t                                                      
ON q.Study_id=t.Study_id                                     
AND q.QstnCore=t.QstnCore                                                      
AND (q.Val=t.Val                 
OR q.Val-10000=t.Val)-- We add 10000 to any responses that should have been skipped.                                                
WHERE t.Val IS NULL                               
AND q.Val NOT IN (-9,-8,-7,-6,-5) --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know  
AND q.Val IS NOT NULL                                                      
                                                      
--Set inValid responses to -8                                                      
UPDATE q                                                      
SET q.Val=-8                                                  
FROM QuestionResult_Work q LEFT OUTER JOIN #Valid t                                                      
ON q.Study_id=t.Study_id                                                      
AND q.QstnCore=t.QstnCore                                                      
AND (q.Val=t.Val                                                
OR q.Val-10000=t.Val)                                                
WHERE t.Val IS NULL                                              
AND q.Val NOT IN (-9,-8,-7,-6,-5) --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know  
AND q.Val IS NOT NULL                                                      
      
insert into drm_tracktimes select getdate(), 'Delete duplicate returns'      
                                                      
--Delete duplicate returns that are in the same extract                           
SELECT SamplePop_id, MIN(strLithoCode) Litho                                                      
INTO #keep                                                      
FROM Extract_SR_NonQuestion                                                      
GROUP BY SamplePop_id, SampleUnit_id    
  
-- Modified 1/8/2012 DRH - tuning stmts involving extract_sr_nonquestion and questionresult_work  
CREATE INDEX tmpkeep ON #keep (Litho, SamplePop_id)                                                      
                                                      
DELETE n                                                      
FROM Extract_SR_NonQuestion n LEFT OUTER JOIN #keep t                                                      
ON n.SamplePop_id=t.SamplePop_id                                                      
AND n.strLithoCode=t.Litho                                                      
WHERE t.Litho IS NULL                                                      
                                                      
DELETE q                                                      
FROM QuestionResult_Work q LEFT OUTER JOIN #keep t                                                      
ON q.SamplePop_id=t.SamplePop_id                                                      
AND q.strLithoCode=t.Litho                                                      
WHERE t.Litho IS NULL                                                      
                                                      
DROP TABLE #keep                                                      
      
                
/*                                                    
--Removed from the HCAHPS requirements.  Will be enforced in the CMS Extract                                                    
--Enforce skip patterns                                                    
--Get all of the distinct survey_id and datgenerated values to loop thru                                                    
SELECT Survey_id, datGenerated                                                    
INTO #SkipLoop                                                    
FROM QuestionResult_Work                                                     
GROUP BY Survey_id, datGenerated                                                    
                                                    
SELECT TOP 1 @Survey=Survey_id, @Gen=datGenerated                                                    
FROM #SkipLoop                                                    
ORDER BY Survey_id, datGenerated                                     
         
WHILE @@ROWCOUNT>0                                                    
BEGIN                                                    
                                                    
EXEC SP_Extract_BubbleData_EnforceSkip @Survey, @Gen                        
                                              
DELETE #SkipLoop                                                     
WHERE Survey_id=@Survey                                                     
AND datGenerated=@Gen                                                    
                                                    
SELECT TOP 1 @Survey=Survey_id, @Gen=datGenerated                                                    
FROM #SkipLoop                              
ORDER BY Survey_id, datGenerated                                         
                                                    
END                                                    
                                                
DROP TABLE #SkipLoop                                                    
*/                                                    
      
insert into drm_tracktimes select getdate(), 'Populate datReportDate'      
                                                    
print 'populating datReportDate'                              
                   
--Need to Populate datReportDate with the return date for Surveys that report on return date                                   
--First get the SampleUnits for the given Surveys                                                      
SELECT SampleUnit_id                                                      
INTO #RD                                                      
FROM SampleUnit su, clientStudySurvey css                                                      
WHERE css.strReportDateField='ReturnDate'                                                      
AND css.Survey_id=su.Survey_id                                                      
  
-- Modified 1/8/2012 DRH - tuning stmts involving extract_sr_nonquestion and questionresult_work  
CREATE INDEX tmpRD ON #RD (SampleUnit_id)                                                      
  
--now to set datReportdate=datReturned                                                      
UPDATE n                                                      
SET n.datReportDate=datReturned                                                      
FROM #RD t, Extract_SR_NonQuestion n                            
WHERE t.SampleUnit_id=n.SampleUnit_id                
                                                      
--Now to move the big_table entries                                                      
SELECT Study_id, SamplePop_id, datreportdate                                                      
INTO #move                                               
FROM Extract_SR_NonQuestion nq                                                      
WHERE datReportDate IS NOT NULL AND EXISTS (                                   
  SELECT DISTINCT CONVERT(INT,SUBSTRING(table_schema,2,10)) AS Study_id FROM INFORMATION_SCHEMA.TABLES t                                                       
  WHERE LEFT(table_schema,1)='s' AND TABLE_NAME='Big_Table_Null' AND nq.Study_id=CONVERT(INT,SUBSTRING(table_schema,2,10)))                                                
  -- Identify and include ONLY studies that have a Big_Table_NULL to move data from...... Mod 6/24/04 SS                                                      
      
insert into drm_tracktimes select getdate(), 'Start looping through studies'      
                                    
print 'Starting loop Thru Studies'                                    
                                             
--loop thru the studies                                                      
WHILE (SELECT COUNT(*) FROM #move)>0                                    
BEGIN                                                      
                                
 SELECT TOP 1 @Study=Study_id FROM #move            
      
 insert into drm_tracktimes select getdate(), 'Big_table_null'      
      
 --We will move the records back into a work table and then run the movefromwork                                                      
 SET @strsql='UPDATE b '+CHAR(10)+                                                     
  ' SET b.datReportDate=t.datReportDate '+CHAR(10)+                                                     
  ' FROM S'+CONVERT(VARCHAR,@Study)+'.Big_Table_NULL b, #move t '+CHAR(10)+                                                     
  ' WHERE t.SamplePop_id=b.SamplePop_id '                                                       
 print @strsql    
 EXEC (@strsql)                                                      
                                                       
 CREATE TABLE #RetColumns (col VARCHAR(42))                                             
                                                       
 INSERT INTO #RetColumns                                                       
 SELECT sc.name                                      
 FROM dbo.sql2kobjects so, dbo.sql2kusers su, dbo.sql2kcolumns sc                                                      
 WHERE su.name='s'+CONVERT(VARCHAR,@Study)                                                      
 AND su.uid=so.uid                                                      
 AND so.name='Big_Table_NULL'                                                      
 AND so.id=sc.id                                                      
 AND iscomputed=0                                                      
                
 DECLARE @selcol VARCHAR(7500), @colname VARCHAR(42)                                                      
                                                       
 SET @selcol=''                                                      
                                                       
SELECT TOP 1 @colname=col FROM #RetColumns                                                      
                                                       
 WHILE @@ROWCOUNT>0                                                      
 BEGIN                                                      
                                           SET @selcol=@selcol+','+@colname                                                      
                                                        
  DELETE #RetColumns WHERE col=@colname                                                      
                                                        
  SELECT TOP 1 @colname=col FROM #RetColumns                                                      
                                                       
 END                                                      
                                                       
 SET @strsql=' SET QUOTED_IDENTIFIER ON SELECT dbo.YearQtr(datReportDate) QtrTable'+@selcol+CHAR(10)+                                 
  ' INTO S'+CONVERT(VARCHAR,@Study)+'.Big_Table_Work '+CHAR(10)+                                                     
  ' FROM S'+CONVERT(VARCHAR,@Study)+'.Big_Table_NULL '+CHAR(10)+                               
  ' WHERE datReportDate IS NOT NULL '+CHAR(10)+                                                     
  ' DELETE S'+CONVERT(VARCHAR,@Study)+'.Big_Table_NULL '+CHAR(10)+                                                     
  ' WHERE datReportDate IS NOT NULL '                                                      
 print @strsql                                                      
 EXEC (@strsql)                                                      
                                            
 DROP TABLE #RetColumns                                                   
                                                       
 --Delete the records for the Study                                                      
 DELETE #move WHERE Study_id=@Study                                                      
          
--end the loop                                                      
END                
      
insert into drm_tracktimes select getdate(), 'MoveFromWork big_table'      
                   
--use the movefromwork procedure to put the records in the appropriate table                                                      
EXEC SP_DBM_MoveFromWork 'Big_Table'                                                  
                                                      
--clean up                                                      
DROP TABLE #move                                                      
DROP TABLE #RD                                                      
      
insert into drm_tracktimes select getdate(), 'Begin loop to build vert table'      
                                                      
--Loop through the studies to first build the vertical table and then use it to Populate the horizontal table                                                      
WHILE (SELECT COUNT(*) FROM #Study)>0                                                      
BEGIN --loop3                                                      
                            
print 'Study_ID ' + cast(@Study as varchar(100))                              
print 'System User ID ' + cast (@user as varchar(100))                             
                            
                                                       
 SET @Study=(SELECT TOP 1 Study_id FROM #Study ORDER BY Study_id)                                                      
                                                       
    
    
    
 SET @user=(SELECT uid FROM dbo.sql2kusers WHERE NAME='s'+CONVERT(VARCHAR,@Study))                                                      
                                      
 --if the Results already exist, we will just delete the new records                          
 --First get rid of the QuestionForms                                                      
 PRINT 'First get rid of the QuestionForms'  
IF EXISTS (SELECT *   
   FROM dbo.sql2kobjects    
   WHERE type='v'    
   AND name='Study_Results_view' AND uid=(  
 SELECT uid    
   FROM dbo.sql2kusers    
   WHERE name='S'+CONVERT(VARCHAR,@Study)))   
 begin SET @strsql='  BEGIN   
   DELETE e   
   FROM Extract_SR_NonQuestion e, S'+CONVERT(VARCHAR,@Study)+  
  '.Study_Results_View s'+CHAR(10)+  
  -- Modified 1/8/2012 DRH - tuning stmts involving extract_sr_nonquestion and questionresult_work  
  --' WHERE e.SamplePop_id=s.SamplePop_id   
  ' WHERE e.Study_id='+RTRIM(CONVERT(VARCHAR,@Study))+' AND e.SamplePop_id=s.SamplePop_id   
   DELETE e      FROM QuestionResult_Work e, S'+CONVERT(VARCHAR,@Study)+  
  '.Study_Results_View s'+CHAR(10)+  
  -- Modified 1/8/2012 DRH - tuning stmts involving extract_sr_nonquestion and questionresult_work  
  --' WHERE e.SamplePop_id=s.SamplePop_id   
  ' WHERE e.Study_id='+RTRIM(CONVERT(VARCHAR,@Study))+' AND e.SamplePop_id=s.SamplePop_id   
   END'  
 print @strsql  
 EXEC (@strsql)  
 end  
 PRINT 'Deleted duplicates '+CONVERT(VARCHAR,GETDATE())                                                   
                 
 --MWB 8/11/2010                
 --this proc should help fix the "Big_Table_Null" error that                 
 --happens when big table extract does not extract all records.                
 --DRM 2/27/2013  
 --Commented this call out when moving to 2008 medusa and shortening views to only hold 5 quarters.  
 --exec sp_extract_CheckforAllSamplepopsInBigTable @Study                
                                                       
 --get the reportdate from big_table_view                                                      
 PRINT 'Get the reportdate from big_table_view'    
 set @strsql='UPDATE n '+CHAR(10)+                                                   
  ' SET n.datReportDate=b.datReportDate '+CHAR(10)+                                                     
  ' FROM S'+CONVERT(VARCHAR,@Study)+'.Big_Table_View b, Extract_SR_NonQuestion n '+CHAR(10)+                                                     
  ' WHERE n.Study_id='+CONVERT(VARCHAR,@Study)+CHAR(10)+                                                     
  ' AND n.SamplePop_id=b.SamplePop_id '+CHAR(10)+                                                     
  ' AND n.SampleUnit_id=b.SampleUnit_id '                                              
 print @strsql                                                      
 EXEC (@strsql)                                                      
                                   
 --if exists (select 'x' from Extract_SR_NonQuestion where datReportDate is null)                    
 --begin                    
                      
 --EXEC Qualisys.master.dbo.send_mail                     
 --@iprofile_name='QualisysEmail',                    
 --@irecipients='dba@nationalresearch.com',                    
 --@isubject='Extract found DatReportDate null errors in Study Results',                    
 --@ibody_format='Text',                    
--@iexecute_query_database = 'qp_prod',                    
 --@iattach_query_result_as_file = 1,                    
 --@iQuery='Select * from Datamart.qp_comments.dbo.Extract_SR_NonQuestion where datReportDate is null'                    
                     
 --return                    
 --end                    
                     
                     
                                                   
 -- Populate the bitComplete and daysfrommailing columns in big_table                                                  
 -- Get the values we need to deal with                                                  
 TRUNCATE TABLE #UpdateBigTable                                                  
--  TRUNCATE TABLE #TableCheck               
                
--mb here                
insert into drm_tracktimes select getdate(), 'Insert into #updatebigtable'      
                                                  
INSERT INTO #UpdateBigTable (SamplePop_id, TableSchema, TableName,                                                   
   bitComplete, DaysFromFirstMailing, DaysFromCurrentMailing, LangID)                                                
 SELECT SamplePop_id, 'S'+LTRIM(STR(Study_id)) TableSchema, 'Big_Table_'+dbo.YearQtr(datReportDate) TableName,                                                   
   bitComplete, DaysFromFirstMailing, DaysFromCurrentMailing, LangID                                                 
 FROM Extract_SR_NonQuestion                                                  
 WHERE Study_id=@Study                                                  
              
                    
----4/22/2010 MWB                    
----Commented this out b/c all final dispositions are now written to the dispolog during                     
----qp_prod.dbo.SP_Phase3_QuestionResult_For_Extract SP (called above)                        
--print 'insert into DispositionLog'                             
---- This will add the complete/notcomplete dispostion HCAHPS value to the dispostionlog table when we extract a HCAHPS survey (flagged bitcomplete=1/0) to the Datamart                                          
--INSERT INTO DispositionLog (Study_id, Survey_ID, Samplepop_id, Disposition_id, Receipttype_id, datLogged, LoggedBy, DaysFromCurrent, DaysFromFirst)                              
--SELECT t1.study_id, t1.survey_ID, t1.samplepop_id, t1.disposition_id, t1.receipttype, datLogged, Loggedby, DaysFromCurrent, DaysFromFirst                                                 
--FROM ( SELECT DISTINCT ENQ.study_id, css.survey_ID, ENQ.samplepop_id,                         
--  case                        
--     when css.surveyType_ID = 2 and ENQ.bitComplete = 1                            
--    then @HCAHPS_Complete                            
--     when css.surveyType_ID = 2 and ENQ.bitComplete = 0                            
--    then @HCAHPS_NotComplete                            
--     when css.surveyType_ID = 3 and ENQ.ReceiptType_id = 17 and ENQ.bitComplete = 1                            
--    then @HHCAHPS_CompleteMail                            
--     when css.surveyType_ID = 3 and ENQ.ReceiptType_id = 12 and ENQ.bitComplete = 1                            
--    then @HHCAHPS_CompletePhone                            
--     when css.surveyType_ID = 3 and ENQ.ReceiptType_id = 12 and ENQ.bitComplete = 0                            
--    then @HHCAHPS_NotComplete                             
--     when css.surveyType_ID = 3 and ENQ.ReceiptType_id = 17 and ENQ.bitComplete = 0                           
--    then @HHCAHPS_NotComplete                          
--   else                        
--   NULL                         
--  end as Disposition_ID,                         
--  isnull(ENQ.ReceiptType_id, 0) AS receipttype, ENQ.datReturned AS datLogged,                                                
--  '#nrcsql' AS Loggedby, DaysFromCurrentMailing AS DaysFromCurrent, DaysFromFirstMailing  AS DaysFromFirst                                                
--  FROM Extract_SR_NonQuestion ENQ, clientstudySurvey css WHERE css.survey_ID = ENQ.survey_ID and ENQ.study_id = @Study AND ENQ.bitComplete IN (1,0)                                                
--     ) t1                           
--WHERE NOT EXISTS (                                                
-- SELECT * FROM DispositionLog t2                                                 
-- WHERE t1.Study_id=t2.Study_id AND t1.SamplePop_id=t2.SamplePop_id AND t1.Disposition_id=t2.Disposition_id AND t1.datLogged=t2.datLogged)                                                
                                                
--  -- Add the fields to the Big_Tables is needed                                                  
--  INSERT INTO #TableCheck (TableSchema, TableName)                                                  
--  SELECT DISTINCT TableSchema, TableName FROM #UpdateBigTable                                                  
--                                            
--  -- Build a sql statement that will add the columns if they do not exist.                                                    
--  SELECT @strsql='DECLARE @ColumnsAdded INT SELECT @ColumnsAdded=0'+CHAR(10)             
--  SELECT @strsql=@strsql+'IF NOT EXISTS (SELECT Column_Name FROM Information_Schema.Columns '+CHAR(10)+                                 
--  'WHERE Table_Schema='''+TableSchema+''' AND Table_Name='''+TableName+''''+CHAR(10)+                                                  
--  'AND Column_Name=''DaysFromFirstMailing'') '+CHAR(10)+                                                  
--  'BEGIN'+CHAR(10)+                               
--  'ALTER TABLE '+TableSchema+'.'+TableName+' ADD bitComplete BIT, DaysFromFirstMailing INT, DaysFromCurrentMailing INT '+CHAR(10)+                                                  
--  'SELECT @ColumnsAdded=@ColumnsAdded+1'+CHAR(10)+                                             
--  'END'+CHAR(10)                                                  
--  FROM #TableCheck                   
--                                            
--  -- If the columsn are added, then rebuild the view.                                                  
--  SELECT @strsql=@strsql+'IF @ColumnsAdded>0'+CHAR(10)+                                                  
--  'EXEC SP_DBM_MakeView ''S'+LTRIM(STR(@Study))+''',''Big_Table'''                                               
--                                                   
--  EXEC (@strsql)                                                  
                                    
--before                                     
                                    
print 'Before BitComplete Update to Big_table'                                    
         
 -- Now to populate the fields                                                  
 SELECT @strsql=''                                                  
 SELECT @strsql=@strsql+'UPDATE b SET bitComplete=t.bitComplete, DaysFromFirstMailing=t.DaysFromFirstMailing,'+CHAR(10)+                                               
 ' DaysFromCurrentMailing=t.DaysFromCurrentMailing, LangID=t.LangID'+CHAR(10)+                                                  
 'FROM '+TableSchema+'.'+TableName+' b, #UpdateBigTable t'+CHAR(10)+                                                  
 'WHERE t.SamplePop_id=b.SamplePop_id'+CHAR(10)                                                  
 FROM (SELECT DISTINCT TableSchema, TableName FROM #UpdateBigTable) a                                                  
                                    
print 'After BitComplete Update to Big_table before execution'                                    
                                    
 print @strsql                                                
 EXEC (@strsql)                    
                                    
      
insert into drm_tracktimes select getdate(), 'Update respratecount'      
      
Print 'Updating RespRateCount'                                    
                                                  
 -- Now to update/populate the RR_ReturnCountByDays table                                     
 SELECT CONVERT(INT,NULL) Survey_id, SampleSet_id, SampleUnit_id, DaysFromFirstMailing, DaysFromCurrentMailing, COUNT(*) intReturned                  
 INTO #Returns                     
 FROM Extract_SR_NonQuestion                                                  
 WHERE Study_id=@Study                                                  
 GROUP BY SampleSet_id, SampleUnit_id, DaysFromFirstMailing, DaysFromCurrentMailing                 
        
 --MWB 7-21-11        
 --#return sql statements  having alot of issues with performance.        
 --Creating these indexes to see if it helps.        
 CREATE INDEX tmpReturns1 ON #Returns (SampleSet_id)         
 CREATE INDEX tmpReturns2 ON #Returns (SampleSet_id,SampleUnit_id,DaysFromFirstMailing,DaysFromCurrentMailing)         
        
                                                  
 UPDATE r                                                  
 SET Survey_id=rr.Survey_id                                              
 FROM RespRateCount rr, #Returns r                                                  
 WHERE r.SampleSet_id=rr.SampleSet_id                                                  
                                                  
 UPDATE rr                                                  
 SET rr.intReturned=rr.intReturned+t.intReturned                                                  
 FROM RR_ReturnCountByDays rr, #Returns t                                                  
 WHERE t.SampleSet_id=rr.SampleSet_id                                              
 AND t.SampleUnit_id=rr.SampleUnit_id                                                  
 AND t.DaysFromFirstMailing=rr.DaysFromFirstMailing                                                  
 AND t.DaysFromCurrentMailing=rr.DaysFromCurrentMailing                                                  
                
 DELETE t                       
 FROM RR_ReturnCountByDays rr, #Returns t                                                  
 WHERE t.SampleSet_id=rr.SampleSet_id                                                  
 AND t.SampleUnit_id=rr.SampleUnit_id                                                  
 AND t.DaysFromFirstMailing=rr.DaysFromFirstMailing                                                  
 AND t.DaysFromCurrentMailing=rr.DaysFromCurrentMailing                                                  
                                                  
 INSERT INTO RR_ReturnCountByDays (Survey_id,SampleSet_id,SampleUnit_id,                                                  
     DaysFromFirstMailing,DaysFromCurrentMailing,intReturned)                                                  
 SELECT Survey_id,SampleSet_id,SampleUnit_id,DaysFromFirstMailing,                                                  
     DaysFromCurrentMailing,intReturned                                   
 FROM #Returns                                                  
                                      
 DROP TABLE #Returns                                                  
      
 insert into drm_tracktimes select getdate(), 'On to Study_resuls_vertical_work'      
                                                  
 PRINT 'UID is '+@user                                                      
                                                       
 PRINT 'Onto Study_Results_Vertical_work '+CONVERT(VARCHAR,GETDATE())                                                      
                                                       
 SET NOCOUNT ON                                                      
                                                       
 TRUNCATE TABLE #CoreFlds                                                      
                                                       
 --identify all of the needed fields to add to the work table                                                      
 --This is also a list of Valid cores needed for the Population of the Vertical table.                                                      
 INSERT INTO #CoreFlds                          
 SELECT DISTINCT 'Q'+RIGHT('00000'+CONVERT(VARCHAR,QstnCore),6) , QstnCore , 0 , 1 , 0                                                      
 FROM #Valid            
 WHERE Study_id=@Study                                                 
 AND numMarkCount=1                                                      
 UNION                 SELECT DISTINCT 'Q'+RIGHT('00000'+CONVERT(VARCHAR,QstnCore),6)+             
  CASE WHEN Val BETWEEN 1 AND 26 THEN CHAR(96+Val) ELSE '' END , QstnCore, Val, 0 , 0                                                      
 FROM #Valid                                                      
 WHERE Study_id=@Study                                                      
 AND numMarkCount>1                                                      
                                                       
 SET NOCOUNT OFF                                                      
                                                       
 IF NOT EXISTS (SELECT * FROM dbo.sql2kobjects WHERE NAME='Study_Results_Vertical_Work' AND uid=@user)                                                     
                                                       
 BEGIN --loop4                                                      
                                                       
SET @strsql='CREATE TABLE S'+CONVERT(VARCHAR,@Study)+'.Study_Results_Vertical_Work ('+                                                     
   ' QtrTable VARCHAR(10), SamplePop_id INT, SampleUnit_id INT, strLithoCode VARCHAR(10), SampleSet_id INT, datReturned DATETIME, '+                                                      
   ' QstnCore INT, intResponseVal INT, datReportDate DATETIME, bitComplete BIT) '                                      
  print @strsql                                                      
  EXEC (@strsql)        
                                                       
 END --loop4                                  
            
 SET @strsql='INSERT INTO s'+CONVERT(VARCHAR,@Study)+'.Study_Results_Vertical_Work  '+                                           
  ' (QtrTable, SamplePop_id,SampleUnit_id,strLithoCode,SampleSet_id,datreturned,QstnCore,intresponseVal,datreportdate,bitComplete ) '+                                           
  ' SELECT dbo.YearQtr(datReportDate), w.SamplePop_id, n.SampleUnit_id, n.strLithoCode, n.Sampleset_id, n.datReturned, QstnCore, Val, datReportDate,bitComplete '+                                           
  ' FROM QuestionResult_work w, extract_sr_nonQuestion n'+                                   
  ' where w.Study_id='+CONVERT(VARCHAR,@Study)+                                            
  ' and w.Study_id=n.Study_id '+                                            
  ' and w.SamplePop_id=n.SamplePop_id '+                            
    
    
    
    
    
  ' and w.strLithoCode=n.strLithoCode' +                          
  ' OPTION(FORCE ORDER)'                                            
            
--MWB changed to always use FORCE ORDER option b/c sometimes w/o this it causes:            
--Msg 8650, Sev 13: Intra-query parallelism caused your server command (process ID #54)             
--to deadlock. Rerun the query without intra-query parallelism by using the query hint option (maxdop 1).                                                       
 --SET @strsql='INSERT INTO s'+CONVERT(VARCHAR,@Study)+'.Study_Results_Vertical_Work  '+                                                     
 -- ' (QtrTable, SamplePop_id,SampleUnit_id,strLithoCode,SampleSet_id,datreturned,QstnCore,intresponseVal,datreportdate,bitComplete ) '+                                                     
 -- ' SELECT dbo.YearQtr(datReportDate), w.SamplePop_id, n.SampleUnit_id, n.strLithoCode, n.Sampleset_id, n.datReturned, QstnCore, Val, datReportDate,bitComplete '+                                                
 -- ' FROM QuestionResult_work w, extract_sr_nonQuestion n'+                                                      
 -- ' where w.Study_id='+CONVERT(VARCHAR,@Study)+                                                      
 -- ' and w.Study_id=n.Study_id '+                                                      
 -- ' and w.SamplePop_id=n.SamplePop_id '+                                                    
 -- ' and w.strLithoCode=n.strLithoCode'                                                      
 print @strsql                                        
 EXEC (@strsql)                                                      
                                                 
 SET @strsql='CREATE INDEX DedupValues ON S'+CONVERT(VARCHAR,@Study)+'.Study_Results_Vertical_Work (SamplePop_id, SampleUnit_id, QstnCore, intresponseVal)'                                                    
                                 
 --Need to make sure we only have one response for each SamplePop/SampleUnit/QstnCore combination for single response Questions                                                      
 CREATE TABLE #Dedup (SamplePop_id INT, SampleUnit_id INT, QstnCore INT, datReportDate DATETIME, SampleSet_id INT, datReturned DATETIME, bitComplete BIT)    
   
 -- Modified 1/8/2012 DRH - tuning stmts involving extract_sr_nonquestion and questionresult_work  
 -- Modified 1/9/2012 DRH - to not create the tmpDedup on the #Dedup temp table ... seems to be causing performance issues on the deletes within the loop(s)  
 --CREATE INDEX tmpDedup ON #Dedup (SamplePop_id,SampleUnit_id,QstnCore)   
  
 --Find the duplicates      
 SET @strsql='INSERT INTO #Dedup select SamplePop_id, SampleUnit_id, w.QstnCore, w.datReportDate, SampleSet_id, datReturned, bitComplete '+CHAR(10)+                                                     
  ' FROM s'+CONVERT(VARCHAR,@Study)+'.Study_Results_Vertical_Work w, #CoreFlds t '+CHAR(10)+                           
  ' WHERE w.QstnCore=t.QstnCore '+CHAR(10)+                 
  ' AND t.bitSingle=1 '+CHAR(10)+                                                     
  ' GROUP BY SamplePop_id, SampleUnit_id, w.QstnCore, w.datReportDate, SampleSet_id, datReturned, bitComplete HAVING COUNT(*)>1 '                                             
 print @strsql                                                  
 EXEC (@strsql)                                                      
                                                       
 IF (SELECT COUNT(*) FROM #Dedup)>0                                                      
 BEGIN                                                      
                                                       
 --Delete all duplicate responses.  We will insert new records based on the Values in #Dedup                                                      
 SET @strsql='DELETE w '+CHAR(10)+                                                     
  ' FROM #Dedup t, s'+CONVERT(VARCHAR,@Study)+'.Study_Results_Vertical_Work w '+CHAR(10)+                                
  ' WHERE t.SamplePop_id=w.SamplePop_id '+CHAR(10)+                                                     
  ' AND t.SampleUnit_id=w.SampleUnit_id '+CHAR(10)+                                          
  ' AND t.QstnCore=w.QstnCore '                                                      
 print @strsql                                                      
 EXEC (@strsql)                                                      
                                                       
 --Insert where the SampleUnits match       
 SET @strsql='INSERT INTO s'+convert(varchar,@Study)+'.Study_Results_Vertical_Work '+CHAR(10)+                                                     
  ' SELECT dbo.YearQtr(datReportDate), t.SamplePop_id, t.SampleUnit_id, q.strLithoCode, t.Sampleset_id, '+CHAR(10)+                                                     
  ' t.datReturned, t.QstnCore, Val, t.datReportDate, bitComplete '+CHAR(10)+                                                     
  ' FROM QuestionResult_Work q, #Dedup t '+CHAR(10)+     
  -- Modified 1/8/2012 DRH - tuning stmts involving extract_sr_nonquestion and questionresult_work  
  --' WHERE t.SamplePop_id=q.SamplePop_id '+CHAR(10)+                                                  
  ' WHERE q.Study_id='+RTRIM(CONVERT(VARCHAR,@Study))+' AND t.SamplePop_id=q.SamplePop_id '+CHAR(10)+                                                   
  ' AND t.SampleUnit_id=q.SampleUnit_id '+CHAR(10)+                                                     
  ' AND t.QstnCore=q.QstnCore '                                                       
 print @strsql                                
 EXEC (@strsql)                                 
   
 SET @strsql='DELETE t '+CHAR(10)+                                                     
  ' FROM #dedup t, s'+convert(varchar,@Study)+'.Study_Results_Vertical_Work w '+CHAR(10)+                                                     
' WHERE t.SamplePop_id=w.SamplePop_id '+CHAR(10)+                                                     
  ' AND t.SampleUnit_id=w.SampleUnit_id '+CHAR(10)+                                                     
  ' AND t.QstnCore=w.QstnCore '                                                      
 print @strsql                                                      
 EXEC (@strsql)                                                      
                                                       
 --Just to make sure we enter the loop                                                      
 SELECT TOP 1 @strsql=CONVERT(VARCHAR,SamplePop_id) FROM #dedup                                                      
                         
 WHILE @@rowcount>0     
  BEGIN                                                      
     --update with another Valid Value.  This is the same update statement as when we Populate the horizontal table.                  
   SET @strsql='INSERT INTO s'+convert(varchar,@Study)+'.Study_Results_Vertical_Work '+CHAR(10)+                         
    ' SELECT TOP 1 dbo.YearQtr(datReportDate), t.SamplePop_id, t.SampleUnit_id, q.strLithoCode, t.Sampleset_id, '+CHAR(10)+                                                     
    ' t.datReturned, t.QstnCore, Val, t.datReportDate, bitComplete '+CHAR(10)+                                                     
    ' FROM QuestionResult_Work q, #Dedup t '+CHAR(10)+         
  -- Modified 1/8/2012 DRH - tuning stmts involving extract_sr_nonquestion and questionresult_work  
  --' WHERE t.SamplePop_id=q.SamplePop_id '+CHAR(10)+                                                                                             
    ' WHERE q.Study_id='+RTRIM(CONVERT(VARCHAR,@Study))+' AND t.SamplePop_id=q.SamplePop_id '+CHAR(10)+                                                     
    ' AND t.QstnCore=q.QstnCore '+CHAR(10)+                                                     
    ' AND q.Val>-1 '                                                      
   print @strsql                                 
   EXEC (@strsql)                                                      
                                                          
   SET @strsql='DELETE t '+CHAR(10)+                                                     
    ' FROM #dedup t, s'+convert(varchar,@Study)+'.Study_Results_Vertical_Work w '+CHAR(10)+                                                     
    ' WHERE t.SamplePop_id=w.SamplePop_id '+CHAR(10)+                                                     
    ' AND t.SampleUnit_id=w.SampleUnit_id '+CHAR(10)+                                                     
    ' AND t.QstnCore=w.QstnCore '                                                      
   print @strsql                                         
   EXEC (@strsql)                                                      
                                                         
  END                                                      
                                                       
 --Just to make sure we enter the loop                                                      
 SELECT TOP 1 @strsql=CONVERT(VARCHAR,SamplePop_id) FROM #dedup                                                      
                                       
 WHILE @@rowcount>0                                                      
  BEGIN                      
                                                       
   --update with another Value.  This is the same update statement as when we Populate the horizontal table.                                                      
   SET @strsql='INSERT INTO s'+convert(varchar,@Study)+'.Study_Results_Vertical_Work '+CHAR(10)+                                                     
    ' SELECT TOP 1 dbo.YearQtr(datReportDate), t.SamplePop_id, t.SampleUnit_id, q.strLithoCode, t.Sampleset_id, '+CHAR(10)+                               
    ' t.datReturned, t.QstnCore, Val, t.datReportDate, bitComplete '+CHAR(10)+              
    ' FROM QuestionResult_Work q, #Dedup t '+CHAR(10)+         
  -- Modified 1/8/2012 DRH - tuning stmts involving extract_sr_nonquestion and questionresult_work  
  --' WHERE t.SamplePop_id=q.SamplePop_id '+CHAR(10)+                                                                                             
    ' WHERE q.Study_id='+RTRIM(CONVERT(VARCHAR,@Study))+' AND t.SamplePop_id=q.SamplePop_id '+CHAR(10)+                                                     
    ' AND t.QstnCore=q.QstnCore '                                                       
   print @strsql                                                      
   EXEC (@strsql)                                                      
                              
   SET @strsql='DELETE t '+CHAR(10)+                                                     
    ' FROM #dedup t, s'+convert(varchar,@Study)+'.Study_Results_Vertical_Work w '+CHAR(10)+                                                     
    ' WHERE t.SamplePop_id=w.SamplePop_id '+CHAR(10)+                             
    ' AND t.SampleUnit_id=w.SampleUnit_id '+CHAR(10)+                                                     
    ' AND t.QstnCore=w.QstnCore '                                        
   print @strsql                                                      
   EXEC (@strsql)                            
                                                        
  END                                                   
                                                       
 END                               
                                                       
 --Get rid of the temp table before the next loop                                                      
 DROP TABLE #Dedup                                                      
                                          
--mwb 1                                                   
                                          
if not exists                                           
 (select so.name from  dbo.sql2kobjects so, dbo.sql2kindexes si, dbo.sql2kusers su  
  where so.id = si.id and so.uid=su.uid and so.name ='Study_Results_Vertical_Work' and si.name = 'AggValues' and  
  su.name = 'S' + CONVERT(VARCHAR,@Study))  
 begin  
  SET @strsql='CREATE INDEX AggValues ON S'+CONVERT(VARCHAR,@Study)+'.Study_Results_Vertical_Work (datReportDate, SampleUnit_id, QstnCore, intresponseVal)'  
  EXEC (@strsql)  
 end  
      
if not exists  
 (select so.name from  dbo.sql2kobjects so, dbo.sql2kindexes si, dbo.sql2kusers su  
  where so.id = si.id and so.uid=su.uid and so.name ='Study_Results_Vertical_Work' and si.name = 'QstnCoreSamplePop' and  
  su.name = 'S' + CONVERT(VARCHAR,@Study))  
 begin  
  SET @strsql='CREATE INDEX QstnCoreSamplePop ON S'+CONVERT(VARCHAR,@Study)+'.Study_Results_Vertical_Work (QstnCore, SamplePop_id)'  
  EXEC (@strsql)  
 end  
      
 insert into drm_tracktimes select getdate(), 'Study_results_work'      
                                                      
 IF NOT EXISTS (SELECT * FROM dbo.sql2kobjects WHERE NAME='Study_Results_Work' AND uid=@user)                                                      
 BEGIN -- SRW loop                                                      
                                     
 PRINT 'Create '+CONVERT(VARCHAR,@Study)+' table '+CONVERT(VARCHAR,GETDATE())                                         
                                                       
 SET @strsql='CREATE TABLE S'+CONVERT(VARCHAR,@Study)+'.Study_Results_Work '+                                        
  ' (QtrTable VARCHAR(10), SamplePop_id INT NOT NULL, SampleUnit_id INT NOT NULL, strLithoCode VARCHAR(10), '+               
  ' SampleSet_id INT, datReturned SMALLDATETIME, datReportDate SMALLDATETIME, bitComplete BIT)'                                                      
 print @strsql                                                       
 EXEC (@strsql)                                                      
                                                       
 PRINT 'Add the PK '+CONVERT(VARCHAR,GETDATE())                                                      
                                  
 SET @strsql='ALTER TABLE S'+CONVERT(VARCHAR,@Study)+'.Study_Results_Work '+                                           
  ' WITH NOCHECK ADD CONSTRAINT [PK_Study_Results_Work] '+                                                      
 ' PRIMARY KEY  CLUSTERED (SamplePop_id, SampleUnit_id)  ON [PRIMARY] '                                                      
                                                       
 EXEC (@strsql)                                                      
                                                       
      
 SET @strsql='INSERT INTO S'+CONVERT(VARCHAR,@Study)+'.Study_Results_Work ( '+                                                     
  ' QtrTable, SamplePop_id, SampleUnit_id, strLithoCode, SampleSet_id, datReturned, '+                                                     
  ' datReportDate, bitComplete )'+                                                     
  ' SELECT DISTINCT dbo.YearQtr(datReportDate), SamplePop_id, SampleUnit_id, strLithoCode, SampleSet_id, '+                                                     
  ' datReturned, datReportDate, bitComplete '+                                                     
  ' FROM s'+convert(varchar,@Study)+'.Study_Results_Vertical_Work '                                                      
 print @strsql                                                      
 EXEC (@strsql)                                                      
                                                       
 PRINT 'Inserted into Study_Results_work '+CONVERT(VARCHAR,GETDATE())                                                      
                                                       
                                                       
 SET @strsql='ALTER TABLE S'+CONVERT(VARCHAR,@Study)+'.Study_Results_work ADD '                                                      
              
 --loop to add the needed fields                                                      
 WHILE (SELECT COUNT(*) FROM #CoreFlds WHERE bitUsed=0)>0                                                     
 BEGIN  -- Alter loop                                                       
                                                       
 SET @strCore=(SELECT TOP 1 strField_nm FROM #CoreFlds WHERE bitUsed=0)                                                      
                                                       
 IF RIGHT(@strsql,4)='ADD '                                                      
 SET @strsql=@strsql+@strCore+' INT '                                                       
 ELSE                                                      
 SET @strsql=@strsql+', '+@strCore+' INT '                                                      
                                                       
 --execute the alter statement if it is longer than 6000 characters                    
 IF LEN(@strsql)>6000             
 BEGIN                                                      
                              
                                                       
begin try              
 EXEC (@strsql)                          
end try
begin catch
 PRINT @strsql                                                       
 insert into drm_tmp_CoreFlds (section, study, strField_nm, QstnCore, Val, bitSingle, bitUsed) select 1, @study, strField_nm, QstnCore, Val, bitSingle, bitUsed from #coreflds                                                  
end catch
                                            
                                        
 PRINT 'Alter table '+CONVERT(VARCHAR,GETDATE())                                                      
                                                       
 --reinitialize the variable                                      
 IF (SELECT COUNT(*) FROM #CoreFlds WHERE bitUsed=0)>1                                                      
 SET @strsql='ALTER TABLE S'+CONVERT(VARCHAR,@Study)+'.Study_Results_work ADD '                  
 ELSE                                                       
 SET @strsql=''                                                      
                                                       
 END                                                      
                                                       
 UPDATE #CoreFlds SET bitUsed=1 WHERE strField_nm=@strCore                                                      
                                                       
 END  -- Alter loop                                         

/*
--7/31/2014 tmp table to track error rows
drop table drm_tmp_CoreFlds
CREATE TABLE drm_tmp_CoreFlds (section int, study int, strField_nm VARCHAR(20), QstnCore INT, Val INT, bitSingle BIT, bitUsed BIT)                                                      
*/
begin try              
 EXEC (@strsql)                                  
end try
begin catch
 PRINT @strsql     
 insert into drm_tmp_CoreFlds (section, study, strField_nm, QstnCore, Val, bitSingle, bitUsed) select 2, @study, strField_nm, QstnCore, Val, bitSingle, bitUsed from #coreflds                                                  
end catch
                      
 END  -- SRW loop                                                      
                                                       
 DECLARE curQstn CURSOR FOR                                                      
 SELECT strField_nm, QstnCore FROM #CoreFlds                                                      
 WHERE bitSingle=1                                                     
                                                       
 PRINT 'Updating the cores '+CONVERT(VARCHAR,GETDATE())              
                                                       
 OPEN curQstn                                                      
 FETCH NEXT FROM curQstn INTO @strCore, @Core                                                      
 WHILE @@FETCH_STATUS=0                                                      
 BEGIN                   
                                                       
 -- Modified 4/23/3 BD At this point, the vertical table has already been Populated.  The order was changed to                                                       
 --   make sure the vertical and horizontal tables matched.  We will now Populate the horizontal                                                      
 --   with the contents of the vertical.  Thus we only need one update statement since we should                                                      
 --   already have a Result for every Valid SamplePop/SampleUnit combination.                                                      
 /*                                                      
 SET @strsql='UPDATE s SET s.'+@strCore+'=Val                                                      
  FROM S'+CONVERT(VARCHAR,@Study)+'.Study_Results_work s, QuestionResult_Work t                                                      
  WHERE t.Study_id='+CONVERT(VARCHAR,@Study)+'                                                      
  AND t.QstnCore='+CONVERT(VARCHAR,@core)+'                                                      
  AND s.SamplePop_id=t.SamplePop_id                                                      
  AND s.SampleUnit_id=t.SampleUnit_id'                          
                                                       
 EXEC (@strsql)                                                     
                                   
 SET @strsql='UPDATE s SET s.'+@strCore+'=Val                                         
  FROM S'+CONVERT(VARCHAR,@Study)+'.Study_Results_work s, QuestionResult_Work t                                                      
  WHERE t.Study_id='+CONVERT(VARCHAR,@Study)+'                                                      
  AND t.QstnCore='+CONVERT(VARCHAR,@core)+'                                                      
  AND s.SamplePop_id=t.SamplePop_id                                                      
  AND s.'+@strCore+' is null'                                                      
                                                       
 EXEC (@strsql)                                                      
 */                                                      
 SET @Nstrsql='UPDATE s SET s.'+@strCore+'=intresponseVal                                                      
  FROM S'+CONVERT(VARCHAR,@Study)+'.Study_Results_work s, S'+CONVERT(VARCHAR,@Study)+'.Study_Results_Vertical_Work t                                                      
  WHERE t.QstnCore='+CONVERT(VARCHAR,@core)+'                                                      
  AND s.SamplePop_id=t.SamplePop_id                                                      
  AND s.SampleUnit_id=t.SampleUnit_id'                                       
                                                       
 EXEC SP_EXECUTESQL @Nstrsql                                                      
                                 
 FETCH NEXT FROM curQstn INTO @strCore, @Core                                              
                                                       
 END                                                      
                                      
 CLOSE curQstn                                                      
 DEALLOCATE curQstn                                                      
      
 insert into drm_tracktimes select getdate(), 'Updating MR cores'      
                                                       
 PRINT 'Updating the MR cores '+CONVERT(VARCHAR,GETDATE())                                                      
                                                       
 --Multiple Response                                                      
 DECLARE curQstn CURSOR FOR                                                      
 SELECT strField_nm, QstnCore, Val FROM #CoreFlds                                                      
 WHERE bitSingle=0                                                      
                                                       
 OPEN curQstn                                                      
 FETCH NEXT FROM curQstn INTO @strCore, @Core, @Cnt                                                      
 WHILE @@FETCH_STATUS=0                                                      
 BEGIN                                                      
                                                       
 -- Modified 4/23/3 BD At this point, the vertical table has already been Populated.  The order was changed to                                                     
--   make sure the vertical and horizontal tables matched.  We will now Populate the horizontal                                                      
 --   with the contents of the vertical.  Thus we only need one update statement since we should                                                      
 --   already have a Result for every Valid SamplePop/SampleUnit combination.                                                      
 /*                                               
 SELECT @strsql='UPDATE s                                                       
  SET '+@strCore+'=Val                                                       
  FROM S'+CONVERT(VARCHAR,@Study)+'.Study_Results_work s, QuestionResult_Work t                                                   
  WHERE t.Study_id='+CONVERT(VARCHAR,@Study)+'                             
  AND s.SamplePop_id=t.SamplePop_id                                                      
  AND s.SampleUnit_id=t.SampleUnit_id                                                      
  AND t.QstnCore='+CONVERT(VARCHAR,@Core)+'                                                  
  AND t.Val='+CONVERT(VARCHAR,@Cnt)                                                      
                                                       
 EXEC (@strsql)                                                    
                                                       
 SELECT @strsql='UPDATE s                                                       
SET '+@strCore+'=Val                                                       
  FROM S'+CONVERT(VARCHAR,@Study)+'.Study_Results_work s, QuestionResult_Work t                                     
  WHERE t.Study_id='+CONVERT(VARCHAR,@Study)+'                   
  AND s.SamplePop_id=t.SamplePop_id                                                      
  AND '+@strCore+' IS NULL                                                      
  AND t.QstnCore='+CONVERT(VARCHAR,@Core)+'                                                      
  AND t.Val='+CONVERT(VARCHAR,@Cnt)                                                      
            
 EXEC (@strsql)          
 */                                                      
 SELECT @Nstrsql='UPDATE s                                                       
  SET '+@strCore+'=intresponseVal                                                       
  FROM S'+CONVERT(VARCHAR,@Study)+'.Study_Results_work s, S'+CONVERT(VARCHAR,@Study)+'.Study_Results_Vertical_Work t                                           
  WHERE s.SamplePop_id=t.SamplePop_id                                                      
  AND s.SampleUnit_id=t.SampleUnit_id                                                      
  AND t.QstnCore='+CONVERT(VARCHAR,@Core)+'                                                      
  AND t.intresponseVal='+CONVERT(VARCHAR,@Cnt)                                                      
                                                       
 EXEC SP_EXECUTESQL @Nstrsql                                      
                                                       
 FETCH NEXT FROM curQstn INTO @strCore, @Core, @Cnt                                                      
                                                       
 END                                                      
                                                       
 CLOSE curQstn                          
 DEALLOCATE curQstn                                                      
                                                       
 ---------------------------------------------------------------------------------------------------------------------------------------------------------                                                      
 -- Response Rate PART 2 of 3 (New Returns Update)        
      
   insert into drm_tracktimes select getdate(), 'sp_extract_resprate'      
                                                     
   EXEC sp_Extract_RespRate @Study, @procpart=2                                                      
                                                       
 ---------------------------------------------------------------------------------------------------------------------------------------------------------                                                      
      
 insert into drm_tracktimes select getdate(), 'Update qualisys'      
                                                
 PRINT 'Updating Qualysis: Study='+CONVERT(VARCHAR,@Study)+' Processed. ['+CONVERT(VARCHAR,GETDATE())+']'                                                    
                                                     
 -- SET @strsql=' EXEC NRC10.QP_Prod.DBO.SP_Cmnt_Update_QFExtract '+CONVERT(VARCHAR,@Study)  -- ss 4/7/05                                            
 -- EXEC (@strsql)                                                      
 SELECT @strsql='EXEC '+@Server+'QP_Prod.DBO.SP_Cmnt_Update_QFExtract '+LTRIM(STR(@study))                                                    
 EXEC (@strsql)                                                      
                                                       
 -- SET @strsql=' DELETE QuestionResult_work where Study_id='+CONVERT(VARCHAR,@Study)  -- ss 4/7/05                                                    
 -- EXEC (@strsql)                                                      
 DELETE QuestionResult_work where Study_id=@Study                                                    
               
 DELETE #Study WHERE Study_id=@Study                                                      
                                                     
 PRINT 'Get New Study to Process. [End of Loop3]'                                                    
    
END --loop3                                                      
    
insert into drm_tracktimes select getdate(), 'SP_DBM_Comments_Extract_to_History'      
      
SELECT @strsql='EXEC '+@Server+'QP_Prod.DBO.SP_DBM_Comments_Extract_to_History'                                                    
    
EXEC (@strsql)                                                      
                  
DROP TABLE #Study                               
DROP TABLE #Valid                                                      
DROP TABLE #CoreFlds  
  
END
