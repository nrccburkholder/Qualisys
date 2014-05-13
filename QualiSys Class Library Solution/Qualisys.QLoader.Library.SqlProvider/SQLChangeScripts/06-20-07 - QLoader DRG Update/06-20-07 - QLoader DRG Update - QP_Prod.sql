USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[LD_UpdateDRG]    Script Date: 07/31/2007 13:33:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LD_UpdateDRG]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[LD_UpdateDRG]

USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[LD_UpdateDRG]    Script Date: 07/31/2007 13:27:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LD_UpdateDRG] @Study_ID int, @DataFile_id int  
AS  
  
  
-- Developed by DK 9/2006  
-- Created by SJS 10/12/2006  
-- Modified by dmp 11/09/2006: un-commented code for deleting records > 42 days old  
-- Modified by dmp 12/15/2006: commented out code for deleting recs >42 days old, per new reqs from CS  
-- Renamed by ADL 06/20/2007: added the record count log dataset  
-- Purpose: Update Study background data in Qualysis and Datamart for a specified Study and Datafile in the QP_Load DB.  
  
DECLARE @MCond varchar(200), @LTime datetime, @DataMart varchar(50)  
DECLARE @Owner varchar(10), @Sql varchar(8000), @Now datetime, @BTableName varchar(100), @Server VARCHAR(20)  
SET @Owner = 'S'+RTRIM(LTRIM(STR(@Study_ID)))  
SET @Server = (SELECT strparam_value from qualpro_params where strparam_nm = 'QLoader')  
  
-- Setup messagelog  
CREATE TABLE #log (RecordType varchar(100), RecordsValue VArchar(50))  
  
--*************************************** Get the work data ********************************  
--PRINT 'Get work data ...'  
--Create the work table  
CREATE TABLE #Work (DRG varchar(3), HServiceType varchar(42), Enc_id int)  
  
--Get data  
SET @MCond = ''  
SELECT @MCond = @MCond +' L.' + strField_Nm + '=E.' + strField_Nm + ' AND'  
FROM Metatable t, Metastructure s, metafield f  
WHERE t.table_id = s.table_id and  
 f.field_id = s.field_id and  
 s.bitMatchfield_flg = 1 and   
 t.strTable_nm = 'Encounter' and  
 t.study_id = @Study_ID  
SET @MCond = SUBSTRING(@MCond, 1, LEN(@MCond)-3)  
  
SET @Sql = 'INSERT #Work (DRG, HServiceType, Enc_ID) ' +   
   ' SELECT L.DRG, L.HServiceType, E.Enc_id ' +  
   ' FROM ' + @server + '.QP_Load.'+@Owner+'.encounter_load L INNER JOIN '+@Owner+ '.Encounter E ON ' + @MCond +  
   ' WHERE (((E.DRG IS Null OR E.DRG = ''0'' OR E.DRG=''000'') AND (L.DRG IS NOT NULL AND L.DRG != ''0'' AND L.DRG != ''000'')) OR ' +  
   ' ((E.HServiceType IS NULL OR E.HServiceType = ''9'') AND (L.HServiceType IS NOT NULL AND L.HServiceType != ''9''))) AND ' +  
   ' L.DataFile_ID = ' +LTRIM(STR(@DataFile_ID))  
  
EXEC (@Sql)  
-- ****************************** Check to see if #Work has records and log if 0 ************************  
SELECT TOP 1 DRG FROM #WORK  
IF @@ROWCOUNT = 0  
BEGIN  
-- Update #Log  
 INSERT INTO #Log (RecordType, RecordsValue)  
       Select 'Matching Records With Updates:',  LTRIM(STR(@@ROWCOUNT))       
END   
-- **********************************************************************************************  
--SELECT * FROM #Work --for checking  
  
--************************************** Get Data File loading time server name *****************  
  
CREATE TABLE #lt (ltime datetime)  
SET @sql = 'SELECT datReceived from ' + @server + '.QP_Load.dbo.datafile WHERE DataFile_id = ' + CONVERT(VARCHAR,@DataFile_ID)  
INSERT INTO #LT (ltime) EXEC (@sql)  
SELECT @ltime = ltime FROM #lt   
DROP TABLE #lt  
  
SELECT @DataMart = strParam_Value FROM QualPro_Params WHERE strParam_nm = 'DataMart'   
  
