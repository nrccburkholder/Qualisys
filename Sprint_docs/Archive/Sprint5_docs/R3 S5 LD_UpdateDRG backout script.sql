USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[LD_UpdateDRG]    Script Date: 8/14/2014 4:09:00 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
ALTER PROCEDURE [dbo].[LD_UpdateDRG] @Study_ID int, @DataFile_id int        
AS        
        
begin        
 -- Developed by DK 9/2006        
 -- Created by SJS 10/12/2006        
 -- Modified by dmp 11/09/2006: un-commented code for deleting records > 42 days old        
 -- Modified by dmp 12/15/2006: commented out code for deleting recs >42 days old, per new reqs from CS        
 -- Renamed by ADL 06/20/2007: added the record count log dataset        
 -- ReOrganized by MWB 10/25/07: This procedure is now the driver for DRG and MSDRG updates.  It will check the QLoader    
 --        Qualisys DB to make sure the fields exist.  if they do then the appopriate DRG update    
 --        worker (_Updater) procedure is called, if not it is skipped.    
 -- Purpose: Update Study background data in Qualysis and Datamart for a specified Study and Datafile in the QP_Load DB.        
    
     
 --create the #log table that each of the Update SPs will use.    
 CREATE TABLE #log (RecordType varchar(100), RecordsValue VArchar(50))        
    
    
 if exists (select 'x' from MetaData_view where Study_ID = @Study_ID and strField_nm = 'DRG')    
  begin    
   exec LD_UpdateDRG_Updater @Study_ID , @DataFile_id     
  end     
 else    
  insert into #log (RecordType, RecordsValue) values ('DRG Update Failed', 'Your study does not contain a DRG field.')    
    
    
 if exists (select 'x' from MetaData_view where Study_ID = @Study_ID and strField_nm = 'MSDRG')    
  begin    
   exec LD_UpdateMSDRG_Updater @Study_ID , @DataFile_id     
  end     
 else    
  insert into #log (RecordType, RecordsValue) values ('MSDRG Update Failed', 'Your study does not contain a MSDRG field.')    
     
    
 SELECT * FROM #LOG    
 drop table #log    
    
end
GO


USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[LD_UpdateDRG_Updater]    Script Date: 8/14/2014 4:09:11 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

   
    
    
ALTER PROCEDURE [dbo].[LD_UpdateDRG_Updater] @Study_ID int, @DataFile_id int                      
AS                      
                      
                      
-- Developed by DK 9/2006                      
-- Created by SJS 10/12/2006                      
-- Purpose: Update Study background data in Qualysis and Datamart for a specified Study and Datafile in the QP_Load DB.

-- Modified by dmp 11/09/2006: un-commented code for deleting records > 42 days old                      
-- Modified by dmp 12/15/2006: commented out code for deleting recs >42 days old, per new reqs from CS                      
-- Renamed by ADL 06/20/2007:  added the record count log dataset                      
-- Modifed by MWB 10/30/2007:  This is now a sub SP that is called by LD_UpdateDRG.  The #log table is now created               
--          and destroyed in the calling procedure.  There is a mirror SP called LD_UpdateDRG              
--          that should be the EXACT same code except replace DRG with DRG              
-- Modified by MWB 03/31/2009: Uncommented the "Update non-Sampled" section as we now want         
--   to update sampled and non sampled records        
-- Modified by MWB 07/30/2009: Modified the Update non-Sampled code to improve performance  
-- Modified by MWB 11/19/2009: Added source column to ExtractQueue insert to track source of key values being added.                      
                      
DECLARE @MCond varchar(200), @LTime datetime, @DataMart varchar(50)                      
DECLARE @Owner varchar(10), @Sql varchar(8000), @Now datetime, @BTableName varchar(100), @Server VARCHAR(20)                      
declare @FieldExists smallint, @FieldExists2 smallint, @FieldExists3 smallint                  
                  
declare @VarOwner varchar(50)                    
declare @varBTableName varchar(100)                    
declare @myRowCount int    
                  
SET @Owner = 'S'+RTRIM(LTRIM(STR(@Study_ID)))                      
SET @Server = (SELECT strparam_value from qualpro_params where strparam_nm = 'QLoader')                      
                  
-- create all tables needed up front              
-- 10/30/07 MWB now done in Calling procedure (LD_UpdateDRG)                    
--CREATE TABLE #log (RecordType varchar(100), RecordsValue VArchar(50))                      
CREATE TABLE #Work (DRG varchar(3), HServiceType varchar(42), Enc_id int)                      
CREATE TABLE #lt (ltime datetime)                      
CREATE TABLE #BTableNames (BigTableName varchar(100))                   
CREATE TABLE #SPs (SampleUnit_ID int, SamplePop_ID int, Enc_ID int, DaysFromFirst int,                       
    ReportDate DateTime, BigTableName varchar(100), SentMail_id int, EncDate Datetime)                      
CREATE TABLE #CatalsytWork (Study_ID int, Pop_ID int, Enc_ID int)                  
                  
