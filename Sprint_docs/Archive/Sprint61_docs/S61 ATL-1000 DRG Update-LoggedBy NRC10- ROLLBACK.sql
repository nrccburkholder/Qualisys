/*

	ROLLBACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	S61 ATL-1000 Evaluate Dispos from DRG Updates on Medusa after 42 days

	As Corporate Compliance, we want HCAHPS dispositions from DRG Updates to be evaluated in Medusa even if they come in after 42 days, so that we are compliant with HCAHPS protocols.

	Tim Butler

	ATL-1039 Change logged by from DBA to DRG Update
		ALTER PROCEDURE [dbo].[LD_UpdateDRG_Updater]

*/

use QP_PROD

GO

ALTER PROCEDURE [dbo].[LD_UpdateDRG_Updater] @Study_ID int, @DataFile_id int, @DRGOption varchar(20) = 'DRG'
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
-- Modified by TSB 06/24/2016: S52 ATL-192 HCAHPS Update file dispostions - modified to insert into DispositionLog for specific value updates on specified fields.
-- Modified by TSB 08/04/2016: S55 ATL-685 DRG Update disallowed for submitted data - modified to  prevent load-to-lives from updating DRGs for records that have already been submitted to CMS                        
-- Modified by TSB 08/09/2016: S55 ATL-683 DRG Update Rollback Process - modified to write DataFile_id to HCAHPSUpdateLog table.
-- Modified by TSB 09/23/2016:  commented out section that updates non-sampled records as per Dana Petersen  
-- Modified by TSB 10/17/2016:  S60 ATL-974 DRG Update/Rollback modification -- change date comparison on SubmissionDateClose
-- Modified by TSB 10/17/2016:  S60 ATL-974 DRG Update/Rollback modification -- added code to prevent update on records with discharge/service dates older than 1/1/2016
                      
DECLARE @MCond varchar(200), @LTime datetime, @DataMart varchar(50)                      
DECLARE @Owner varchar(10), @Sql varchar(8000), @Now datetime, @BTableName varchar(100), @Server VARCHAR(20)                      
declare @FieldExists smallint, @FieldExists2 smallint, @FieldExists3 smallint                  
                  
declare @VarOwner varchar(50)                    
declare @varBTableName varchar(100)                    
declare @myRowCount int   
declare @dropDeadDate date = '2016-01-01'  -- records older than this date cannot be updated 
                  
SET @Owner = 'S'+RTRIM(LTRIM(STR(@Study_ID)))                      
SET @Server = (SELECT strparam_value from qualpro_params where strparam_nm = 'QLoader')                      
                  
-- create all tables needed up front              
-- 10/30/07 MWB now done in Calling procedure (LD_UpdateDRG)                    
--CREATE TABLE #log (RecordType varchar(100), RecordsValue VArchar(50))                      
CREATE TABLE #Work (DRG varchar(3), HServiceType varchar(42), HVisitType varchar(42), HAdmissionSource varchar(42), HDischargeStatus varchar(42), HAdmitAge int, HCatAge varchar(42), Enc_id int, isPastSubmission bit,  DischargeDate datetime, ServiceDate datetime)                      
CREATE TABLE #lt (ltime datetime)                      
CREATE TABLE #BTableNames (BigTableName varchar(100))                   
CREATE TABLE #SPs (SampleUnit_ID int, SamplePop_ID int, Enc_ID int, DaysFromFirst int,                       
    ReportDate DateTime, BigTableName varchar(100), SentMail_id int, EncDate Datetime)                      
CREATE TABLE #CatalystWork (Study_ID int, Pop_ID int, Enc_ID int,isPastSubmission bit, DischargeDate datetime, ServiceDate datetime)                  
                  
exec @FieldExists = QLoader.QP_Load.dbo.columnAlreadyExists @owner,'Encounter_load',@DRGOption
exec @FieldExists2 = dbo.columnAlreadyExists @owner,'Encounter',@DRGOption                    
                  
                  
if @FieldExists <> 1                   
begin                  
 --print 'fieldexists ' + cast(@FieldExists as varchar(20))                  
 INSERT INTO #Log (RecordType, RecordsValue)                      
       Select @DRGOption + ' field not found in QP_Load.Encounter_Load table',' '                           