--************************************** Update non-Sampled *************************************  
/*  
SET @Sql = 'UPDATE e SET DRG = w.DRG, HServiceType = w.HServiceType ' +  
   ' FROM '+@Owner+'.Encounter e INNER JOIN #Work w ON e.Enc_id = w.Enc_id ' +  
   ' WHERE w.Enc_id NOT IN (SELECT Enc_ID FROM SelectedSample WHERE Study_ID = '+LTRIM(STR(@Study_ID))+')'  
EXEC (@Sql)  
  
PRINT LTRIM(STR(@@ROWCOUNT))+' non-sampled Encounter records have been updated.'  
*/  
  
  
--************************************** Update sampled records *********************  
--Create a temp table to hold all samplepops  
CREATE TABLE #SPs (SampleUnit_ID int, SamplePop_ID int, Enc_ID int, DaysFromFirst int,   
    ReportDate DateTime, BigTableName varchar(100), SentMail_id int, EncDate Datetime)  
  
--Get all enc_id with SampleUnit.bitHCAHPS = 1  
INSERT #SPs (SampleUnit_ID, SamplePop_ID, Enc_ID, ReportDate,EncDate)  
 SELECT su.SampleUnit_ID, sp.SamplePop_ID, ss.Enc_ID, ss.ReportDate, ss.SampleEncounterDate   
 FROM SampleUnit su, SelectedSample ss, SamplePop sp  
 WHERE su.SampleUnit_id = ss.SampleUnit_id and  
  ss.Sampleset_id = sp.Sampleset_id and  
  ss.Pop_id = sp.Pop_id and   
  su.bitHCAHPS = 1 and  
  ss.Study_id = @Study_id and   
  ss.Enc_id in (SELECT Enc_id FROM #Work)  
  
-- ******************************** Check to see if #SPs had records and log if 0 *************  
SELECT TOP 1 SampleUnit_ID FROM #Sps  
IF @@ROWCOUNT = 0  
BEGIN  
-- Update #Log  
 INSERT INTO #Log (RecordType, RecordsValue)  
       Select 'Matching Records Sampled for an HCAHPS Unit:',  LTRIM(STR(@@ROWCOUNT))       
  
  
END   
  
Select min(EncDate) AS FirstEncDate, max(Encdate) AS LastEncDate into #EncounterDates from #Sps  
  
INSERT INTO #Log (RecordType, RecordsValue)  
       Select 'Encounter Date Range:',  Convert(VarChar,FirstEncDate,101) + ' to ' +Convert(VarChar,LastEncDate,101)  FROM #EncounterDates       
    
  
--***********************************************************************************************  
--Update the DaysFromFirst  
UPDATE s SET DaysFromFirst = df.DaysFromFirst  
 FROM #SPS s INNER JOIN  
 (SELECT sps.SamplePop_ID, MAX(DATEDIFF(DAY,CONVERT(DATETIME,CONVERT(VARCHAR(10),(datMailed),120)),@LTime)) as DaysFromFirst  
 FROM #SPs sps, ScheduledMailing sd, SentMailing st  
 WHERE sps.SamplePop_id = sd.SamplePop_id and  
  sd.SentMail_id = st.SentMail_id  
 Group by sps.SamplePop_ID) df ON s.SamplePop_ID = df.SamplePop_Id  
  
  
  
  
/***************No longer omitting these records ********  
--Remove the records showing DaysFromFirst>42  
DELETE FROM #SPs WHERE DaysFromFirst>42  
********************************************************/  
  
  
--Update the big table names  
UPDATE #SPs SET BigTableName = 'Big_Table_'+(ISNULL((CONVERT(VARCHAR,YEAR(ReportDate)) + '_' + CONVERT(VARCHAR,DATEPART(QUARTER,(ReportDate)))),'NULL'))  
  
--Update Sentmail ID  
UPDATE sps SET SentMail_ID = sm.SentMail_id  
 FROM #SPs sps inner join ScheduledMailing sm on sps.SamplePop_id =sm.SamplePop_id  
 WHERE sm.SentMail_id is not NULL  
  
--SELECT * FROM #SPs --for checking  
  
--Log DRG data changes  
SET @Sql = 'INSERT HCAHPSUpdateLog (samplepop_id, field_name, old_value, new_value, Change_Date) ' +   
   ' SELECT DISTINCT sps.SamplePop_id, ''DRG'', e.DRG, w.DRG, GETDATE() ' +  
   ' FROM #SPs sps INNER JOIN #Work w ON sps.Enc_ID = w.Enc_ID ' +  
   '  INNER JOIN '+@Owner+'.Encounter e ON w.Enc_ID = e.Enc_ID'  
EXEC (@Sql)  
--PRINT 'DRG changes logged.'  
  
--Log HServiceType data changes  
SET @Sql = 'INSERT HCAHPSUpdateLog (samplepop_id, field_name, old_value, new_value, Change_Date) ' +   
   ' SELECT DISTINCT sps.SamplePop_id, ''HServiceType'', e.HServiceType, w.HServiceType, GETDATE() ' +  
   ' FROM #SPs sps INNER JOIN #Work w ON sps.Enc_ID = w.Enc_ID ' +  
   '  INNER JOIN '+@Owner+'.Encounter e ON w.Enc_ID = e.Enc_ID'  
EXEC (@Sql)  
  
--PRINT 'HServiceType changes logged.'  
  
  
  
--Log Disposition if there is any  
  
INSERT DispositionLog (SentMail_id, SamplePop_id, Disposition_id, ReceiptType_id,   
 datLogged, LoggedBy)        
SELECT DISTINCT sps.SentMail_ID, sps.SamplePop_ID, 8, 0, @LTime, 'DBA'   
 FROM #SPs sps INNER JOIN #Work w ON sps.enc_id = w.enc_id   
 WHERE w.HServiceType = 'X'  
  
  
-- Need to run an update against the newly inserted records, because the function requires that the record already exist in the DispositionLog, rather can calc @ time of insertion.  
UPDATE DL SET   
  DaysFromFirst   =  dbo.fn_DispDaysFromFirst(dl.SentMail_ID,@LTime,8),     
  DaysFromCurrent =  dbo.fn_DispDaysFromCurrent(dl.SentMail_ID,@LTime,8)  
FROM DispositionLog DL   
INNER JOIN #SPs sps ON dl.sentmail_id = sps.sentmail_id and dl.samplepop_id = sps.samplepop_id and dl.disposition_id = 8 and dl.receipttype_Id = 0 AND dl.datLogged = @LTime  
INNER JOIN #Work w ON sps.enc_id = w.enc_id   
WHERE w.HServiceType = 'X'  
  
-- Update #Log  
INSERT INTO #Log (RecordType, RecordsValue)  
    Select 'Disposition Records Inserted:',LTRIM(STR(@@ROWCOUNT))  
 --SELECT LTRIM(STR(@@ROWCOUNT))+' disposition records inserted.'  
  
--PRINT LTRIM(STR(@@ROWCOUNT))+' disposition records inserted.'  
  
--Update Encounter table   
  
SET @Sql = 'UPDATE e SET DRG = w.DRG, HServiceType = w.HServiceType ' +  
   ' FROM #SPs sps INNER JOIN #Work w ON sps.Enc_ID = w.Enc_ID ' +  
   '  INNER JOIN '+@Owner+'.Encounter e ON w.Enc_ID = e.Enc_ID'  
EXEC (@Sql)  
  
-- Update #Log  
  
  
INSERT INTO #Log (RecordType, RecordsValue)  
   Select 'Encounter Records Updated:',LTRIM(STR(@@ROWCOUNT))  
 --SELECT LTRIM(STR(@@ROWCOUNT))+' disposition records inserted.'  
  
--PRINT LTRIM(STR(@@ROWCOUNT))+' sampled Encounter records have been updated.'  
  
  
  
--Update Datamart big tables  
CREATE TABLE #BTableNames (BigTableName varchar(100))  
  
INSERT #BTableNames (BigTableName)  
 SELECT DISTINCT BigTableName FROM #SPs  
  
SELECT TOP 1 @BTableName = BigTableName FROM #BTableNames   
WHILE @@ROWCOUNT > 0  
BEGIN  
 --Update datamart big table   
 SET @Sql = 'UPDATE b SET DRG = w.DRG, HServiceType = w.HServiceType ' +  
    ' FROM #SPs sps INNER JOIN #Work w ON sps.Enc_ID = w.Enc_ID ' +  
    '  INNER JOIN '+@DataMart+'.QP_Comments.'+@Owner+'.'+@BTableName+' b ON b.SamplePop_id = sps.SamplePop_id '  
 EXEC (@Sql)  
  
  
-- Update #Log  
 INSERT INTO #Log (RecordType, RecordsValue)  
       Select 'Records in '+@BTableName + ':',  LTRIM(STR(@@ROWCOUNT))
  
--SELECT LTRIM(STR(@@ROWCOUNT))+' records in '+@BTableName + ' have been updated.'  
  
 --PRINT LTRIM(STR(@@ROWCOUNT))+' records in '+@BTableName + ' have been updated.'  
  
 --Remove the finished big table  
 DELETE FROM #BTableNames WHERE BigTableName = @BTableName  
 SELECT TOP 1 @BTableName = BigTableName FROM #BTableNames   
END   
  
-- Return the #Log Dataset  
SELECT * FROM #Log  
  
-- If any error stop here for manual checking  
IF @@ERROR<>0   
BEGIN  
 --PRINT 'There is an error updating datamart, please check....'  
 RETURN  
END  
  
  
--************************************** Drop Work Tables ****************************  
  
DROP TABLE #SPs  
DROP TABLE #BTableNames  
DROP TABLE #Work  
DROP TABLE #Log  
DROP TABLE #EncounterDates  
  
GO