exec @FieldExists = QLoader.QP_Load.dbo.columnAlreadyExists @owner,'Encounter_load','DRG'                    
exec @FieldExists2 = dbo.columnAlreadyExists @owner,'Encounter','DRG'                    
                  
                  
if @FieldExists <> 1                   
begin                  
 --print 'fieldexists ' + cast(@FieldExists as varchar(20))                  
 INSERT INTO #Log (RecordType, RecordsValue)                      
       Select 'DRG field not found in QP_Load.Encounter_Load table',' '                           
end                  
                  
if @FieldExists2 <> 1                   
begin                  
 --print 'fieldexists2 ' + cast(@FieldExists2 as varchar(20))                  
 INSERT INTO #Log (RecordType, RecordsValue)                      
       Select 'DRG field not found in QP_Prod.Encounter table',' '                            
end                  
                  
if @FieldExists <> 1 or @FieldExists2 <> 1                   
 goto ExitDRGUpdate                  
                      
--*************************************** Get the work data ********************************                      
PRINT 'Get work data ...'                         
                      
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
                      
--SET @Sql = 'INSERT #Work (DRG, HServiceType, Enc_ID) ' +                       
--   ' SELECT L.DRG, L.HServiceType, E.Enc_id ' +                      
--   ' FROM ' + @server + '.QP_Load.'+@Owner+'.encounter_load L INNER JOIN '+@Owner+ '.Encounter E ON ' + @MCond +                      
--   ' WHERE (((E.DRG IS Null OR E.DRG = ''0'' OR E.DRG=''000'') AND (L.DRG IS NOT NULL AND L.DRG != ''0'' AND L.DRG != ''000'')) OR ' +                      
--   ' ((E.HServiceType IS NULL OR E.HServiceType = ''9'') AND (L.HServiceType IS NOT NULL AND L.HServiceType != ''9''))) AND ' +                      
--   ' L.DataFile_ID = ' +LTRIM(STR(@DataFile_ID))                           
--EXEC (@Sql)              
          
SET @Sql = 'INSERT #Work (DRG, HServiceType, Enc_ID) ' +                         
   ' SELECT L.DRG, L.HServiceType, E.Enc_id ' +                        
   ' FROM ' + @server + '.QP_Load.'+@Owner+'.encounter_load L INNER JOIN '+@Owner+ '.Encounter E ON ' + @MCond +                        
   ' WHERE  ((L.DRG IS NOT NULL AND L.DRG != ''0'' AND L.DRG != ''000'') and (L.HServiceType IS NOT NULL AND L.HServiceType != ''9'')) and L.DataFile_ID = ' +LTRIM(STR(@DataFile_ID))                             
EXEC (@Sql)         
  
SET @Sql = 'INSERT #CatalsytWork (Study_ID, Pop_ID, Enc_ID ) ' +                     
   ' SELECT ' + cast(@Study_ID as varchar(10)) + ', E.Pop_ID, E.Enc_id ' +                    
   ' FROM ' + @server + '.QP_Load.'+@Owner+'.encounter_load L INNER JOIN '+@Owner+ '.Encounter E ON ' + @MCond +                    
   ' WHERE  ((L.DRG IS NOT NULL AND L.DRG != ''0'' AND L.DRG != ''000'') and (L.HServiceType IS NOT NULL AND L.HServiceType != ''9'')) and L.DataFile_ID = ' +LTRIM(STR(@DataFile_ID))  
EXEC (@Sql)         
                          
-- ****************************** Check to see if #Work has records and log if 0 ************************                      
    
set @myRowCount = @@ROWCOUNT    
    
SELECT TOP 1 DRG FROM #WORK                      
IF @@ROWCOUNT = 0                      
BEGIN                      
-- Update #Log                      
 INSERT INTO #Log (RecordType, RecordsValue)                      
       Select 'DRG: Matching Records With Updates:',  LTRIM(STR(@myRowCount))                           
END       
    
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'DRG: Matching Records With Updates:' + LTRIM(STR(@myRowCount))     
                    
-- **********************************************************************************************                      
--SELECT * FROM #Work --for checking                      
                      
--************************************** Get Data File loading time server name *****************                      
                      
                  
SET @sql = 'SELECT datReceived from ' + @server + '.QP_Load.dbo.datafile WHERE DataFile_id = ' + CONVERT(VARCHAR,@DataFile_ID)                      
INSERT INTO #LT (ltime) EXEC (@sql)                      
SELECT @ltime = ltime FROM #lt                       
DROP TABLE #lt                      
                      
SELECT @DataMart = strParam_Value FROM QualPro_Params WHERE strParam_nm = 'DataMart'                       
                      
--************************************** Update non-Sampled *************************************                      
                      
--mwb 7-30-09 modified for performance reasons.          
--SET @Sql = 'UPDATE e SET DRG = w.DRG, HServiceType = w.HServiceType ' +                    
--   ' FROM '+@Owner+'.Encounter e INNER JOIN #Work w ON e.Enc_id = w.Enc_id ' +                    
--   ' WHERE w.Enc_id NOT IN (SELECT Enc_ID FROM SelectedSample WHERE Study_ID = '+LTRIM(STR(@Study_ID))+')'                    
--EXEC (@Sql)                    
  
