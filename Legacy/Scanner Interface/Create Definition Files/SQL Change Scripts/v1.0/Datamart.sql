USE [QP_Comments]
GO
/****** Object:  StoredProcedure [dbo].[DCL_ResetLitho]    Script Date: 09/20/2006 09:39:34 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DCL_ResetLitho]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[DCL_ResetLitho]
GO
/****** Object:  StoredProcedure [dbo].[DCL_ResetLitho]    Script Date: 09/20/2006 09:39:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Need to add a procedure to reset the survey on Qualysis            
CREATE PROCEDURE [dbo].[DCL_ResetLitho] @Litho VARCHAR(1100)            
AS            
            
DECLARE @Study INT, @SamplePop INT, @sql VARCHAR(8000), @Server VARCHAR(50), @InLitho VARCHAR(1500), @stn VARCHAR(100)            
            
-- Get the Qualysis server                  
SELECT @Server=strParam_Value FROM Datamart_Params WHERE strParam_nm='QualPro Server'                
            
-- Pad the litho list with quotes             
SELECT @InLitho = '''' + REPLACE(@litho,',',''',''') + ''''            
            
/*            
Need to            
Remove from:            
aggregate            
rollupn            
study_results            
study_results_vertical            
respratecount            
*/            
            
--If there are already work tables present, we want to kill the procedure            
IF EXISTS (SELECT * FROM SysObjects WHERE name = 'Study_Results_Vertical_Work')            
BEGIN            
 PRINT 'There are study_results_vertical_work tables already present.'            
 RETURN            
END            
            
IF EXISTS (SELECT * FROM SysObjects WHERE name = 'Study_Results_Work')            
BEGIN            
 PRINT 'There are study_results_work tables already present.'            
 RETURN            
END            
            
IF EXISTS (SELECT * FROM SysObjects WHERE name = 'Aggregate_Work')            
BEGIN            
 PRINT 'There are aggregate_work tables already present.'            
 RETURN            
END            
            
IF EXISTS (SELECT * FROM SysObjects WHERE name = 'RollupN_Work')            
BEGIN            
 PRINT 'There are rollupn_work tables already present.'            
 RETURN            
END            
            
--Now to get the study_id and samplepop_id for the given litho            
            
CREATE TABLE #all_sp (study_id INT, samplepop_id INT, strlithocode VARCHAR(10))            
CREATE TABLE #BTWork (studytablename VARCHAR(100), survey_id INT, samplepop_id INT, surveytype_id INT)            
CREATE TABLE #sp (study_id INT, samplepop_id INT)            
CREATE CLUSTERED INDEX cix_sp ON #sp (samplepop_id)            
SET @SQL = '            
 INSERT INTO #all_sp (study_id, samplepop_id, strlithocode) ' + CHAR(10) +            
 'SELECT sp.Study_id, sp.SamplePop_id, sm.strlithocode ' + CHAR(10) +             
 'FROM '+ @Server + 'QP_Prod.dbo.SentMailing sm, ' + @Server + 'QP_Prod.dbo.ScheduledMailing schm, '  + CHAR(10) +             
  @Server + 'QP_Prod.dbo.SamplePop sp '  + CHAR(10) +             
 'WHERE sm.strLithoCode IN (' + @InLitho + ')' +  CHAR(10) +             
 'AND sm.SentMail_id = schm.SentMail_id '  + CHAR(10) +             
 'AND schm.SamplePop_id = sp.SamplePop_id'            
EXEC (@sql)            
            
-- Log the information             
INSERT INTO LithoResetLog (study_id, samplepop_id, strlithocode, datReset)            
SELECT study_id, samplepop_id, strlithocode, GETDATE() AS datReset FROM #all_sp            
            
            
-- Now lets loop through one study @ a time to reset the study specific data.            
SELECT DISTINCT study_id INTO #study FROM #all_sp            
            
SELECT TOP 1 @study = study_id FROM #study            
WHILE @@ROWCOUNT > 0            
BEGIN            
            
 TRUNCATE TABLE #sp            
 INSERT INTO #sp (study_id, samplepop_id) SELECT study_id, samplepop_id FROM #all_sp WHERE study_id =  @study            
            
/*******************/            
            
 -- First Update the bitComplete and Disposition information for HCAHPS Lithos            
 DECLARE @bc VARCHAR(50), @hv VARCHAR(50), @ud VARCHAR(50), @df varchar(50), @dc VARCHAR(50)            
            
 -- Now lets set the bitComplete flag = NULL on the Big_Table record (and set the HDisposition to '08' ONLY FOR HCAHPS Surveys)            
 -- Find out where the data resides            
 TRUNCATE TABLE #BTWork            
 SET @SQL = ' INSERT INTO #BTWork (studytablename, survey_id, samplepop_id ) ' + CHAR(10) +           
 ' SELECT ''S'+CONVERT(VARCHAR,@Study) + '.'' + bt.tablename ' + '' + ' AS studytablename, bt.survey_id, bt.samplepop_id ' + CHAR(10) +     
 ' FROM S'+CONVERT(VARCHAR,@Study)+'.Big_Table_View bt INNER JOIN #sp sp on bt.samplepop_id = sp.samplepop_id'          
 EXEC (@sql)           
        
