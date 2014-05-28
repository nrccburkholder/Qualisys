/*********************************************************************************************************  
QSL_SelectWebVendorSampleSetFileData  
Created by: Michael Beltz  
Purpose: This proc is used a copy of QSL_SelectPhoneVendorSampleSetFileData and is used  
   to create a web vendor file and is called from both a SSRS report and an  
   internal application service that creates and sends files to non-mail vendors.  
  
History Log:  
Created on: 7/15/09  
Modified:  
       8/9/2012 DBG -- added MailingStepMethod #9 to "mm.MailingStepMethod_id IN (2,4,9)" to accomodate  
          Letter-Web Mailing Step Method.  
          Added INSERT INTO QuestionForm command for Letter-Web mailing steps  
       9/19/2013 DBG -- Added call to CalcCAHPSSupplemental  
  
*********************************************************************************************************/  
CREATE PROCEDURE [dbo].[QSL_SelectWebVendorSampleSetFileData] (  
 @SampleSet_ID INT  
 ,@SaveData BIT = 0  
 ,@bitUpdate INT = 0  
 ,@VendorFileID INT = 0  
 ,@UseWorkTable BIT = 0  
 ,@inDebug INT = 0  
 )  
AS  
BEGIN  
 SET ANSI_WARNINGS ON  
  
 Declare @Study_ID VARCHAR(50), @Survey_ID VARCHAR(50),  @SQL Varchar(8000), @ordername VARCHAR(30), @MaxQF int  
 /*  
--Debug Code  
declare @inDebug bit, @SampleSet_ID int, @SaveData bit, @VendorFileID int, @bitUpdate bit  
set @inDebug = 1  
set @SaveData = 1  
set @SampleSet_ID = 424  
set @VendorFileID = 6  
set @bitUpdate = 0  
  
--To get just Result Data back  
--QSL_SelectWebVendorSampleSetFileData 424, 0,0, 0, 0, 1  
--To test all variables like calling from SP_FG_Nonmailgen  
drop table #FG_NonMailingWork  
Create table #FG_NonMailingWork (SamplePop_ID int, MailingStep_ID int)  
insert into #FG_NonMailingWork select 12001 , 1  
insert into #FG_NonMailingWork select 12002 ,1  
exec QSL_SelectWebVendorSampleSetFileData 467, 0, 0, 0, 0, 1  
  
select * from VendorWebFile_Data where vendorFile_ID = 6  
select * from vendorFile_freqs where vendorFile_ID = 6  
select * from vendorFile_nullcounts where vendorFile_ID = 6  
  
*/  
 DECLARE @RecordCount INT, @NoLithoCount INT  
  
 SET @RecordCount = 0  
 SET @NoLithoCount = 0  
  
 IF @indebug = 1  
  PRINT 'Start QSL_SelectWebVendorSampleSetFileData'  
  
 IF @SaveData <> 0  
  AND @VendorFileID = 0  
 BEGIN  
  RAISERROR ('Cannot save data if VendorFile_ID is 0.  Contact system administrator.',-- Message text.  
    16,-- Severity.  
    1 -- State.  
    )  
  RETURN  
 END  
  
 CREATE TABLE #Results (  
  Litho VARCHAR(42)  
  ,WAC VARCHAR(42)  
  ,Survey_ID INT  
  ,SampleSet_ID INT  
  ,FName VARCHAR(42)  
  ,LName VARCHAR(42)  
  ,LangID INT  
  ,Email_Address VARCHAR(100)  
  ,wbServDate DATETIME  
  ,wbServInd1 VARCHAR(100)  
  ,wbServInd2 VARCHAR(100)  
  ,wbServInd3 VARCHAR(100)  
  ,wbServInd4 VARCHAR(100)  
  ,wbServInd5 VARCHAR(100)  
  ,wbServInd6 VARCHAR(100)  
  )  
  
 SET @study_ID = 0  
 SET @Survey_ID = 0  
  
 SELECT @Study_ID = sd.Study_ID, @Survey_ID = ss.survey_ID  
 FROM SampleSet ss, survey_Def sd  
 WHERE ss.survey_ID = sd.survey_ID  
  AND ss.SampleSet_ID = @SampleSet_ID  
  
 IF @study_ID = 0 OR @Survey_ID = 0  
 BEGIN  
  IF @VendorFileID <> 0  
  BEGIN  
   UPDATE VendorFileCreationQueue  
   SET ErrorDesc = 'Study_ID/Survey_ID could not be found.  Please Contact Technical Support.', vendorfileStatus_Id = 6  
   WHERE VendorFile_ID = @VendorFileID  
  END  
  
  RAISERROR (N'Study_ID/Survey_ID could not be found.  Please Contact Technical Support.'  
    ,10  
    ,1  
    )  
  
  SET @SQL = @SQL + ', '''' as FName '  
  
  GOTO CLEANUP  
 END  
  
 IF @inDebug = 1  
 BEGIN  
  PRINT '@Study_id ' + cast(@Study_id AS VARCHAR(100))  
  PRINT '@Survey_id ' + cast(@Survey_id AS VARCHAR(100))  
 END  
  
 --Get SampleSet Info.  
 SELECT SampleSet_id  
  ,CONVERT(VARCHAR(19), datSampleCreate_dt, 120) AS 'Date Sampled'  
  ,survey_ID  
 INTO #SampleSet  
 FROM SampleSet  
 WHERE Survey_id = @Survey_id  
  AND SampleSet_ID = @SampleSet_ID  
  
 IF @inDebug = 1  
  PRINT '#SampleSet table Created'  
  
 IF @inDebug = 1  
  SELECT '#SampleSet' [#SampleSet], *  
  FROM #SampleSet  
  
 --Get all SamplePops  
 SELECT sp.SamplePop_id  
  ,cast(ISNULL(MIN(strLithoCode), 'NotPrinted') AS VARCHAR(12)) Litho  
  ,[Date Sampled]  
  ,ss.survey_ID  
  ,NULL AS HCAHPS  
  ,schm.MailingStep_ID  
  ,schm.SentMail_id  
 INTO #SamplePop  
 FROM #SampleSet ss  
  INNER JOIN SamplePop sp on ss.SampleSet_id = sp.SampleSet_id  
  INNER JOIN ScheduledMailing schm ON sp.SamplePop_id = schm.SamplePop_id  
  INNER JOIN MailingStep mm ON schm.MailingStep_ID = mm.MailingStep_ID  
  LEFT JOIN SentMailing sm ON schm.SentMail_id = sm.SentMail_id  
 WHERE mm.MailingStepMethod_id IN (2,4,9)  
 GROUP BY sp.SamplePop_id, [Date Sampled], ss.survey_ID, schm.MailingStep_ID, schm.SentMail_id  
  
 IF @inDebug = 1  
  PRINT '#SamplePop table Created'  
  
  
 -- Letter-Web mailing step won't have records in QuestionForm, so insert 'em  
 select @MaxQF=max(questionform_id) from dbo.questionform  
  
 INSERT INTO QuestionForm (Survey_id, SamplePop_id, SentMail_id)  
 select sp.Survey_id, sp.SamplePop_id, sp.SentMail_id  
 from #SamplePop sp  
  LEFT OUTER JOIN QuestionForm qf on sp.Survey_id=qf.Survey_id and sp.SamplePop_id=qf.SamplePop_id and sp.SentMail_id=qf.SentMail_id  
 where sp.SentMail_id is not null  
 and qf.SentMail_id is null  
  
 IF @@rowcount > 0 and @inDebug = 1  
  PRINT convert(varchar,@@rowcount)+' records inserted into QuestionForm'  
  
 exec dbo.CalcCAHPSSupplemental @MaxQF  
  
 IF @UseWorkTable = 1  
 BEGIN  
  DELETE  
  FROM #SamplePop  
  WHERE MailingStep_ID NOT IN (  
    SELECT MailingStep_ID  
    FROM #FG_nonMailingWork  
    )  
 END  
  
 --mwb 3/30/10  
 --hack added to fix the mulitiple MailingSteps from getting into the #SamplePop table.  
 --we should look for a better solution in the #SamplePop join above  
 IF @bitUpdate = 1  
  AND @VendorFileID <> 0  
 BEGIN  
  DELETE sp  
  FROM #SamplePop sp, VendorFileCreationQueue vfc  
  WHERE sp.MailingStep_ID NOT IN (  
    SELECT MailingStep_ID  
    FROM VendorFileCreationQueue  
    WHERE VendorFile_ID = @VendorFileID  
    )  
 END  
  
 IF @inDebug = 1  
  SELECT '#SamplePop' [#SamplePop], *  
  FROM #SamplePop  
  
 --Check to see if SamplePop was sampled for HCAHPS  
 SELECT sp.SamplePop_ID  
  ,max(cast(su.bitHCAHPS AS TINYINT)) HCAHPS  
 INTO #maxHCAHPS  
 FROM #SamplePop s, SamplePop sp, selectedSample ss, sampleunit su  
 WHERE s.SamplePop_ID = sp.SamplePop_ID  
  AND sp.SampleSet_ID = ss.SampleSet_ID  
  AND sp.study_ID = ss.study_Id  
  AND sp.pop_ID = ss.pop_ID  
  AND ss.sampleunit_ID = su.sampleunit_ID  
 GROUP BY sp.SamplePop_ID  
  
 IF @inDebug = 1  
  PRINT '#maxHCAHPS table Created'  
  
 --update SamplePop HCAHPS value  
 UPDATE s  
 SET s.HCAHPS = h.HCAHPS  
 FROM #SamplePop s, #maxHCAHPS h  
 WHERE s.SamplePop_ID = h.SamplePop_ID  
  
 --in case we still have nulls make sure they get set to 0  
 UPDATE #SamplePop  
 SET HCAHPS = 0  
 WHERE HCAHPS IS NULL  
  
 IF @inDebug = 1  
  PRINT 'HCAHPS Field Update complete'  
  
 SET @SQL = ''  
  
 IF EXISTS (  
   SELECT 'x'  
   FROM MetaData_View v, metafield m  
   WHERE strTable_nm = 'POPULATION'  
    AND m.field_ID = v.field_ID  
    AND v.study_ID = @Study_ID  
    AND m.strfield_nm = 'FName'  
   )  
  SET @SQL = @SQL + ', p.FName '  
 ELSE  
 BEGIN  
  IF @VendorFileID <> 0  
  BEGIN  
   UPDATE VendorFileCreationQueue  
   SET ErrorDesc = 'File cannot be created because First Name metafield (FName) is not mapped properly.'  
    ,vendorfileStatus_Id = 6  
   WHERE VendorFile_ID = @VendorFileID  
  END  
  
  RAISERROR (N'File cannot be created because First Name metafield (FName) is not mapped properly.'  
    ,10  
    ,1  
    )  
  
  SET @SQL = @SQL + ', '''' as FName '  
  
  GOTO CLEANUP  
 END  
  
 IF EXISTS (  
   SELECT 'x'  
   FROM MetaData_View v, metafield m  
   WHERE strTable_nm = 'POPULATION'  
    AND m.field_ID = v.field_ID  
    AND v.study_ID = @Study_ID  
    AND m.strfield_nm = 'LName'  
   )  
  SET @SQL = @SQL + ', p.LName '  
 ELSE  
 BEGIN  
  IF @VendorFileID <> 0  
  BEGIN  
   UPDATE VendorFileCreationQueue  
   SET ErrorDesc = 'File cannot be created because Last Name metafield (LName) is not mapped properly.'  
    ,vendorfileStatus_Id = 6  
   WHERE VendorFile_ID = @VendorFileID  
  END  
  
  RAISERROR (N'File cannot be created because Last Name metafield (LName) is not mapped properly.'  
    ,10  
    ,1  
    )  
  
  SET @SQL = @SQL + ', '''' as LName '  
  
  GOTO CLEANUP  
 END  
  
 IF EXISTS (  
   SELECT 'x'  
   FROM MetaData_View v, metafield m  
   WHERE strTable_nm = 'POPULATION'  
    AND m.field_ID = v.field_ID  
    AND v.study_ID = @Study_ID  
    AND m.strfield_nm = 'LangID'  
   )  
  SET @SQL = @SQL + ', p.LangID '  
 ELSE  
  SET @SQL = @SQL + ', '''' as LangID '  
  
 IF EXISTS (  
   SELECT 'x'  
   FROM MetaData_View v  
    ,metafield m  
   WHERE m.field_ID = v.field_ID  
    AND v.study_ID = @Study_ID  
    AND m.strfield_nm = 'Email_Address'  
   )  
  SET @SQL = @SQL + ', Email_Address as Email_Address '  
 ELSE  
  SET @SQL = @SQL + ', '''' as Email_Address '  
  
 IF EXISTS (  
   SELECT 'x'  
   FROM MetaData_View v, metafield m  
   WHERE m.field_ID = v.field_ID  
    AND v.study_ID = @Study_ID  
    AND m.strfield_nm = 'wbServDate'  
   )  
  SET @SQL = @SQL + ', wbServDate '  
 ELSE  
  SET @SQL = @SQL + ', null as wbServDate '  
  
 IF EXISTS (  
   SELECT 'x'  
   FROM MetaData_View v, metafield m  
   WHERE m.field_ID = v.field_ID  
    AND v.study_ID = @Study_ID  
    AND m.strfield_nm = 'wbServInd1'  
   )  
  SET @SQL = @SQL + ', wbServInd1 '  
 ELSE  
  SET @SQL = @SQL + ', '''' as wbServInd1 '  
  
 IF EXISTS (  
   SELECT 'x'  
   FROM MetaData_View v, metafield m  
   WHERE m.field_ID = v.field_ID  
    AND v.study_ID = @Study_ID  
    AND m.strfield_nm = 'wbServInd2'  
   )  
  SET @SQL = @SQL + ', wbServInd2 '  
 ELSE  
  SET @SQL = @SQL + ', '''' as wbServInd2 '  
  
 IF EXISTS (  
   SELECT 'x'  
   FROM MetaData_View v, metafield m  
   WHERE m.field_ID = v.field_ID  
    AND v.study_ID = @Study_ID  
    AND m.strfield_nm = 'wbServInd3'  
   )  
  SET @SQL = @SQL + ', wbServInd3 '  
 ELSE  
  SET @SQL = @SQL + ', '''' as wbServInd3 '  
  
 IF EXISTS (  
   SELECT 'x'  
   FROM MetaData_View v, metafield m  
   WHERE m.field_ID = v.field_ID  
    AND v.study_ID = @Study_ID  
    AND m.strfield_nm = 'wbServInd4'  
   )  
  SET @SQL = @SQL + ', wbServInd4 '  
 ELSE  
  SET @SQL = @SQL + ', '''' as wbServInd4 '  
  
 IF EXISTS (  
   SELECT 'x'  
   FROM MetaData_View v, metafield m  
   WHERE m.field_ID = v.field_ID  
    AND v.study_ID = @Study_ID  
    AND m.strfield_nm = 'wbServInd5'  
   )  
  SET @SQL = @SQL + ', wbServInd5 '  
 ELSE  
  SET @SQL = @SQL + ', '''' as wbServInd5 '  
  
 IF EXISTS (  
   SELECT 'x'  
   FROM MetaData_View v, metafield m  
   WHERE m.field_ID = v.field_ID  
    AND v.study_ID = @Study_ID  
    AND m.strfield_nm = 'wbServInd6'  
   )  
  SET @SQL = @SQL + ', wbServInd6 '  
 ELSE  
  SET @SQL = @SQL + ', '''' as wbServInd6 '  
  
 IF @inDebug = 1  
  PRINT @SQL  
  
 SET @ordername = ' LName, FName '  
  
 IF EXISTS (  
   SELECT strTable_nm  
   FROM MetaTable  
   WHERE Study_id = @Study_id  
    AND strTable_nm = 'Encounter'  
   )  
 BEGIN  
  SET @SQL = 'INSERT INTO #RESULTS (Litho, WAC, Survey_ID, SampleSet_ID, FName, LName, LangID, Email_Address, wbServDate, WbServInd1,  WbServInd2,  WbServInd3,  WbServInd4,  WbServInd5,  WbServInd6)' + CHAR(10)  
   + 'SELECT DISTINCT cast(Litho as varchar(12)), case when isnumeric(litho) = 1 then dbo.lithoToWac(litho) else ''NotPrinted'' end as WAC, t.Survey_ID, sp.SampleSet_ID '  
   + @SQL + ' ' + CHAR(10)  
   + 'FROM S' + CONVERT(VARCHAR, @Study_id) + '.Population p, SamplePop sp, #SamplePop t, SelectedSample sel, S' + CONVERT(VARCHAR, @Study_id) + '.Encounter e '  
  
  IF @UseWorkTable = 1  
   SET @SQL = @SQL + ', #FG_NonMailingWork nmw ' + CHAR(10)  
  SET @SQL = @SQL + ' WHERE t.SamplePop_id=sp.SamplePop_id' + CHAR(10)  
   + ' AND sp.Pop_id=p.Pop_id' + CHAR(10)  
   + ' AND sp.Pop_id=sel.Pop_id' + CHAR(10)  
   + ' AND sp.SampleSet_id=sel.SampleSet_id' + CHAR(10)  
   + ' AND sel.Enc_id=e.Enc_id' + CHAR(10)  
  
  IF @UseWorkTable = 1  
   SET @SQL = @SQL + ' AND nmw.SamplePop_ID = sp.SamplePop_ID AND nmw.MailingStep_ID = t.MailingStep_ID ' + CHAR(10)  
  SET @SQL = @SQL + ' ORDER BY ' + @Ordername  
 END  
 ELSE  
 BEGIN  
  SET @SQL = 'INSERT INTO #RESULTS (Litho, WAC, Survey_ID, SampleSet_ID, FName, LName, LangID, Email_Address, wbServDate, WbServInd1,  WbServInd2,  WbServInd3,  WbServInd4,  WbServInd5,  WbServInd6) ' + CHAR(10)  
   + 'SELECT DISTINCT cast(t.Litho as varchar(12)), case when isnumeric(litho) = 1 then dbo.lithoToWac(litho) else ''NotPrinted'' end as WAC, t.Survey_ID, sp.SampleSet_ID  '  
   + @SQL + ' ' + CHAR(10)  
   + 'FROM S' + CONVERT(VARCHAR, @Study_id) + '.Population p, SamplePop sp, #SamplePop t '  
  
  IF @UseWorkTable = 1  
   SET @SQL = @SQL + ', #FG_NonMailingWork nmw ' + CHAR(10)  
  SET @SQL = @SQL + ' WHERE t.SamplePop_id=sp.SamplePop_id' + CHAR(10) + ' AND sp.Pop_id=p.Pop_id' + CHAR(10)  
  
  IF @UseWorkTable = 1  
   SET @SQL = @SQL + ' AND nmw.SamplePop_ID = sp.SamplePop_ID AND nmw.MailingStep_ID = t.MailingStep_ID' + CHAR(10)  
  SET @SQL = @SQL + 'ORDER BY ' + @Ordername  
 END  
  
 IF @inDebug = 1  
  PRINT @sql  
  
 EXEC (@sql)  
  
 IF @inDebug = 1  
  SELECT '#RESULTS Before NotPrinted Delete' [#RESULTS], *  
  FROM #RESULTS  
  
 IF @SaveData = 0  
 BEGIN  
  SELECT count(*) NotPrintedCount  
  FROM #Results  
  WHERE cast(litho AS VARCHAR(50)) = 'NotPrinted'  
 END  
 ELSE  
 BEGIN  
  SELECT @NoLithoCount = count(*)  
  FROM #Results  
  WHERE cast(litho AS VARCHAR(50)) = 'NotPrinted'  
 END  
  
 DELETE  
 FROM #Results  
 WHERE cast(litho AS VARCHAR(50)) = 'NotPrinted'  
  
 IF @SaveData = 0  
 BEGIN  
  SELECT Litho, WAC, Survey_ID, SampleSet_ID, FName, LName, LangID, wbServDate, WbServInd1, WbServInd2, WbServInd3, WbServInd4, WbServInd5, WbServInd6  
  FROM #Results  
  ORDER BY Litho  
 END  
 ELSE  
 BEGIN  
  --we want to force an insert if there are no values in the table.  
  --even if the user selected to update the data.  
  IF (  
    SELECT count(*)  
    FROM VendorPhoneFile_Data  
    WHERE VendorFile_Id = @VendorFileID  
    ) = 0  
  BEGIN  
   IF @inDebug = 1  
    PRINT 'Forced @bitUpdate = 0.  Records will be inserted instead of updated.'  
  
   SELECT @bitUpdate = 0  
  END  
  
  IF @bitUpdate = 0  
  BEGIN  
   /*  
   2013-1213 CAmelinckx  
   Modifying this to solve INC0010159 WebFiles being reset to pending after being approved/sent  
   The problem arises when there are multiple paper configurations within the same survey instance  
   As each paper configuration subset of surveys are mailed, they mail date is set and causes this  
   logic to run.  
   The first time it runs, it already includes all of the LithoCodes=WACs that need to be included  
   So there is really no point in recreating the webfile if it already exists and is past the approval state.  
  
   The approach I'm taking here is as follows:  
   Only if the set of lithos that are to be placed in the VendorWebFile_Data is different,  
   specifically if there are any extra records than originally were, then we would allow the file to get  
   recreated, if it is the same data set, then just bypass this step.  
   */  
  
   DECLARE @NewLithosInFileCount INT  
   SET @NewLithosInFileCount =   
   (  
    SELECT COUNT(*)   
    FROM  
        #Results R  
     LEFT JOIN VendorWebFile_Data VWFD ON R.Litho = VWFD.Litho AND VWFD.VendorFile_ID = @VendorFileID  
    WHERE VWFD.Litho IS NULL       
   )  
     
   IF @NewLithosInFileCount = 0  
   BEGIN  
    IF @inDebug = 1  
      PRINT 'There are NO new lithos in this web file, we keep it as it is.'  
   END  
   ELSE  
   BEGIN  
    /*  
    The following is an old note that was sitting in this block:  
    ---------------------------------------------------------------------------------------  
    --usually there will be nothing here, but it is possible to have records already in the  
    --system.  In that case we only want 1 set of data.  
    */  
    IF @inDebug = 1  
     PRINT 'Delete records from VendorWebFile_Data'  
  
    DELETE  
    FROM VendorWebFile_Data  
    WHERE VendorFile_Id = @VendorFileID  
  
    IF @inDebug = 1  
     PRINT 'insert new records into VendorWebFile_Data'  
  
    INSERT INTO VendorWebFile_Data (VendorFile_ID, Litho, WAC, Survey_ID, SampleSet_ID, FName, LName, [LangID], Email_Address, wbServDate, WbServInd1, WbServInd2, WbServInd3, WbServInd4, WbServInd5, WbServInd6)  
    SELECT @VendorFileID AS VendorFile_ID, Litho, WAC, Survey_ID, SampleSet_ID, FName, LName, LangID, Email_Address, wbServDate, WbServInd1, WbServInd2, WbServInd3, WbServInd4, WbServInd5, WbServInd6  
    FROM #Results  
  
    SET @RecordCount = @@RowCount  
  
    UPDATE VendorFileCreationQueue  
    SET dateDataCreated = getdate()  
     ,VendorFileStatus_ID = 2  
     ,RecordsInFile = @RecordCount  
     ,RecordsNoLitho = @NoLithoCount  
     ,ErrorDesc = ''  
    WHERE VendorFile_ID = @VendorFileID  
   END  
  END  
  ELSE  
  BEGIN  
   IF @inDebug = 1  
    PRINT 'Update existing records in VendorWebFile_Data'  
  
   UPDATE VWF  
   SET VWF.Survey_ID = r.Survey_ID  
    ,VWF.SampleSet_ID = r.SampleSet_ID  
    ,VWF.FName = r.FName  
    ,VWF.LName = r.LName  
    ,VWF.[LangID] = r.[LangID]  
    ,VWF.Email_Address = r.Email_Address  
    ,VWF.wbServDate = r.WbServDate  
    ,VWF.WbServInd1 = r.WbServInd1  
    ,VWF.WbServInd2 = r.WbServInd2  
    ,VWF.WbServInd3 = r.WbServInd3  
    ,VWF.WbServInd4 = r.WbServInd4  
    ,VWF.WbServInd5 = r.WbServInd5  
    ,VWF.WbServInd6 = r.WbServInd6  
   FROM VendorWebFile_Data VWF, #results r  
   WHERE VWF.litho = r.litho  
    AND VWF.VendorFile_ID = @VendorFileID  
  
   SET @RecordCount = @@RowCount  
  
   UPDATE VendorFileCreationQueue  
   SET dateDataCreated = getdate()  
    ,VendorFileStatus_ID = 2  
    ,RecordsInFile = @RecordCount  
    ,RecordsNoLitho = @NoLithoCount  
    ,ErrorDesc = ''  
   WHERE VendorFile_ID = @VendorFileID  
  END  
 END  
  
 IF @VendorFileID <> 0  
 BEGIN  
  IF @inDebug = 1  
   PRINT 'calling QSL_VendorFileCreateCounts'  
  
  EXEC QSL_VendorFileCreateCounts @VendorFileID  
   ,@inDebug  
  
  IF @inDebug = 1  
   PRINT 'calling QSL_VendorFileValidation'  
  
  EXEC QSL_VendorFileValidation @VendorFileID  
   ,@inDebug  
 END  
  
 CLEANUP:  
 DROP TABLE #SampleSet  
 DROP TABLE #SamplePop  
 DROP TABLE #Results  
 DROP TABLE #maxHCAHPS  
END