SET @Sql = 'UPDATE e SET DRG = w.DRG, HServiceType = w.HServiceType ' +   
' FROM '+@Owner+'.Encounter e INNER JOIN #Work w ON e.Enc_id = w.Enc_id ' +     
'LEFT JOIN SelectedSample ss (NOLOCK) ON e.Enc_id = ss.Enc_id and ss.Study_ID = '+LTRIM(STR(@Study_ID)) +       
'where ss.enc_id is null'  

EXEC (@Sql)
    
set @myRowCount = @@ROWCOUNT    
                      
PRINT LTRIM(STR(@@ROWCOUNT))+' non-sampled Encounter records have been updated.'                      
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) select @study_ID, @DataFile_ID,  LTRIM(STR(@myRowCount))+' non-sampled Encounter records have been updated.'    
                      
                      
--************************************** Update sampled records *********************                      
--Create a temp table to hold all samplepops                      
                      
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
    
set @myRowCount = @@ROWCOUNT    
    
SELECT TOP 1 SampleUnit_ID FROM #Sps                      
IF @myRowCount = 0                      
BEGIN                      
-- Update #Log                      
 INSERT INTO #Log (RecordType, RecordsValue)                      
    Select 'DRG: Matching Records Sampled for an HCAHPS Unit:',  LTRIM(STR(@myRowCount))                              
        
    insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'DRG: Matching Records Sampled for an HCAHPS Unit: ' +  LTRIM(STR(@myRowCount))                              
    
END                       
                      
Select min(EncDate) AS FirstEncDate, max(Encdate) AS LastEncDate into #EncounterDates from #Sps                      
                      
INSERT INTO #Log (RecordType, RecordsValue)                      
Select 'DRG: Encounter Date Range:',  isnull(Convert(VarChar,FirstEncDate,101) + ' to ' +Convert(VarChar,LastEncDate,101), '0')  FROM #EncounterDates                           
    
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'DRG: Encounter Date Range: ' +  isnull(Convert(VarChar,FirstEncDate,101) + ' to ' +Convert(VarChar,LastEncDate,101), '0')  FROM #EncounterDates                
  
           
                      
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
--print @SQL                  
EXEC (@Sql)                                  
               
set @myRowCount = @@ROWCOUNT    
               
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'INSERT HCAHPSUpdateLog DRG Records Updated: ' + + LTRIM(STR(@myRowCount))     
               
                      
--Log HServiceType data changes                      
SET @Sql = 'INSERT HCAHPSUpdateLog (samplepop_id, field_name, old_value, new_value, Change_Date) ' +                       
   ' SELECT DISTINCT sps.SamplePop_id, ''HServiceType'', e.HServiceType, w.HServiceType, GETDATE() ' +                      
   ' FROM #SPs sps INNER JOIN #Work w ON sps.Enc_ID = w.Enc_ID ' +                      
   '  INNER JOIN '+@Owner+'.Encounter e ON w.Enc_ID = e.Enc_ID'                      
EXEC (@Sql)                      
    
set @myRowCount = @@ROWCOUNT    
                      
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'INSERT HCAHPSUpdateLog HServiceType Records Updated: ' + + LTRIM(STR(@myRowCount))                       
                      
                      
--Log Disposition if there is any                      
          
          
SELECT DISTINCT sps.SentMail_ID, sps.SamplePop_ID, 8, 0, @LTime, 'DBA'                       
 FROM #SPs sps INNER JOIN #Work w ON sps.enc_id = w.enc_id                       
 WHERE w.HServiceType = 'X'               
                      
INSERT DispositionLog (SentMail_id, SamplePop_id, Disposition_id, ReceiptType_id,                       
 datLogged, LoggedBy)              
SELECT DISTINCT sps.SentMail_ID, sps.SamplePop_ID, 8, 0, @LTime, 'DBA'                       
 FROM #SPs sps INNER JOIN #Work w ON sps.enc_id = w.enc_id                       
 WHERE w.HServiceType = 'X'                      
    
set @myRowCount = @@ROWCOUNT    
                      
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'INSERT DispositionLog Records Updated: ' + + LTRIM(STR(@myRowCount))                       
          
                      
-- Need to run an update against the newly inserted records,               
--because the function requires that the record already exist in the DispositionLog,               
--rather can calc @ time of insertion.                      
          
UPDATE DL SET                       
  DaysFromFirst   =  dbo.fn_DispDaysFromFirst(dl.SentMail_ID,@LTime,8),                         
  DaysFromCurrent =  dbo.fn_DispDaysFromCurrent(dl.SentMail_ID,@LTime,8)                      
FROM DispositionLog DL                       
INNER JOIN #SPs sps ON dl.sentmail_id = sps.sentmail_id and dl.samplepop_id = sps.samplepop_id and dl.disposition_id = 8 and dl.receipttype_Id = 0 AND dl.datLogged = @LTime                      
INNER JOIN #Work w ON sps.enc_id = w.enc_id                       
WHERE w.HServiceType = 'X'                      
                 
    
set @myRowCount = @@ROWCOUNT    
            