end                  
                  
if @FieldExists2 <> 1                   
begin                  
 --print 'fieldexists2 ' + cast(@FieldExists2 as varchar(20))                  
 INSERT INTO #Log (RecordType, RecordsValue)                      
       Select @DRGOption + ' field not found in QP_Prod.Encounter table',' '                            
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
                      

DECLARE @hasDischargeDate bit = 0
DECLARE @hasServiceDate bit = 0


-- check to see if the dischargedate column exists in the encounter table for this study
IF EXISTS (select 1
	from QP_PROD.information_schema.columns c
	where table_schema = @Owner and table_name = 'encounter' and
			column_name = 'DischargeDate')
BEGIN
	SET @hasDischargeDate = 1
END    

-- check to see if the servicedate column exists in the encounter table for this study
IF EXISTS (select 1
	from QP_PROD.information_schema.columns c
	where table_schema = @Owner and table_name = 'encounter' and
			column_name = 'ServiceDate')
BEGIN
	SET @hasServiceDate = 1
END         
          
SET @Sql = 'INSERT #Work (DRG, HServiceType, HVisitType, HAdmissionSource, HDischargeStatus, HAdmitAge, HCatAge, Enc_ID, isPastSubmission, DischargeDate, ServiceDate) ' +                         
   ' SELECT L.' + @DRGOption + ', L.HServiceType, L.HVisitType, L.HAdmissionSource, L.HDischargeStatus, L.HAdmitAge, L.HCatAge, E.Enc_id, 0 ' 
     
	if @hasDischargeDate = 1 SET @Sql = @Sql + ', E.DischargeDate' ELSE SET @Sql = @Sql + ', NULL '
	if @hasServiceDate = 1 SET @Sql = @Sql + ', E.ServiceDate' ELSE SET @Sql = @Sql + ', NULL '
                          
    SET @Sql = @Sql +' FROM ' + @server + '.QP_Load.'+@Owner+'.encounter_load L ' +
   ' INNER JOIN '+@Owner+ '.Encounter E ON ' + @MCond +                        
   ' WHERE  ((L.' + @DRGOption + ' IS NOT NULL AND L.' + @DRGOption + ' != ''0'' AND L.' + @DRGOption + ' != ''000'') and (L.HServiceType IS NOT NULL AND L.HServiceType != ''9'')) and L.DataFile_ID = ' +LTRIM(STR(@DataFile_ID))                             
EXEC (@Sql)         
  
SET @Sql = 'INSERT #CatalystWork (Study_ID, Pop_ID, Enc_ID, isPastSubmission, DischargeDate, ServiceDate) ' +                     
   ' SELECT ' + cast(@Study_ID as varchar(10)) + ', E.Pop_ID, E.Enc_id, 0 ' 
   
    if @hasDischargeDate = 1 SET @Sql = @Sql + ', E.DischargeDate' ELSE SET @Sql = @Sql + ', NULL '
	if @hasServiceDate = 1 SET @Sql = @Sql + ', E.ServiceDate' ELSE SET @Sql = @Sql + ', NULL '
   
                      
   SET @Sql = @Sql +' FROM ' + @server + '.QP_Load.'+@Owner+'.encounter_load L ' +
   ' INNER JOIN '+@Owner+ '.Encounter E ON ' + @MCond +                    
   ' WHERE  ((L.' + @DRGOption + ' IS NOT NULL AND L.' + @DRGOption + ' != ''0'' AND L.' + @DRGOption + ' != ''000'') and (L.HServiceType IS NOT NULL AND L.HServiceType != ''9'')) and L.DataFile_ID = ' +LTRIM(STR(@DataFile_ID))  
EXEC (@Sql)         
                          
-- ****************************** Check to see if #Work has records and log if 0 ************************                      
    
set @myRowCount = @@ROWCOUNT    
    
SELECT TOP 1 DRG FROM #WORK                      
IF @@ROWCOUNT = 0                      
BEGIN                      
-- Update #Log                      
 INSERT INTO #Log (RecordType, RecordsValue)                      
       Select @DRGOption +': Matching Records With Updates:',  LTRIM(STR(@myRowCount))                           