--  -- Determine the surveytype so we know if we need to reset the HDisposition (disposition) or NOT            
--  UPDATE dw SET dw.surveytype_id = css.surveytype_id FROM #BTWork dw INNER JOIN  clientstudysurvey css ON dw.survey_id = css.survey_id            
--             
--  -- Keep only HCAHPS surveys            
--  DELETE #BTWork WHERE surveytype_id <> 2            
             
 -- Now what tables have we            
 SELECT DISTINCT studytablename INTO #btu_loop FROM #BTWork            
            
 -- Now lets loop through the Big Tables and update specific columns if they exist            
 SELECT TOP 1 @stn = studytablename FROM #btu_loop            
 WHILE @@ROWCOUNT > 0            
 BEGIN            
  -- Find the columns that exist             
            
            
  SELECT @ud = column_name + '=NULL '  FROM information_schema.columns WHERE column_name = 'datUndeliverable' AND table_schema + '.' + table_name = @stn            
            
  SELECT @bc = column_name + '=NULL '  FROM information_schema.columns WHERE column_name = 'bitComplete' AND table_schema + '.' + table_name = @stn            
            
  SELECT @hv = column_name + '=''08'' ' FROM information_schema.columns WHERE column_name = 'HDisposition' AND table_schema + '.' + table_name = @stn            
        
  SELECT @df = column_name + '=NULL '  FROM information_schema.columns WHERE column_name = 'DaysFromFirstMailing' AND table_schema + '.' + table_name = @stn            
        
  SELECT @dc = column_name + '=NULL '  FROM information_schema.columns WHERE column_name = 'DaysFromCurrentMailing' AND table_schema + '.' + table_name = @stn            
        
            
  -- Update the columns that actualy exist            
  IF @ud IS NOT NULL OR @bc IS NOT NULL OR @hv IS NOT NULL             
  BEGIN            
   SET @sql = 'UPDATE bt SET ' + ISNULL( @ud,'') + ISNULL(', ' + @bc ,'') + ISNULL(', ' + @hv,'') + ISNULL(', ' + @df,'') + ISNULL(', ' + @dc,'') + ' FROM ' + @stn             
   + ' bt INNER JOIN #BTWork bw ON bt.samplepop_id = bw.samplepop_id AND bw.studytablename = ''' + @stn + ''''      
            
   --print @sql            
   EXEC(@sql)            
  END            
            
  DELETE FROM #btu_loop WHERE @stn = studytablename             
  SELECT TOP 1 @stn = studytablename FROM #btu_loop            
 END            
 DROP TABLE #btu_loop            
             
 -- Remove any complete/incomplete dispostions from the dispositionlog for the samplepops            
 DELETE dl FROM dispositionlog dl INNER JOIN #sp sp ON dl.samplepop_id = sp.samplepop_id             
 AND dl.disposition_id IN (SELECT disposition_id FROM Disposition WHERE HCAHPSValue IN ('01','06'))            
            
 -- Update the remaining dispostions to bitEvaluated = 0 so we can recalc the disposition for the BigTable record            
 UPDATE dl SET bitEvaluated = 0 FROM dispositionlog dl INNER JOIN #sp sp ON dl.samplepop_id = sp.samplepop_id            
            
 -- Now run the proc to evaluate dispostions with bitEvaluated = 0            
 EXEC dbo.SP_Extract_DispositionBigTable            
            
/*******************/            
            
 --NEXT need to move the records into study_results_work and study_results_vertical_work            
 SET @sql = 'SELECT dbo.YearQtr(datReportDate) QtrTable, sr.* ' + CHAR(10) +            
  ' INTO S'+CONVERT(VARCHAR,@Study)+'.Study_Results_Vertical_Work ' + CHAR(10) +            
  ' FROM S'+CONVERT(VARCHAR,@Study)+'.Study_Results_Vertical_View sr' + CHAR(10) +            
  ' INNER JOIN #sp sp ON sr.SamplePop_id = sp.samplepop_id'            
 EXEC (@sql)            
             
 SET @sql = 'SELECT dbo.YearQtr(datReportDate) QtrTable, sr.* ' + CHAR(10) +            
  ' INTO S'+CONVERT(VARCHAR,@Study)+'.Study_Results_Work ' + CHAR(10) +            
  ' FROM S'+CONVERT(VARCHAR,@Study)+'.Study_Results_View sr' + CHAR(10) +            
  ' INNER JOIN #sp sp ON sr.SamplePop_id = sp.samplepop_id'            
 EXEC (@sql)            
            
/*******************/            
             
 --Now to create the Aggregate and RollupN work tables            
 EXEC SP_Extract_PopulateAggregateWork            
 EXEC SP_Extract_RollupN            
             
 --Now to subtract the values from the actual aggregate and rollupn tables            
 EXEC SP_DBM_ReMoveFromAgg 'Aggregate' , @Study            
 EXEC SP_DBM_ReMoveFromRollUpN 'RollupN' , @Study            
             
/*******************/            
            
 --Subtract the return from RespRateCount            
 CREATE TABLE #RR (SampleSet_id INT, SampleUnit_id INT, Cnt INT)            
             
 SET @sql = 'INSERT INTO #rr ' + CHAR(10) +            
  ' SELECT bt.SampleSet_id, bt.SampleUnit_id, COUNT(*) ' + CHAR(10) +            
  ' FROM S'+CONVERT(VARCHAR,@Study)+'.Big_Table_View bt' + CHAR(10) +            
  ' INNER JOIN #sp sp ON bt.SamplePop_id = sp.samplepop_id' + CHAR(10) +            
  ' GROUP BY SampleSet_id, SampleUnit_id ' + CHAR(10) +            
  ' UNION  ' + CHAR(10) +            
  ' SELECT DISTINCT bt.SampleSet_id, 0, 1 ' + CHAR(10) +            
  ' FROM S'+CONVERT(VARCHAR,@Study)+'.Big_Table_View bt' + CHAR(10) +            
  ' INNER JOIN #sp sp ON bt.SamplePop_id = sp.samplepop_id'            
 EXEC (@sql)            
             
 UPDATE rr            
 SET rr.intReturned = rr.intReturned - Cnt            
 FROM RespRateCount rr, #rr t            
 WHERE t.SampleSet_id = rr.SampleSet_id            
 AND t.SampleUnit_id = rr.SampleUnit_id            
             
 DROP TABLE #rr            
            
/*******************/            
             
 --Now to delete the records from the live tables.            
 CREATE TABLE #Tables (TblName VARCHAR(100))            
             
 SET @sql = 'INSERT INTO #Tables SELECT Distinct ''S'+CONVERT(VARCHAR,@Study)+'.''+TableName FROM S'+CONVERT(VARCHAR,@Study)+'.Study_Results_View sr INNER JOIN #sp sp ON sr.SamplePop_id = sp.samplepop_id'            
             
 EXEC (@sql)            
             
 SET @sql = 'INSERT INTO #Tables SELECT Distinct ''S'+CONVERT(VARCHAR,@Study)+'.''+TableName FROM S'+CONVERT(VARCHAR,@Study)+'.Study_Results_Vertical_View sr INNER JOIN #sp sp ON sr.SamplePop_id = sp.samplepop_id'            
             
 EXEC (@sql)            
             
 DECLARE @TableName VARCHAR(110)            
             
 SELECT TOP 1 @TableName = TblName FROM #Tables            
             
 WHILE @@ROWCOUNT > 0            
 BEGIN            
             
  SET @sql = 'DELETE d FROM '+@TableName+' d INNER JOIN #sp sp ON d.SamplePop_id = sp.samplepop_id'            
  EXEC (@sql)            
             
  DELETE #Tables WHERE TblName = @TableName            
             
  SELECT TOP 1 @TableName = TblName FROM #Tables            
             
 END            
             
 DROP TABLE #Tables            
             
 --Drop the work tables            
 SET @sql = 'DROP TABLE S'+CONVERT(VARCHAR,@Study)+'.Study_Results_Work '+CHAR(10)+            
  'DROP TABLE S'+CONVERT(VARCHAR,@Study)+'.Study_Results_Vertical_Work '            
             
 EXEC (@sql)            
            
            
DELETE FROM #study WHERE study_id = @study            
SELECT TOP 1 @study = study_id FROM #study            
END            
          
DROP TABLE #all_sp            
DROP TABLE #study            
DROP TABLE #sp        
DROP TABLE #btwork        
      
GO
/****** Object:  Table [dbo].[LithoResetLog]    Script Date: 09/20/2006 10:23:51 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[LithoResetLog]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[LithoResetLog]    


GO
/****** Object:  Table [dbo].[LithoResetLog]    Script Date: 09/20/2006 10:06:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LithoResetLog](
	[study_id] [int] NULL,
	[samplepop_id] [int] NULL,
	[strlithocode] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datReset] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