-- Update #Log                      
INSERT INTO #Log (RecordType, RecordsValue)                      
    Select 'DRG: Disposition Records Inserted:',LTRIM(STR(@myRowCount))         
    
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'DRG: Disposition Records Inserted: ' + + LTRIM(STR(@myRowCount))                       
        
                     
 --SELECT LTRIM(STR(@@ROWCOUNT))+' disposition records inserted.'                      
                      
--PRINT LTRIM(STR(@@ROWCOUNT))+' disposition records inserted.'                      
                      
--Update Encounter table                       
                  
          
                      
SET @Sql = 'UPDATE e SET DRG = w.DRG, HServiceType = w.HServiceType ' +                      
   ' FROM #SPs sps INNER JOIN #Work w ON sps.Enc_ID = w.Enc_ID ' +                      
   '  INNER JOIN '+@Owner+'.Encounter e ON w.Enc_ID = e.Enc_ID'                      
EXEC (@Sql)                      
          
-- Update #Log                      
set @myRowCount = @@ROWCOUNT    
                              
INSERT INTO #Log (RecordType, RecordsValue)                      
   Select 'DRG: Encounter Records Updated: ',LTRIM(STR(@myRowCount))       
       
   insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'DRG: Encounter Records Updated: ' + + LTRIM(STR(@myRowCount))                       
                   
 --SELECT LTRIM(STR(@@ROWCOUNT))+' disposition records inserted.'                      
                      
--PRINT LTRIM(STR(@@ROWCOUNT))+' sampled Encounter records have been updated.'                      
                      
                      
                      
--Update Datamart big tables                         
print 'Updating DataMart...'           
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'Updating Data Mart Now'    
       
INSERT #BTableNames (BigTableName)                      
 SELECT DISTINCT BigTableName FROM #SPs                      
                      
SELECT TOP 1 @BTableName = BigTableName FROM #BTableNames                       
WHILE @@ROWCOUNT > 0                      
BEGIN                      
                  
exec @FieldExists3 = DataMart.QP_Comments.dbo.columnAlreadyExists  @Owner ,@BTableName ,'DRG'                        
if @FieldExists3 <> 1                   
 begin    
  INSERT INTO #Log (RecordType, RecordsValue)                      
  Select 'DRG field not found in QP_Comments.' + @Owner + '.' + @BTableName,' '                            
    end    
    
    
             
set @FieldExists3 = 0                  
                  
 --Update datamart big table                       
 SET @Sql = 'UPDATE b SET DRG = w.DRG, HServiceType = w.HServiceType ' +                      
    ' FROM #SPs sps INNER JOIN #Work w ON sps.Enc_ID = w.Enc_ID ' +                      
    '  INNER JOIN '+@DataMart+'.QP_Comments.'+@Owner+'.'+@BTableName+' b ON b.SamplePop_id = sps.SamplePop_id '                       
 EXEC (@Sql)                      
                 
set @myRowCount = @@ROWCOUNT    
                      
-- Update #Log                      
 INSERT INTO #Log (RecordType, RecordsValue)                      
       Select 'DRG: Records in '+@BTableName + ': ',  LTRIM(STR(@myRowCount))                    
    
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'DRG: Records in '+@BTableName + ': ' + + LTRIM(STR(@myRowCount))                       
                      
--SELECT LTRIM(STR(@@ROWCOUNT))+' records in '+@BTableName + ' have been updated.'                      
                      
 --PRINT LTRIM(STR(@@ROWCOUNT))+' records in '+@BTableName + ' have been updated.'                      
                      
 --Remove the finished big table                      
 DELETE FROM #BTableNames WHERE BigTableName = @BTableName                      
 SELECT TOP 1 @BTableName = BigTableName FROM #BTableNames                       
END                       
  
--insert into Catalyst extract queue so MSDRG will be updated    
insert NRC_DataMart_ETL.dbo.ExtractQueue (EntityTypeID, PKey1, PKey2, IsMetaData, Source)      
select distinct 7, sp.SAMPLEPOP_ID, NULL, 0, 'LD_UpdateDRG_Updater'      
from  #CatalsytWork cw, samplepop sp, selectedsample ss    
where sp.study_Id = ss.study_ID and    
 sp.pop_ID = ss.pop_ID and    
 cw.study_ID = sp.study_ID and    
 cw.pop_Id = sp.pop_ID and    
 cw.enc_Id = ss.enc_ID    
  
                  
ExitDRGUpdate:                  
    
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'DRG update Completed'    
                      
-- 10/30/07 MWB now done in Calling procedure (LD_UpdateDRG)              
-- Return the #Log Dataset                      
--SELECT * FROM #Log                      
                      
-- If any error stop here for manual checking                      
IF @@ERROR<>0                       
BEGIN                      
 PRINT 'There is an error updating datamart, please check....'                      
 RETURN                      
END                      
                      
                      
--************************************** Drop Work Tables ****************************                      
                      