END       
    
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  @DRGOption+': Matching Records With Updates:' + LTRIM(STR(@myRowCount))     

-- ****************************** Check to see if #Work has records that are past the submission date ************************    

	SET @Sql = 'UPDATE w ' +
	' SET IsPastSubmission = 1 ' + 
	'FROM #Work w ' + 
	'INNER JOIN dbo.CMSDataSubmissionSchedule sub on sub.[month] = DATEPART(month,ISNULL(w.DischargeDate,w.ServiceDate)) and sub.[year] = DATEPART(year,ISNULL(w.DischargeDate,w.ServiceDate)) ' +
	'WHERE sub.SurveyType_id = 2 ' +
	'AND sub.SubmissionDateClose < CONVERT(date,GetDate())'

EXEC (@Sql)
    
set @myRowCount = @@ROWCOUNT    
                      
PRINT LTRIM(STR(@myRowCount)) +' check for records that are past the submission date.'                      
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  @DRGOption+': Records not applied because they are past the submission date:' + LTRIM(STR(@myRowCount)) 

if @myRowCount > 0
begin
	
	IF EXISTS (SELECT 1 FROM #Work WHERE isPastSubmission = 1 and DischargeDate is not null and ServiceDate is null)
	BEGIN

		SELECT @myRowCount = count(*) FROM #Work WHERE isPastSubmission = 1 and DischargeDate is not null and ServiceDate is null

		INSERT INTO #Log (RecordType, RecordsValue) Select @DRGOption +': Records not applied because DischargeDate is past the submission:',  LTRIM(STR(@myRowCount))
	END

	IF EXISTS (SELECT 1 FROM #Work WHERE isPastSubmission = 1 and ServiceDate is not null and DischargeDate is null)
	BEGIN

		SELECT @myRowCount = count(*) FROM #Work WHERE isPastSubmission = 1 and ServiceDate is not null and DischargeDate is null

		INSERT INTO #Log (RecordType, RecordsValue) Select @DRGOption +': Records not applied because ServiceDate is past the submission:',  LTRIM(STR(@myRowCount))
	END

	IF EXISTS (SELECT 1 FROM #Work WHERE isPastSubmission = 1 and DischargeDate is not null and ServiceDate is not null)
	BEGIN

		SELECT @myRowCount = count(*) FROM #Work WHERE isPastSubmission = 1 and DischargeDate is not null and ServiceDate is not null

		INSERT INTO #Log (RecordType, RecordsValue) Select @DRGOption +': Records not applied because DischargeDate is past the submission.<br>(Study also contains a ServiceDate field, which was ignored):',  LTRIM(STR(@myRowCount))
	END  

end


-- ****************************** Check to see if #Work has records older than 1/1/2106 - we don't want to allow these to be updated. ************************    

	SET @Sql = 'UPDATE w ' +
	' SET IsPastSubmission = 1 ' + 
	'FROM #Work w ' + 
	'WHERE IsPastSubmission = 0 ' +
	'AND Convert(Date,ISNULL(w.DischargeDate,w.ServiceDate)) < ''' + Convert(varchar,@dropDeadDate) + ''''

EXEC (@Sql)
    
set @myRowCount = @@ROWCOUNT    
                      
PRINT LTRIM(STR(@myRowCount)) +' check for records that too old to update.'                      
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  @DRGOption+': Records not applied because they are older than ' + Convert(varchar,@dropDeadDate) +':' + LTRIM(STR(@myRowCount)) 

if @myRowCount > 0
begin
	
	IF EXISTS (SELECT 1 FROM #Work WHERE isPastSubmission = 1 and DischargeDate is not null and ServiceDate is null)
	BEGIN

		SELECT @myRowCount = count(*) FROM #Work WHERE isPastSubmission = 1 and DischargeDate is not null and ServiceDate is null

		INSERT INTO #Log (RecordType, RecordsValue) Select @DRGOption +': Records not applied because DischargeDate is older than ' + Convert(varchar,@dropDeadDate) +':',  LTRIM(STR(@myRowCount))
	END

	IF EXISTS (SELECT 1 FROM #Work WHERE isPastSubmission = 1 and ServiceDate is not null and DischargeDate is null)
	BEGIN

		SELECT @myRowCount = count(*) FROM #Work WHERE isPastSubmission = 1 and ServiceDate is not null and DischargeDate is null

		INSERT INTO #Log (RecordType, RecordsValue) Select @DRGOption +': Records not applied because ServiceDate is older than ' + Convert(varchar,@dropDeadDate) +':',  LTRIM(STR(@myRowCount))
	END

	IF EXISTS (SELECT 1 FROM #Work WHERE isPastSubmission = 1 and DischargeDate is not null and ServiceDate is not null)
	BEGIN

		SELECT @myRowCount = count(*) FROM #Work WHERE isPastSubmission = 1 and DischargeDate is not null and ServiceDate is not null

		INSERT INTO #Log (RecordType, RecordsValue) Select @DRGOption +': Records not applied because DischargeDate is older than ' + Convert(varchar,@dropDeadDate) +'.<br>(Study also contains a ServiceDate field, which was ignored):',  LTRIM(STR(@myRowCount))
	END  

end
	
-- Now delete those records past the submission date from the #Work table because we don't want to update them	
    
	DELETE FROM #Work
	WHERE isPastSubmission = 1

--************************ For records past the submission date, update the #CatalystWork table 

	SET @Sql = 'UPDATE w ' +
	' SET IsPastSubmission = 1 ' + 
	'FROM #CatalystWork w ' + 
	'INNER JOIN dbo.CMSDataSubmissionSchedule sub on sub.[month] = DATEPART(month,ISNULL(w.DischargeDate,w.ServiceDate)) and sub.[year] = DATEPART(year,ISNULL(w.DischargeDate,w.ServiceDate)) ' +
	'WHERE sub.SurveyType_id = 2 ' +
	'AND sub.SubmissionDateClose < CONVERT(date,GetDate())'

EXEC (@Sql)


	SET @Sql = 'UPDATE w ' +
	' SET IsPastSubmission = 1 ' + 
	'FROM #CatalystWork w ' + 
	'WHERE IsPastSubmission = 0 ' +
	'AND Convert(Date,ISNULL(w.DischargeDate,w.ServiceDate)) < ''' + Convert(varchar,@dropDeadDate) + ''''

EXEC (@Sql)

-- Now delete those records past the submission date from the #CatalystWork table 	
    
	DELETE FROM #CatalystWork
	WHERE isPastSubmission = 1

-- ****************************** Check to see if #Work has records that don't have a record in CMSDataSubmissionSchedule ************************    

	SET @Sql = 'SELECT * ' +
	'FROM #Work w ' + 
	'Left JOIN dbo.CMSDataSubmissionSchedule sub on sub.[month] = DATEPART(month,ISNULL(w.DischargeDate,w.ServiceDate)) and sub.[year] = DATEPART(year,ISNULL(w.DischargeDate,w.ServiceDate)) and sub.SurveyType_id = 2 ' +
	'WHERE sub.CMSDataSubmissionSchedule_id is null '

EXEC (@Sql)
    
set @myRowCount = @@ROWCOUNT   
                    
PRINT LTRIM(STR(@myRowCount)) +' check for records with no match in Submission Schedule table.'                      
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  @DRGOption+': Records with no match in Submission Schedule table:' + LTRIM(STR(@myRowCount)) 

INSERT INTO #Log (RecordType, RecordsValue) Select @DRGOption+': Records with no match in Submission Schedule table:', LTRIM(STR(@myRowCount)) 
           
-- **********************************************************************************************                      
--SELECT * FROM #Work --for checking                      
                      
--************************************** Get Data File loading time server name *****************                      
                      
                  
SET @sql = 'SELECT datReceived from ' + @server + '.QP_Load.dbo.datafile WHERE DataFile_id = ' + CONVERT(VARCHAR,@DataFile_ID)                      
INSERT INTO #LT (ltime) EXEC (@sql)                      
SELECT @ltime = ltime FROM #lt                       
DROP TABLE #lt                      
                      
SELECT @DataMart = strParam_Value FROM QualPro_Params WHERE strParam_nm = 'DataMart'                       
 
 /*  ommenting out the section for updating non-sampled records as per Dana Petersen 2016.09.23  TSB                     
--************************************** Update non-Sampled *************************************                                      
  
SET @Sql = 'UPDATE e SET ' + @DRGOption + ' = w.DRG, HServiceType = w.HServiceType, HVisitType = w.HVisitType, HAdmissionSource = w.HAdmissionSource, HDischargeStatus = w.HDischargeStatus, HAdmitAge = w.HAdmitAge, HCatAge = w.HCatAge ' +   
' FROM '+@Owner+'.Encounter e ' +
' INNER JOIN #Work w ON e.Enc_id = w.Enc_id ' +     
' LEFT JOIN SelectedSample ss (NOLOCK) ON e.Enc_id = ss.Enc_id and ss.Study_ID = '+LTRIM(STR(@Study_ID)) +       
' where ss.enc_id is null'  

EXEC (@Sql)
    
set @myRowCount = @@ROWCOUNT    
                      
PRINT LTRIM(STR(@@ROWCOUNT))+' non-sampled Encounter records have been updated.'                      
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) select @study_ID, @DataFile_ID,  LTRIM(STR(@myRowCount))+' non-sampled Encounter records have been updated.'    
       
*/               
                      
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
    Select @DRGOption + ': Matching Records Sampled for an HCAHPS Unit:',  LTRIM(STR(@myRowCount))                              
        
    insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  @DRGOption + ': Matching Records Sampled for an HCAHPS Unit: ' +  LTRIM(STR(@myRowCount))                              
    
END                       
                      
Select min(EncDate) AS FirstEncDate, max(Encdate) AS LastEncDate into #EncounterDates from #Sps                      
                      
INSERT INTO #Log (RecordType, RecordsValue)                      
Select @DRGOption + ': Encounter Date Range:',  isnull(Convert(VarChar,FirstEncDate,101) + ' to ' +Convert(VarChar,LastEncDate,101), '0')  FROM #EncounterDates                           
    
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  @DRGOption + ': Encounter Date Range: ' +  isnull(Convert(VarChar,FirstEncDate,101) + ' to ' +Convert(VarChar,LastEncDate,101), '0')  FROM #EncounterDates                
  
           
                      
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

--S52 ATL-192 writing changes to temp table
CREATE TABLE #HCAHPSUpdateLog (samplepop_ID int, field_name varchar(42), old_value varchar(42), new_value varchar(42))                 
       
	   
PRINT 'Log DRG data changes' 
               
--Log DRG data changes                      
SET @Sql = 'INSERT #HCAHPSUpdateLog (samplepop_id, field_name, old_value, new_value) ' +                       
   ' SELECT DISTINCT sps.SamplePop_id, ''' + @DRGOption + ''', e.' + @DRGOption + ', w.DRG ' +                      
   ' FROM #SPs sps ' +
   ' INNER JOIN #Work w ON sps.Enc_ID = w.Enc_ID ' +                      
   ' INNER JOIN '+@Owner+'.Encounter e ON w.Enc_ID = e.Enc_ID '
--print @SQL                  
EXEC (@Sql)                                  
               
set @myRowCount = @@ROWCOUNT    
               
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'INSERT #HCAHPSUpdateLog ' + @DRGOption + ' Records Updated: ' + + LTRIM(STR(@myRowCount))     
     
PRINT 'Log HServiceType data changes'                          
--Log HServiceType data changes                      
SET @Sql = 'INSERT #HCAHPSUpdateLog (samplepop_id, field_name, old_value, new_value) ' +                       
   ' SELECT DISTINCT sps.SamplePop_id, ''HServiceType'', e.HServiceType, w.HServiceType ' +                      
   ' FROM #SPs sps INNER JOIN #Work w ON sps.Enc_ID = w.Enc_ID ' +                      
   '  INNER JOIN '+@Owner+'.Encounter e ON w.Enc_ID = e.Enc_ID'
EXEC (@Sql)                      
    
set @myRowCount = @@ROWCOUNT    
                      
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'INSERT #HCAHPSUpdateLog HServiceType Records Updated: ' + + LTRIM(STR(@myRowCount))                       
                      
PRINT 'Log HVisitType data changes'                 
--Log HVisitType data changes                      
SET @Sql = 'INSERT #HCAHPSUpdateLog (samplepop_id, field_name, old_value, new_value) ' +                       
   ' SELECT DISTINCT sps.SamplePop_id, ''HVisitType'', e.HVisitType, w.HVisitType ' +                      
   ' FROM #SPs sps INNER JOIN #Work w ON sps.Enc_ID = w.Enc_ID ' +                      
   '  INNER JOIN '+@Owner+'.Encounter e ON w.Enc_ID = e.Enc_ID'
EXEC (@Sql)                      
    
set @myRowCount = @@ROWCOUNT    
                      
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'INSERT #HCAHPSUpdateLog HVisitType Records Updated: ' + + LTRIM(STR(@myRowCount))                       
                      
PRINT 'Log HAdmissionSource data changes'                    
--Log HAdmissionSource data changes                      
SET @Sql = 'INSERT #HCAHPSUpdateLog (samplepop_id, field_name, old_value, new_value) ' +                       
   ' SELECT DISTINCT sps.SamplePop_id, ''HAdmissionSource'', e.HAdmissionSource, w.HAdmissionSource ' +                      
   ' FROM #SPs sps INNER JOIN #Work w ON sps.Enc_ID = w.Enc_ID ' +                      
   '  INNER JOIN '+@Owner+'.Encounter e ON w.Enc_ID = e.Enc_ID'
EXEC (@Sql)                      
    
set @myRowCount = @@ROWCOUNT    
                      
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'INSERT #HCAHPSUpdateLog HAdmissionSource Records Updated: ' + + LTRIM(STR(@myRowCount))                       
                      
   
PRINT 'Log HDischargeStatus data changes'                   
--Log HDischargeStatus data changes                      
SET @Sql = 'INSERT #HCAHPSUpdateLog (samplepop_id, field_name, old_value, new_value) ' +                       
   ' SELECT DISTINCT sps.SamplePop_id, ''HDischargeStatus'', e.HDischargeStatus, w.HDischargeStatus ' +                      
   ' FROM #SPs sps INNER JOIN #Work w ON sps.Enc_ID = w.Enc_ID ' +                      
   '  INNER JOIN '+@Owner+'.Encounter e ON w.Enc_ID = e.Enc_ID'
EXEC (@Sql)                      
    
set @myRowCount = @@ROWCOUNT    
                      
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'INSERT #HCAHPSUpdateLog HDischargeStatus Records Updated: ' + + LTRIM(STR(@myRowCount))                       
                      
PRINT 'Log HAdmitAge data changes'                      
--Log HAdmitAge data changes                      
SET @Sql = 'INSERT #HCAHPSUpdateLog (samplepop_id, field_name, old_value, new_value) ' +                       
   ' SELECT DISTINCT sps.SamplePop_id, ''HAdmitAge'', e.HAdmitAge, w.HAdmitAge ' +                      
   ' FROM #SPs sps INNER JOIN #Work w ON sps.Enc_ID = w.Enc_ID ' +                      
   '  INNER JOIN '+@Owner+'.Encounter e ON w.Enc_ID = e.Enc_ID'
EXEC (@Sql)                      
    
set @myRowCount = @@ROWCOUNT    
                      
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'INSERT #HCAHPSUpdateLog HAdmitAge Records Updated: ' + + LTRIM(STR(@myRowCount))                       
                      
   
PRINT 'Log HCatAge data changes'                   
--Log HCatAge data changes                      
SET @Sql = 'INSERT #HCAHPSUpdateLog (samplepop_id, field_name, old_value, new_value) ' +                       
   ' SELECT DISTINCT sps.SamplePop_id, ''HCatAge'', e.HCatAge, w.HCatAge ' +                      
   ' FROM #SPs sps INNER JOIN #Work w ON sps.Enc_ID = w.Enc_ID ' +                      
   '  INNER JOIN '+@Owner+'.Encounter e ON w.Enc_ID = e.Enc_ID'
EXEC (@Sql)                      
    
set @myRowCount = @@ROWCOUNT    
                      
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'INSERT #HCAHPSUpdateLog HCatAge Records Updated: ' + + LTRIM(STR(@myRowCount))                       
                      
   
PRINT 'Insert the actual records into HCAHPSUpdateLog'
--S52 ATL-192 Insert the actual records into HCAHPSUpdateLog
INSERT INTO HCAHPSUpdateLog
	SELECT samplepop_id, field_name, old_value, new_value, getdate()
	, @DataFile_id		-- S55 ATL-683
	, 0					-- S55 ATL-683 (bitRollback)
	FROM #HCAHPSUpdateLog
   
set @myRowCount = @@ROWCOUNT    
                      
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'INSERT HCAHPSUpdateLog - Total Records: ' + + LTRIM(STR(@myRowCount)) 
                      
--Log Dispositions if there is any    

PRINT 'write the new dispositions to a temp table'
-- S52 ATL-192 First, write the new dispositions to a temp table           
SELECT DISTINCT sps.SentMail_ID, sps.SamplePop_ID, d.Disposition_id, 0 ReceiptType, @LTime datLogged, 'DBA' LoggedBy
INTO #DispositionLog
from #HCAHPSUpdateLog ul
inner join dbo.DRGUpdateDispositionMapping d on d.fieldname = ul.field_name and d.UpdateValue = ul.new_value
inner join #SPs sps on sps.SamplePop_ID = ul.samplepop_ID
WHERE ISNULL(ul.new_value,'NULL') <> ISNULL(ul.old_value,'NULL')


DECLARE @dispositionRowCount int = 0

print 'Now, do the actual insert into DispositionLog'
--S52 ATL-192  Now, do the actual insert into DispositionLog
INSERT DispositionLog (SentMail_id, SamplePop_id, Disposition_id, ReceiptType_id, datLogged, LoggedBy)
	SELECT SentMail_ID, SamplePop_ID, Disposition_id, ReceiptType, datLogged, LoggedBy
	FROM #DispositionLog
      
set @dispositionRowCount = @@ROWCOUNT    
                      
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'INSERT DispositionLog Records Updated(1): ' + + LTRIM(STR(@dispositionRowCount))   

--S52 ATL-192 
-- Need to run an update against the newly inserted records,               
--because the function requires that the record already exist in the DispositionLog,               
--rather can calc @ time of insertion.    
UPDATE DL SET                       
  DaysFromFirst   =  dbo.fn_DispDaysFromFirst(dl.SentMail_ID,dl.datLogged,dl.Disposition_id),                         
  DaysFromCurrent =  dbo.fn_DispDaysFromCurrent(dl.SentMail_ID,dl.datLogged,dl.Disposition_id)                    
FROM DispositionLog DL                       
INNER JOIN #DispositionLog tdl ON dl.sentmail_id = tdl.sentmail_id 
								  and dl.samplepop_id = tdl.samplepop_id 
								  and dl.disposition_id = tdl.Disposition_id 
								  and dl.receipttype_Id = tdl.ReceiptType 
								  and dl.datLogged = @LTime                        
        
DROP TABLE #HCAHPSUpdateLog   
DROP TABLE #DispositionLog         
          
SELECT DISTINCT sps.SentMail_ID, sps.SamplePop_ID, 8, 0, @LTime, 'DBA'                       
 FROM #SPs sps INNER JOIN #Work w ON sps.enc_id = w.enc_id                       
 WHERE w.HServiceType = 'X'               
                      
INSERT DispositionLog (SentMail_id, SamplePop_id, Disposition_id, ReceiptType_id, datLogged, LoggedBy)              
SELECT DISTINCT sps.SentMail_ID, sps.SamplePop_ID, 8, 0, @LTime, 'DBA'                       
 FROM #SPs sps 
 INNER JOIN #Work w ON sps.enc_id = w.enc_id                       
 WHERE w.HServiceType = 'X'                      
    
set @myRowCount = @@ROWCOUNT    
                      
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  'INSERT DispositionLog Records Updated(2): ' + + LTRIM(STR(@myRowCount))                       
          
                      
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
                 
    
set @myRowCount = @@ROWCOUNT + @dispositionRowCount 
            
-- Update #Log                      
INSERT INTO #Log (RecordType, RecordsValue)                      
    Select @DRGOption + ': Disposition Records Inserted:',LTRIM(STR(@myRowCount))         
    
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  @DRGOption + ': Disposition Records Inserted: ' + + LTRIM(STR(@myRowCount))                       
        
                     
 --SELECT LTRIM(STR(@@ROWCOUNT))+' disposition records inserted.'                      
                      
--PRINT LTRIM(STR(@@ROWCOUNT))+' disposition records inserted.'                      
    
PRINT 'Updating Encounter table'                
--Update Encounter table                                         
SET @Sql = 'UPDATE e SET ' + @DRGOption + ' = w.DRG, HServiceType = w.HServiceType, HVisitType = w.HVisitType, HAdmissionSource = w.HAdmissionSource, HDischargeStatus = w.HDischargeStatus, HAdmitAge = w.HAdmitAge, HCatAge = w.HCatAge ' +                      
   ' FROM #SPs sps INNER JOIN #Work w ON sps.Enc_ID = w.Enc_ID ' +                      
   '  INNER JOIN '+@Owner+'.Encounter e ON w.Enc_ID = e.Enc_ID'
EXEC (@Sql)                      
          
-- Update #Log                      
set @myRowCount = @@ROWCOUNT    
                              
INSERT INTO #Log (RecordType, RecordsValue)                      
   Select @DRGOption + ': Encounter Records Updated: ',LTRIM(STR(@myRowCount))       
       
   insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  @DRGOption + ': Encounter Records Updated: ' + + LTRIM(STR(@myRowCount))                       
                   
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
                  
exec @FieldExists3 = DataMart.QP_Comments.dbo.columnAlreadyExists  @Owner ,@BTableName ,@DRGOption                        
if @FieldExists3 <> 1                   
 begin    
  INSERT INTO #Log (RecordType, RecordsValue)                      
  Select @DRGOption + ' field not found in QP_Comments.' + @Owner + '.' + @BTableName,' '                            
    end    
    
    
             
set @FieldExists3 = 0                  
                  
 --Update datamart big table                       
 SET @Sql = 'UPDATE b SET ' + @DRGOption + ' = w.DRG, HServiceType = w.HServiceType, HVisitType = w.HVisitType, HAdmissionSource = w.HAdmissionSource, HDischargeStatus = w.HDischargeStatus, HAdmitAge = w.HAdmitAge, HCatAge = w.HCatAge ' +                      
    ' FROM #SPs sps ' +
	' INNER JOIN #Work w ON sps.Enc_ID = w.Enc_ID ' +                      
    '  INNER JOIN '+@DataMart+'.QP_Comments.'+@Owner+'.'+@BTableName+' b ON b.SamplePop_id = sps.SamplePop_id '
 EXEC (@Sql)                      
                 
set @myRowCount = @@ROWCOUNT    
                      
-- Update #Log                      
 INSERT INTO #Log (RecordType, RecordsValue)                      
       Select @DRGOption + ': Records in '+@BTableName + ': ',  LTRIM(STR(@myRowCount))                    
    
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  @DRGOption + ': Records in '+@BTableName + ': ' + + LTRIM(STR(@myRowCount))                       
                      
--SELECT LTRIM(STR(@@ROWCOUNT))+' records in '+@BTableName + ' have been updated.'                      
                      
 --PRINT LTRIM(STR(@@ROWCOUNT))+' records in '+@BTableName + ' have been updated.'                      
                      
 --Remove the finished big table                      
 DELETE FROM #BTableNames WHERE BigTableName = @BTableName                      
 SELECT TOP 1 @BTableName = BigTableName FROM #BTableNames                       
END                       
  
--insert into Catalyst extract queue so MSDRG will be updated    
insert NRC_DataMart_ETL.dbo.ExtractQueue (EntityTypeID, PKey1, PKey2, IsMetaData, Source)      
select distinct 7, sp.SAMPLEPOP_ID, NULL, 0, 'LD_UpdateDRG_Updater' + @DRGOption      
from  #CatalystWork cw, samplepop sp, selectedsample ss    
where sp.study_Id = ss.study_ID and    
 sp.pop_ID = ss.pop_ID and    
 cw.study_ID = sp.study_ID and    
 cw.pop_Id = sp.pop_ID and    
 cw.enc_Id = ss.enc_ID and
 cw.IsPastSubmission = 0 
  
                  
ExitDRGUpdate:                  
    
insert into DRGDebugLogging (Study_ID, DataFile_Id, Message) Select @study_ID, @DataFile_ID,  @DRGOption + ' update Completed'    
                      
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