IF OBJECT_ID('tempdb..#SPs') IS NOT NULL DROP TABLE #SPs                      
IF OBJECT_ID('tempdb..#BTableNames') IS NOT NULL DROP TABLE #BTableNames                      
IF OBJECT_ID('tempdb..#Work') IS NOT NULL DROP TABLE #Work                      
-- 10/30/07 MWB now done in Calling procedure (LD_UpdateDRG)              
--DROP TABLE #Log                      
IF OBJECT_ID('tempdb..#EncounterDates') IS NOT NULL DROP TABLE #EncounterDates 
GO

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[LD_UpdateMSDRG_Updater]    Script Date: 8/14/2014 4:09:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

     
      
CREATE PROCEDURE [dbo].[LD_UpdateMSDRG_Updater] @Study_ID int, @DataFile_id int                      
AS                      
                      
                      
-- Developed by DK 9/2006                      
-- Created by SJS 10/12/2006                      
-- Purpose: Update Study background data in Qualysis and Datamart for a specified Study and Datafile in the QP_Load DB.                      
-- Modified by dmp 11/09/2006: un-commented code for deleting records > 42 days old                      
-- Modified by dmp 12/15/2006: commented out code for deleting recs >42 days old, per new reqs from CS                      
-- Renamed by ADL 06/20/2007:  added the record count log dataset                      
-- Modifed by MWB 10/30/2007:  This is now a sub SP that is called by LD_UpdateMSDRG.  The #log table is now created               
--          and destroyed in the calling procedure.  There is a mirror SP called LD_UpdateDRG              
--          that should be the EXACT same code except replace MSDRG with DRG              
-- Modified by MWB 03/31/2009: Uncommented the "Update non-Sampled" section as we now want         
--   to update sampled and non sampled records    
-- Modified by MWB 07/30/2009: Modified the Update non-Sampled code to improve performance   
-- Modified by MWB 11/19/2009: Added source column to ExtractQueue insert to track source of key values being added.                                              

DECLARE @MCond varchar(200), @LTime datetime, @DataMart varchar(50)                      
DECLARE @Owner varchar(10), @Sql varchar(8000), @Now datetime, @BTableName varchar(100), @Server VARCHAR(20)                      
declare @FieldExists smallint, @FieldExists2 smallint, @FieldExists3 smallint                  
                  
declare @VarOwner varchar(50)                    
declare @varBTableName varchar(100)                    
declare @myRowCount int    
                  
SET @Owner = 'S'+RTRIM(LTRIM(STR(@Study_ID)))                      
SET @Server = (SELECT strparam_value from qualpro_params where strparam_nm = 'QLoader')                      
                  
-- create all tables needed up front              
-- 10/30/07 MWB now done in Calling procedure (LD_UpdateMSDRG)                    
--CREATE TABLE #log (RecordType varchar(100), RecordsValue VArchar(50))                      
CREATE TABLE #Work (MSDRG varchar(3), HServiceType varchar(42), Enc_id int)                      
CREATE TABLE #lt (ltime datetime)                      
CREATE TABLE #BTableNames (BigTableName varchar(100))                   
CREATE TABLE #SPs (SampleUnit_ID int, SamplePop_ID int, Enc_ID int, DaysFromFirst int,                       
    ReportDate DateTime, BigTableName varchar(100), SentMail_id int, EncDate Datetime)                      
CREATE TABLE #CatalsytWork (Study_ID int, Pop_ID int, Enc_ID int)     
                  
                  
exec @FieldExists = QLoader.QP_Load.dbo.columnAlreadyExists @owner,'Encounter_load','MSDRG'                    
exec @FieldExists2 = dbo.columnAlreadyExists @owner,'Encounter','MSDRG'                    
                  
                  
if @FieldExists <> 1                   
begin                  
 --print 'fieldexists ' + cast(@FieldExists as varchar(20))                  
 INSERT INTO #Log (RecordType, RecordsValue)                      
       Select 'MSDRG field not found in QP_Load.Encounter_Load table',' '                           
end                  
                  
if @FieldExists2 <> 1                   
begin                  
 --print 'fieldexists2 ' + cast(@FieldExists2 as varchar(20))                  
 INSERT INTO #Log (RecordType, RecordsValue)                      
       Select 'MSDRG field not found in QP_Prod.Encounter table',' '                            
end                  
                  
if @FieldExists <> 1 or @FieldExists2 <> 1                   
 goto ExitMSDRGUpdate                  
                      
--*************************************** Get the work data ********************************                      
PRINT 'Get work data ...'                         
  
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
                      
--SET @Sql = 'INSERT #Work (MSDRG, HServiceType, Enc_ID) ' +                       
--   ' SELECT L.MSDRG, L.HServiceType, E.Enc_id ' +                      
--   ' FROM ' + @server + '.QP_Load.'+@Owner+'.encounter_load L INNER JOIN '+@Owner+ '.Encounter E ON ' + @MCond +                      
--   ' WHERE (((E.MSDRG IS Null OR E.MSDRG = ''0'' OR E.MSDRG=''000'') AND (L.MSDRG IS NOT NULL AND L.MSDRG != ''0'' AND L.MSDRG != ''000'')) OR ' +                      
--   ' ((E.HServiceType IS NULL OR E.HServiceType = ''9'') AND (L.HServiceType IS NOT NULL AND L.HServiceType != ''9''))) AND ' +                      
--   ' L.DataFile_ID = ' +LTRIM(STR(@DataFile_ID))                           
--EXEC (@Sql)              
          
SET @Sql = 'INSERT #Work (MSDRG, HServiceType, Enc_ID) ' +                         
   ' SELECT L.MSDRG, L.HServiceType, E.Enc_id ' +                        
   ' FROM ' + @server + '.QP_Load.'+@Owner+'.encounter_load L INNER JOIN '+@Owner+ '.Encounter E ON ' + @MCond +                        
   ' WHERE  ((L.MSDRG IS NOT NULL AND L.MSDRG != ''0'' AND L.MSDRG != ''000'') and (L.HServiceType IS NOT NULL AND L.HServiceType != ''9'')) and L.DataFile_ID = ' +LTRIM(STR(@DataFile_ID))                             
EXEC (@Sql)      
  
SET @Sql = 'INSERT #CatalsytWork (Study_ID, Pop_ID, Enc_ID ) ' +                     
   ' SELECT ' + cast(@Study_ID as varchar(10)) + ', E.Pop_ID, E.Enc_id ' +                    
   ' FROM ' + @server + '.QP_Load.'+@Owner+'.encounter_load L INNER JOIN '+@Owner+ '.Encounter E ON ' + @MCond +                    
   ' WHERE  ((L.MSDRG IS NOT NULL AND L.MSDRG != ''0'' AND L.MSDRG != ''000'') and (L.HServiceType IS NOT NULL AND L.HServiceType != ''9'')) and L.DataFile_ID = ' +LTRIM(STR(@DataFile_ID))                             
EXEC (@Sql)         
                             
-- ****************************** Check to see if #Work has records and log if 0 ************************                      
    
set @myRowCount = @@ROWCOUNT    
    
SELECT TOP 1 MSDRG FROM #WORK                      
IF @@ROWCOUNT = 0                      
BEGIN                      
-- Update #Log                      
 INSERT INTO #Log (RecordType, RecordsValue)                      
       Select 'MSDRG: Matching Records With Updates:',  LTRIM(STR(@myRowCount))                           
END       
    
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'MSDRG: Matching Records With Updates:' + LTRIM(STR(@myRowCount))     
                    
-- **********************************************************************************************                      
--SELECT * FROM #Work --for checking                      
                      
--************************************** Get Data File loading time server name *****************                      
                      
                  
SET @sql = 'SELECT datReceived from ' + @server + '.QP_Load.dbo.datafile WHERE DataFile_id = ' + CONVERT(VARCHAR,@DataFile_ID)                      
INSERT INTO #LT (ltime) EXEC (@sql)                      
SELECT @ltime = ltime FROM #lt                       
DROP TABLE #lt                      
                      
SELECT @DataMart = strParam_Value FROM QualPro_Params WHERE strParam_nm = 'DataMart'                       
                      
--************************************** Update non-Sampled *************************************                      
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) select @study_ID, @DataFile_ID,  'Begin Updating Non-Sampled Encounter DRG'    
    
                      
--mwb 7-30-09 modified for performance reasons.          
--SET @Sql = 'UPDATE e SET MSDRG = w.MSDRG, HServiceType = w.HServiceType ' +                    
--   ' FROM '+@Owner+'.Encounter e INNER JOIN #Work w ON e.Enc_id = w.Enc_id ' +                    
--   ' WHERE w.Enc_id NOT IN (SELECT Enc_ID FROM SelectedSample WHERE Study_ID = '+LTRIM(STR(@Study_ID))+')'                    
--EXEC (@Sql)                    
  
SET @Sql = 'UPDATE e SET MSDRG = w.MSDRG, HServiceType = w.HServiceType ' +   
' FROM '+@Owner+'.Encounter e INNER JOIN #Work w ON e.Enc_id = w.Enc_id ' +     
'LEFT JOIN SelectedSample ss (NOLOCK) ON e.Enc_id = ss.Enc_id and ss.Study_ID = '+LTRIM(STR(@Study_ID)) +       
'where ss.enc_id is null'  

EXEC (@Sql)
    
set @myRowCount = @@ROWCOUNT    
                      
PRINT LTRIM(STR(@@ROWCOUNT))+' non-sampled Encounter records have been updated.'                      
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) select @study_ID, @DataFile_ID,  LTRIM(STR(@myRowCount))+' non-sampled Encounter records have been updated.'    
                      
                      
--************************************** Update sampled records *********************                      
--Create a temp table to hold all samplepops                      
                      
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
    
set @myRowCount = @@ROWCOUNT    
    
SELECT TOP 1 SampleUnit_ID FROM #Sps                      
IF @myRowCount = 0                      
BEGIN                      
-- Update #Log                      
 INSERT INTO #Log (RecordType, RecordsValue)                      
    Select 'MSDRG: Matching Records Sampled for an HCAHPS Unit:',  LTRIM(STR(@myRowCount))                              
        
    insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'MSDRG: Matching Records Sampled for an HCAHPS Unit: ' +  LTRIM(STR(@myRowCount))                              
    
END                       
                      
Select min(EncDate) AS FirstEncDate, max(Encdate) AS LastEncDate into #EncounterDates from #Sps                      
                      
INSERT INTO #Log (RecordType, RecordsValue)                      
Select 'MSDRG: Encounter Date Range:',  isnull(Convert(VarChar,FirstEncDate,101) + ' to ' +Convert(VarChar,LastEncDate,101), '0')  FROM #EncounterDates                           
    
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'MSDRG: Encounter Date Range: ' +  isnull(Convert(VarChar,FirstEncDate,101) + ' to ' +Convert(VarChar,LastEncDate,101), '0')  FROM #EncounterDates               
  
            
                      
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
    
--Log MSDRG data changes                      
SET @Sql = 'INSERT HCAHPSUpdateLog (samplepop_id, field_name, old_value, new_value, Change_Date) ' +                       
   ' SELECT DISTINCT sps.SamplePop_id, ''MSDRG'', e.MSDRG, w.MSDRG, GETDATE() ' +                      
   ' FROM #SPs sps INNER JOIN #Work w ON sps.Enc_ID = w.Enc_ID ' +                      
   '  INNER JOIN '+@Owner+'.Encounter e ON w.Enc_ID = e.Enc_ID'                      
--print @SQL                  
EXEC (@Sql)                                  
               
set @myRowCount = @@ROWCOUNT    
               
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'INSERT HCAHPSUpdateLog MSDRG Records Updated: ' + + LTRIM(STR(@myRowCount))     
               
                      
--Log HServiceType data changes                      
SET @Sql = 'INSERT HCAHPSUpdateLog (samplepop_id, field_name, old_value, new_value, Change_Date) ' +                       
   ' SELECT DISTINCT sps.SamplePop_id, ''HServiceType'', e.HServiceType, w.HServiceType, GETDATE() ' +                      
   ' FROM #SPs sps INNER JOIN #Work w ON sps.Enc_ID = w.Enc_ID ' +                      
   '  INNER JOIN '+@Owner+'.Encounter e ON w.Enc_ID = e.Enc_ID'                      
EXEC (@Sql)                      
    
set @myRowCount = @@ROWCOUNT    
                      
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'INSERT HCAHPSUpdateLog HServiceType Records Updated: ' + + LTRIM(STR(@myRowCount))                       
                      
                      
--Log Disposition if there is any                      
          
          
SELECT DISTINCT sps.SentMail_ID, sps.SamplePop_ID, 8, 0, @LTime, 'DBA'                       
 FROM #SPs sps INNER JOIN #Work w ON sps.enc_id = w.enc_id                       
 WHERE w.HServiceType = 'X'               
                      
INSERT DispositionLog (SentMail_id, SamplePop_id, Disposition_id, ReceiptType_id,                       
 datLogged, LoggedBy)              
SELECT DISTINCT sps.SentMail_ID, sps.SamplePop_ID, 8, 0, @LTime, 'DBA'                       
 FROM #SPs sps INNER JOIN #Work w ON sps.enc_id = w.enc_id                       
 WHERE w.HServiceType = 'X'                      
    
set @myRowCount = @@ROWCOUNT    
                      
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'INSERT DispositionLog Records Updated: ' + + LTRIM(STR(@myRowCount))                       
          
                      
-- Need to run an update against the newly inserted records,               
--because the function requires that the record already exist in the DispositionLog,               
--rather can calc @ time of insertion.                      
          
UPDATE DL SET                       
  DaysFromFirst   =  dbo.fn_DispDaysFromFirst(dl.SentMail_ID,@LTime,8),                         
  DaysFromCurrent =  dbo.fn_DispDaysFromCurrent(dl.SentMail_ID,@LTime,8)                      
FROM DispositionLog DL                       
INNER JOIN #SPs sps ON dl.sentmail_id = sps.sentmail_id and dl.samplepop_id = sps.samplepop_id and dl.disposition_id = 8 and dl.receipttype_Id = 0 AND dl.datLogged = @LTime                      
INNER JOIN #Work w ON sps.enc_id = w.enc_id                       
WHERE w.HServiceType = 'X'                      
                 
    
set @myRowCount = @@ROWCOUNT    
            
-- Update #Log                      
INSERT INTO #Log (RecordType, RecordsValue)                      
    Select 'MSDRG: Disposition Records Inserted:',LTRIM(STR(@myRowCount))         
    
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'MSDRG: Disposition Records Inserted: ' + + LTRIM(STR(@myRowCount))                       
        
                     
 --SELECT LTRIM(STR(@@ROWCOUNT))+' disposition records inserted.'                      
                      
--PRINT LTRIM(STR(@@ROWCOUNT))+' disposition records inserted.'                      
                      
--Update Encounter table                       
                  
          
            
SET @Sql = 'UPDATE e SET MSDRG = w.MSDRG, HServiceType = w.HServiceType ' +                      
   ' FROM #SPs sps INNER JOIN #Work w ON sps.Enc_ID = w.Enc_ID ' +                      
   '  INNER JOIN '+@Owner+'.Encounter e ON w.Enc_ID = e.Enc_ID'                      
EXEC (@Sql)                      
                      
-- Update #Log                      
set @myRowCount = @@ROWCOUNT    
                              
INSERT INTO #Log (RecordType, RecordsValue)                      
   Select 'MSDRG: Encounter Records Updated: ',LTRIM(STR(@myRowCount))       
       
   insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'MSDRG: Encounter Records Updated: ' + + LTRIM(STR(@myRowCount))                       
                   
 --SELECT LTRIM(STR(@@ROWCOUNT))+' disposition records inserted.'                      
                      
--PRINT LTRIM(STR(@@ROWCOUNT))+' sampled Encounter records have been updated.'                      
                      
                      
                      
--Update Datamart big tables                         
print 'Updating DataMart...'           
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'Updating Data Mart Now'    
       
INSERT #BTableNames (BigTableName)                      
 SELECT DISTINCT BigTableName FROM #SPs                      
                      
SELECT TOP 1 @BTableName = BigTableName FROM #BTableNames                       
WHILE @@ROWCOUNT > 0                      
BEGIN                      
                  
exec @FieldExists3 = DataMart.QP_Comments.dbo.columnAlreadyExists  @Owner ,@BTableName ,'MSDRG'                        
if @FieldExists3 <> 1                   
 begin    
  INSERT INTO #Log (RecordType, RecordsValue)                      
  Select 'MSDRG field not found in QP_Comments.' + @Owner + '.' + @BTableName,' '                            
    end    
    
    
             
set @FieldExists3 = 0                  
                  
 --Update datamart big table                       
 SET @Sql = 'UPDATE b SET MSDRG = w.MSDRG, HServiceType = w.HServiceType ' +                      
    ' FROM #SPs sps INNER JOIN #Work w ON sps.Enc_ID = w.Enc_ID ' +                      
    '  INNER JOIN '+@DataMart+'.QP_Comments.'+@Owner+'.'+@BTableName+' b ON b.SamplePop_id = sps.SamplePop_id '                       
 EXEC (@Sql)                      
                 
set @myRowCount = @@ROWCOUNT    
                      
-- Update #Log                  
 INSERT INTO #Log (RecordType, RecordsValue)                      
       Select 'MSDRG: Records in '+@BTableName + ': ',  LTRIM(STR(@myRowCount))                    
    
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'MSDRG: Records in '+@BTableName + ': ' + + LTRIM(STR(@myRowCount))                       
                      
--SELECT LTRIM(STR(@@ROWCOUNT))+' records in '+@BTableName + ' have been updated.'                      
                      
 --PRINT LTRIM(STR(@@ROWCOUNT))+' records in '+@BTableName + ' have been updated.'                      
                      
 --Remove the finished big table                      
 DELETE FROM #BTableNames WHERE BigTableName = @BTableName                      
 SELECT TOP 1 @BTableName = BigTableName FROM #BTableNames                       
END                       
  
--insert into Catalyst extract queue so MSDRG will be updated    
insert NRC_DataMart_ETL.dbo.ExtractQueue (EntityTypeID, PKey1, PKey2, IsMetaData, Source)      
select distinct 7, sp.SAMPLEPOP_ID, NULL, 0, 'LD_UpdateMSDRG_Updater'      
from  #CatalsytWork cw, samplepop sp, selectedsample ss    
where sp.study_Id = ss.study_ID and    
 sp.pop_ID = ss.pop_ID and    
 cw.study_ID = sp.study_ID and    
 cw.pop_Id = sp.pop_ID and    
 cw.enc_Id = ss.enc_ID    
  
                  
ExitMSDRGUpdate:                  
    
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'MSDRG update Completed'    
                      
-- 10/30/07 MWB now done in Calling procedure (LD_UpdateMSDRG)              
-- Return the #Log Dataset                      
--SELECT * FROM #Log                      
                      
-- If any error stop here for manual checking                      
IF @@ERROR<>0                       
BEGIN                      
 PRINT 'There is an error updating datamart, please check....'                      
 RETURN                      
END                      
                      
                      
--************************************** Drop Work Tables ****************************                      
                      
IF OBJECT_ID('tempdb..#SPs') IS NOT NULL DROP TABLE #SPs                      
IF OBJECT_ID('tempdb..#BTableNames') IS NOT NULL DROP TABLE #BTableNames                      
IF OBJECT_ID('tempdb..#Work') IS NOT NULL DROP TABLE #Work                      
-- 10/30/07 MWB now done in Calling procedure (LD_UpdateDRG)              
--DROP TABLE #Log                      
IF OBJECT_ID('tempdb..#EncounterDates') IS NOT NULL DROP TABLE #EncounterDates       
      
    
    
GO

