USE [QP_Comments]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

if exists (select 1 from sys.columns where Name = 'ICD10_1' and object_id = OBJECT_ID('ExportFileHHCAHPSDetails'))
	alter table dbo.ExportFileHHCAHPSDetails drop column
		ICD10_1,
		ICD10_2,
		ICD10_3,
		ICD10_4,
		ICD10_5,
		ICD10_6
go

/*************************************************************************************************                                
9-15-2006 DC Modified code that inserts into ExportFileMember to prevent duplicates that cause                                 
    primary key errors.                                
4/16/08 MWB - Modified code to include @Method that is returned from DCL_ExportCreateFile_Sub.                              
  Per CMS Method needs to be reported at the header level, not the member level.                              
 Stratified Exports will return several recordsets so we use #method as a way to capture the results                            
 from serveral files in order to give 1 distinct result                            
4/08/09 MWB - Modified code that changed the logic for @sampleType and added new recordset that returned                          
    HDOSL (HCAHPS Determination of Service Line).  Routine changes from CMS                          
07/30/09 MWB - added @IncludeDispositionRecords to include fields from VendorDispositionLog                    
08/03/09 MWB - Added HDOSL logic to select a distinct listing From #HDOSL                          
    - (populated in DCL_ExportCreateFile_Sub)                        
    - This change was needed from above b/c line before only returned 1 value (not multiple)                        
10/30/09 MWB - added PENumber to the header file.  This field is only used for CHART exports but will                  
    - come back all the time so that the recordset is consistant.                      
02/09/10 MWB - Added @ExportSetTypeID logic to determine how to lookup SampleType.                  
 - HCAHPS/CHART and HHCHPS look up this value in different ways.                
07/27/2010 MWB - Added @HHNQLField field as optional in the save file b/c this field is only present        
 - sometimes.        
10/25/2010 dmp - Corrected HHCAHPS sample type to be 2 (simple random) if sample period not set to census,        
 lese set to 1 (census). Previously had incorrectly been 1 if not census, else 3.        
11/01/2010 DRM - Added fix for studies that are missing study results tables.    
09/30/2011 DRM - Added fix to filter out empty methods from sub proc.
**************************************************************************************************/                                
                                
ALTER PROCEDURE [dbo].[DCL_ExportCreateFile]                                  
@ExportSets VARCHAR(2000),                                  
@ReturnsOnly BIT,                                  
@DirectsOnly BIT,                                  
@ExportFileGUID UNIQUEIDENTIFIER,                     
@IncludeDispositionRecords bit = 0,            
@SaveData bit = 0,            
@ReturnData bit = 1,                       
@indebug int = 0                                
AS                                   
                    
                    
/**********************************************************************************************                    
                    
--testing code                 
select *               
from exportset               
--where survey_Id = 188              
order by updateddate desc               
        
select * from medicareexportsets where medicareexportset_ID = 289        
                   
--If running a specific export                
delete from ExportFileMember where exportfileGUID = 'C8B6810D-C13B-442C-9FB1-331F830A0C2F'                          
delete from ExportSetCMSAvailableCount where exportfileGUID = 'C8B6810D-C13B-442C-9FB1-331F830A0C2F'                          
DCL_ExportCreateFile '329', 0,0, 'C8B6810D-C13B-442C-9FB1-331F830A0C2F', 0, 0, 1, 1                    
                
--running a generic export based off of a new GUID                
declare @NewGuid varchar(50)                
select @NewGuid = cast(NewID() as varchar(36))                
exec DBO.DCL_ExportCreateFile 353,0,1,@NewGuid,0,1,1,0              
ShowAllExportSetInformation               
            
 exec DCL_ExportCreateFile_ByMedicareNumber 122, 1, 1, 0                
                
***********************************************************************************************/                      
                                  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                                  
SET NOCOUNT ON                            
            
if @indebug = 1            
begin            
 print '@ExportSets =' + cast(@ExportSets as varchar(100))          
 print '@ReturnsOnly =' + cast(@ReturnsOnly as varchar(100))            
 print '@DirectsOnly =' + cast(@DirectsOnly as varchar(100))            
 print '@ExportFileGUID =' + cast(@ExportFileGUID as varchar(100))            
 print '@IncludeDispositionRecords =' + cast(@IncludeDispositionRecords as varchar(100))            
 print '@SaveData =' + cast(@SaveData as varchar(100))            
 print '@ReturnData =' + cast(@ReturnData as varchar(100))            
 print '@indebug =' + cast(@indebug as varchar(100))            
end             
            
                            
--new Variable that is returned from DCL_ExportCreateFile_Sub that indicates the methodologytype                              
--used for colection of data.                              
DECLARE @Method varchar(100), @FinalMethod varchar(100)                             
DECLARE @blnMultipleFacilities bit, @blnMultipleSamplesPerMonth bit                        
DECLARE @ExportSetTypeID int, @Samplesets varchar(2000)                     
DECLARE @PatInFile int, @CountPatInFileRecords int, @PatInFileServed int, @CountPatInFileServedRecords int                 
DECLARE @IncludeOCSFields bit, @Survey_ID int, @ClientGroup varchar(100)              
DECLARE @HHNQLField varchar(100), @study_ID varchar(10)        
DECLARE @tmp_tablename varchar(50), @tmp_tableschema varchar(10)      
--DECLARE @HDOSL int                        
                        
--Use the last 12 digits to ensure a unique table name for the temporary storage                                  
DECLARE @Unique VARCHAR(40)                                  
SELECT @Unique=RIGHT(CONVERT(VARCHAR(40),@ExportFileGUID),12)                                  
                                  
CREATE TABLE #ExportSets2 (                                  
   ExportSetID INT,                         
   Study_id INT,                
   Survey_ID INT,                              
   HeaderRecord BIT,                                  
   Pulled BIT NOT NULL DEFAULT(0),                
   ExportSetTypeID INT                                  
)                                  
CREATE TABLE #ExportTables (                                  
   Table_Schema VARCHAR(20),                                  
   Table_Name VARCHAR(200),                                  
   StatementBuilt BIT                                  
)                                  
CREATE TABLE #Columns (                                  
   Column_id INT IDENTITY(1,1),                                  
   Column_Name VARCHAR(200),                                  
   bitQuestion BIT,                                  
   bitUsed BIT                                  
)                                  
CREATE TABLE #TableColumns (                                  
   Table_Schema VARCHAR(20),                                  
   Table_Name VARCHAR(200),                                  
   Column_Name VARCHAR(200)                                  
)                                  
CREATE TABLE #Statements (                                  
   a INT IDENTITY(1,1),                                  
   Statement VARCHAR(8000),                                  
   bitUnion BIT                                  
)                                
                            
CREATE TABLE #Method (                            
Method varchar(100)                            
)                            
                        
CREATE TABLE #HDOSL (                            
HDOSL varchar(100)                            
)               
                             
CREATE TABLE #DeletedHCAHPSRecords (                            
DeletedCount int                            
)                                
                                 
if @indebug = 1                        
 print 'Finished create tables'                                 
                                  
--Create a default record to ensure the sum returns something                                
INSERT #DeletedHCAHPSRecords (DeletedCount) values (0)                                
                                  
DECLARE @sql VARCHAR(8000), @ExportSetID INT, @Table_Schema VARCHAR(20), @Table_Name VARCHAR(200)                                  
DECLARE @Column_Name VARCHAR(100), @Column_id INT, @CreateHeader BIT, @MedicareName VARCHAR(45)                   
DECLARE @PENumber VARCHAR(10), @NumberofPENumbers INT                                 
DECLARE @MedicareNumber VARCHAR(20), @DisYear INT, @DisMonth INT, @EligibleCount INT, @SampleType INT                          
DECLARE @SwitchToPropDate datetime                                  
            
            
--with the change to using MedicareExportSets it is now possible to use the same GUID            
--more than once.  Since we always want the data to be current we simply delete before the insert            
SELECT @sql='Delete from ExportFileMember where ExportFileGUID = '''+CONVERT(VARCHAR(40),@ExportFileGUID) + ''''            
if @indebug = 1 print @sql            
Exec (@SQL)            
                                  
--Put the exportsets into a table                                  
SELECT @sql='INSERT INTO #ExportSets2 (ExportSetID, Study_id, Survey_ID, HeaderRecord, ExportSetTypeID)                                  
SELECT ExportSetID, Study_id, Survey_ID, HCAHPSHeaderRecord, es.ExportSetTypeID                                  
FROM ExportSet es, ExportSetType est                                  
WHERE ExportSetID IN ('+@ExportSets+')                                  
AND es.ExportSetTypeID=est.ExportSetTypeID'                                  
EXEC (@sql)                        
                                  
IF @@ROWCOUNT=0                                  
BEGIN                                  
                                  
   RAISERROR ('No Valid ExportSets',18,1)                                  
   GOTO Cleanup                                  
                                  
END                                  
                                  
IF (SELECT COUNT(DISTINCT HeaderRecord) FROM #ExportSets2)<>1                                  
BEGIN                                  
                                  
   RAISERROR ('Cannot combine multiple ExportSet Types',18,1)                                  
   GOTO Cleanup                                  
                                  
END                                  
                                  
-- Value of 1 means only pull the HCAHPS units and create the header record                                  
-- Value of 0 means return all with no header record                                  
SELECT TOP 1 @CreateHeader=HeaderRecord                                  
FROM #ExportSets2                                  
                
--I use the order by so if we have a standard (0) export combined with a H or HH CAHPS                
--export it will be treated like a standard export.  H, Chart and HH CAHPS cannot be                
--combined types so I error on the side of caution.                
SELECT TOP 1 @ExportSetTypeID=ExportSetTypeID, @Survey_ID=Survey_ID                                  
FROM #ExportSets2 e                
order by ExportSetTypeID                
if @indebug = 1 print '@ExportSetTypeID =' + cast(@ExportSetTypeID as varchar(5))                
            
Select top 1 @ClientGroup = strClientGroup_nm            
from clientstudysurvey             
where Survey_ID = @Survey_ID            
            
if @ExportSetTypeID = 4 and @ClientGroup like '%OCS%'            
 set @IncludeOCSFields = 1            
else            
    set @IncludeOCSFields = 0            
            
if @indebug = 1 print '@IncludeOCSFields =' + cast(@IncludeOCSFields as varchar(5))                
            
--If it's not an HCAHPS export, then they can't combine multiple clients                                
IF @CreateHeader=0                                
BEGIN                 
 IF (SELECT COUNT(DISTINCT Client_id)                                   
 FROM #ExportSets2 t, ClientStudySurvey c                                  
 WHERE t.Study_id=c.Study_id)<>1                                 
  BEGIN                                  
                             
  RAISERROR ('ExportSets are not for the same client',18,1)                                  
  GOTO Cleanup                                  
                           
  END          
                           
END                         
        
        
select top 1 @study_ID = study_Id from #ExportSets2        
if @indebug = 1 print '@study_ID = ' + cast(@study_ID as varchar(100))        
                        
if @indebug = 1                            
 select '#ExportSets2' as [#ExportSets2], * from #ExportSets2                            
                
Create table #PatInFileDistinctCounts (PatInFile int)                
Create table #PatInFileServedCounts (PatInFileServed int)                
                                  
--Loop thru the exportsets to create the Export tables.                                  
SELECT TOP 1 @ExportSetID=ExportSetID                                  
FROM #ExportSets2                                  
WHERE Pulled=0                                  
ORDER BY 1                                  
                                  
WHILE @@ROWCOUNT>0                                  
BEGIN                                  
                        
 if @indebug = 1 print 'before DCL_ExportCreateFile_Sub.  ExportSet_ID =' + cast(@ExportSetID as varchar(100))                        
--   SELECT @sql='INSERT INTO #ExportTables (Table_Schema, Table_Name)                                   
--   EXEC DCL_ExportCreateFile_Sub '+LTRIM(STR(@ExportSetID))+','+LTRIM(STR(@ReturnsOnly))+','+LTRIM(STR(@DirectsOnly))                                  
--   INSERT INTO #ExportTables (Table_Schema, Table_Name)                                   
   set @Method = ''                              
   --set @HDOSL = -1                        
   EXEC DCL_ExportCreateFile_Sub @ExportSetID, @ReturnsOnly, @DirectsOnly, @ExportFileGUID, @CreateHeader, @Method OUTPUT,  @indebug                        
                    
 if @indebug = 1 print 'after DCL_ExportCreateFile_Sub.  ExportSet_ID =' + cast(@ExportSetID as varchar(100))                        
                               
  --we add to a temp table for stratified data.                            
  --Then before the field is added to the header record we will check to see if we have 1 distinct list                            
  --or serveral different values.                            
  insert into #Method Select @Method where ltrim(@method) <> ''		--DRM 09/30/2011  Added where clause to filter out empty methods.
    
  if @indebug = 1  print @Method    
  if @indebug = 1  select '#Method' as [#Method], * from #Method                        
                    
                                 
   UPDATE #ExportSets2                                  
   SET Pulled=1                                  
   WHERE ExportSetID=@ExportSetID                                  
                                  
   SELECT TOP 1 @ExportSetID=ExportSetID                                  
   FROM #ExportSets2                                  
   WHERE Pulled=0                                  
   ORDER BY 1                                  
                              
END                                  
                        
if @indebug = 1                        
 select '#ExportTables 1' as [#ExportTables 1], * from #ExportTables                        
                        
                                    
IF (SELECT COUNT(*) FROM #ExportTables)=0                                  
BEGIN                                  
 RAISERROR ('No records exported.',18,1)                                  
 RETURN                                  
END                                  
                                  
if @indebug = 1                        
 select '#ExportTables 2' as [#ExportTables], * from #ExportTables                        
                        
                                  
--Log the samplepops                                  
SELECT @sql=''                                  
SELECT @sql=@sql+CASE WHEN @sql='' THEN '' ELSE ' UNION ' END+CHAR(10)+                               
'SELECT '''+CONVERT(VARCHAR(40),@ExportFileGUID)+''',SampPop,SampUnit,Max(CASE WHEN Rtrn_dt IS NULL THEN 0 ELSE 1 END)                                  
FROM '+Table_Schema+'.'+Table_Name+CHAR(10) +                                
' GROUP BY SampPop,SampUnit'                                 
FROM #ExportTables                                  
                                  
SELECT @sql='INSERT INTO ExportFileMember (ExportFileGUID,SamplePop_id, Sampleunit_id, bitIsReturned) '+@sql                                  
                      
if @indebug = 1  print @sql                      
                                
EXEC (@sql)                                  
                
if @indebug = 1 select '#PatInFileDistinctCounts' as [#PatInFileDistinctCounts], * from #PatInFileDistinctCounts                
if @indebug = 1 select '#PatInFileServedCounts' as [#PatInFileServedCounts], * from #PatInFileServedCounts                
                
                
if (select count(*) from #PatInFileDistinctCounts) > 0                
 BEGIN                
  Select @PatInFile = sum(PatInFile), @CountPatInFileRecords = count(*)                
  from #PatInFileDistinctCounts            
  where PatInFile is not null                
 END                
ELSE                
 BEGIN                
  set @PatInFile= 0                
  set @CountPatInFileRecords = 0                
 END                
                
                
if (select count(*) from #PatInFileServedCounts) > 0                
 BEGIN                
  Select  @PatInFileServed = sum(PatInFileServed), @CountPatInFileServedRecords = count(*)                
  from #PatInFileServedCounts             
  where PatInFileServed is not null               
 END                
ELSE                
 BEGIN                
  set @PatInFileServed = 0                
  set @CountPatInFileServedRecords = 0                
 END                
                
                
                                  
IF @CreateHeader=1                            
BEGIN                                  
                                  
 --This calls a procedure in Qualisys                        
 if @indebug = 1  print 'exec DCL_ExportFileCMSAvailableCount'                              
 EXEC DCL_ExportFileCMSAvailableCount @ExportSets, @ExportFileGUID, @indebug              
                                  
 --Get the Header information                                  
 SELECT TOP 1 @MedicareName=MedicareName, @MedicareNumber=MedicareNumber,                                  
 @DisYear=YEAR(EncounterStartDate), @DisMonth=MONTH(EncounterStartDate), @PENumber=su.PENumber                                  
 FROM #ExportSets2 t, ExportSet es, SampleUnit su                                   
 WHERE t.ExportSetID=es.ExportSetID AND                                  
  es.SampleUnit_id=su.SampleUnit_id                                  
                  
                  
 Select @NumberofPENumbers = count(distinct su.PENumber)                  
 FROM #ExportSets2 t, ExportSet es, SampleUnit su                                   
 WHERE t.ExportSetID=es.ExportSetID AND                                  
  es.SampleUnit_id=su.SampleUnit_id                          
                  
 SELECT @EligibleCount=sum(AvailableCount)                                   
 FROM ExportSetCMSAvailableCount                                
 WHERE ExportFileGUID=@ExportFileGUID                                  
                            
                        
                            
if (select count(Distinct Method) from #Method) = 1                            
 begin                            
  select @FinalMethod = method from #Method                            
 end                            
                            
if (select count(Distinct Method) from #Method) > 1                            
 begin                            
  set @FinalMethod = 'MIXED'                            
 end                            
                            
if (select count(Distinct Method) from #Method) < 1                            
 begin                            
  set @FinalMethod = 'MISSING'                            
 end                            
                        
                        
if @indebug = 1                        
 select '#ExportTables 3' as [#ExportTables], * from #ExportTables                        
                        
                            
--Return HDOSL (created in DCL_ExportCreateFile_Sub proc)                        
if @ReturnData = 1            
BEGIN            
 Select distinct HDOSL from #HDOSL                          
END            
            
if @SaveData = 1            
BEGIN            
 Delete from ExportFileHDOSL where ExportFileGuid = @ExportFileGUID            
             
 insert into ExportFileHDOSL (ExportFileGuid, HDOSL)            
 Select distinct @ExportFileGUID as ExportFileGUID, HDOSL from #HDOSL                          
END            
                        
                            
if @ExportSetTypeID in (2,3)                
BEGIN                
 --HCAHPS OR CHART                
                     
    if @indebug = 1                
 begin                
  select * from Qualisys.qp_prod.dbo.qualpro_params where strParam_nm = 'SwitchToPropSamplingDate'                          
  select min(EncounterStartDate) from ExportSet WHERE ExportSetID IN (select ExportSetID from #ExportSets2)                
  select * from ExportSet WHERE ExportSetID IN (select ExportSetID from #ExportSets2)                
 end                    
                         
 select @SwitchToPropDate = DatParam_Value from Qualisys.qp_prod.dbo.qualpro_params where strParam_nm = 'SwitchToPropSamplingDate'                          
                           
  --Return the header record                          
 if (select min(EncounterStartDate) from ExportSet WHERE ExportSetID IN (select ExportSetID from #ExportSets2)) < @SwitchToPropDate                                     
  begin                          
   IF (SELECT COUNT(*) FROM #ExportSets2)>1                           
    SET @SampleType=3                                
   ELSE                           
    SET @SampleType=1                                 
  end                          
 else                          
                            
  begin                          
   set @SampleType = -1                          
                              
   --IF cencus Sampling for any sampleset @SampleType=1                            
create table #samplesets (Sampleset_ID int)                          
   create table #SampleSetResults (CensusForced int)                                   
   SELECT @sql='insert into #samplesets(Sampleset_ID) select distinct SampSet as Sampleset_ID from ' + Table_Schema + '.' + Table_Name                           
   FROM #ExportTables                           
                         
    if @indebug = 1 print @sql                          
    EXEC(@sql)                          
                         
   set @Samplesets = ''                        
   select @Samplesets = @Samplesets + cast(Sampleset_ID as varchar(1000)) + ',' from #samplesets                          
   set @Samplesets = left(@Samplesets, len(@Samplesets) - 1)                          
                         
   insert into #SampleSetResults                          
   exec qualisys.qp_prod.dbo.QCL_IsHCAHPSSamplesetCensusForced @Samplesets                          
                      
   if @indebug = 1                         
    begin                        
  print '@Samplesets = ' + cast(@Samplesets as varchar(1000))                        
  select '#SampleSetResults' as [#SampleSetResults], * from #SampleSetResults                        
    end                         
                            
   if (select max(CensusForced) from #SampleSetResults) = 1                          
    begin                          
  SET @SampleType=1                         
  if @indebug = 1 print 'CensusForced Flag = 1'                           
    end                          
   --END:  IF cencus Sampling for any sampleset @SampleType=1                            
   else                              
    begin --now check for more then 1 suFaclity_ID begining returned for the selected Samplesets                          
                             
   create table #SampleUnits (SampleUnit_ID int)                          
   create table #SampleUnitResults (SuFacility_ID int)                          
   declare @SampleUnits varchar(2000)                          
   set @SampleUnits = ''                        
                              
   SELECT @sql='insert into #SampleUnits(SampleUnit_ID) select distinct SampUnit as SampleUnit_ID from ' + Table_Schema + '.' + Table_Name                           
   FROM #ExportTables                           
                          
   if @indebug = 1 print @sql                          
   EXEC(@sql)                          
                          
   if @indebug = 1 select '#SampleUnits' as [#SampleUnits], * from #SampleUnits                        
                          
   select @SampleUnits = @SampleUnits + cast(SampleUnit_ID as varchar(1000)) + ',' from #SampleUnits                          
   set @SampleUnits = left(@SampleUnits, len(@SampleUnits) - 1)                          
                                
   insert into #SampleUnitResults                          
   exec qualisys.qp_prod.dbo.QCL_ReturnMedicareFacilities @SampleUnits                          
                                
   if @indebug = 1                         
    begin                        
    select '#SampleUnitResults' as [#SampleUnitResults], * from #SampleUnitResults                        
    print '@SampleUnits = ' + cast(@SampleUnits as varchar(1000))                        
    end                        
                                
   if (select count(*) from  #SampleUnitResults) > 1                          
    SET @blnMultipleFacilities = 1                        
   else                        
    set @blnMultipleFacilities = 0                        
                               
                          
   --END: now check for more then 1 suFaclity_ID begining returned for the selected Samplesets                          
                          
   --next check is to see if we are sampling more then once a month.                          
   --if so @SampleType=2; if not @SampleType=1                          
                                
   if (select count(*) from  #SampleSets) > 1                          
    SET @blnMultipleSamplesPerMonth=1                           
   else                          
    SET @blnMultipleSamplesPerMonth=0                          
                               
                               
   if @blnMultipleFacilities = 0 and @blnMultipleSamplesPerMonth = 0                        
    SET @SampleType=1                        
                               
   if @blnMultipleFacilities = 1 and @blnMultipleSamplesPerMonth = 0                        
    SET @SampleType=2                        
                          
   if @blnMultipleFacilities = 0 and @blnMultipleSamplesPerMonth = 1                        
    SET @SampleType=2                        
   
   if @blnMultipleFacilities = 1 and @blnMultipleSamplesPerMonth = 1                        
    SET @SampleType=2                        
                              
                         
    end --now check for more then 1 suFaclity_ID begining returned for the selected Samplesets                           
                            
  end                
                
                     
 if @indebug = 1                        
  begin                          
   print '@blnMultipleFacilities = ' + cast(@blnMultipleFacilities as varchar(100))                         
   print '@blnMultipleSamplesPerMonth = ' + cast(@blnMultipleSamplesPerMonth as varchar(100))                        
   print '@SampleType = ' + cast(@SampleType as varchar(100))                        
  end                      
                  
END -- IF ExportSetTypeID in (2,3)                        
                
IF @ExportSetTypeID = 4                
BEGIN                
                 
 create table #HHsamplesets (Sampleset_ID int)                          
 create table #HHSampleSetResults (Sampleset_ID int, SamplingMethod_ID int)                          
                             
 SELECT @sql='insert into #HHsamplesets(Sampleset_ID) select distinct SampSet as Sampleset_ID from ' + Table_Schema + '.' + Table_Name                           
 FROM #ExportTables                           
                         
 if @indebug = 1 print @sql                          
 EXEC(@sql)                          
                
 if @indebug = 1                         
  begin                        
   select '#HHSampleSetResults' as [#HHSampleSetResults], * from #HHSampleSetResults                        
   Select @sql = 'select * from ' + Table_Schema + '.' + Table_Name FROM #ExportTables                
   print @sql                
   Exec (@sql)                          
  end                         
                
 if (select count(*) from #HHsamplesets) > 0                         
 begin                
  set @Samplesets = ''                
  select @Samplesets = @Samplesets + cast(Sampleset_ID as varchar(1000)) + ',' from #HHsamplesets                          
  set @Samplesets = left(@Samplesets, len(@Samplesets) - 1)                          
                          
           
   insert into #HHSampleSetResults        
  exec qualisys.qp_prod.dbo.QCL_IsHHCAHPSSamplesetCensusForced @Samplesets, @indebug                         
 end                
 else                
 begin                
  RAISERROR ('No Valid Samplesets found while checking for HHCAHPS Census Sampling',18,1)                
 end                   
                       
 if @indebug = 1                         
  begin                        
   print '@Samplesets = ' + cast(@Samplesets as varchar(1000))                        
   select '#HHSampleSetResults' as [#HHSampleSetResults], * from #HHSampleSetResults                        
  end                         
                    
 if (select count(*) from #HHSampleSetResults where SamplingMethod_ID <> 3) > 0                          
  begin                          
   SET @SampleType=2      --simple random                   
   if @indebug = 1 print 'At least one HHCAHPS Sampleset was created not census Sampling.  @SampleType=2'                           
  end                          
 Else                
  begin                
   SET @SampleType=1      --census                   
   if @indebug = 1 print 'ALL HHCAHPS Samplesets were created using census Sampling.  @SampleType=1'                           
  end              
END  --@ExportSetTypeID = 4                
                
                          
 if @ReturnData = 1            
 BEGIN                          
  --Actual Header Record Select                           
  SELECT @MedicareName MedicareName, @MedicareNumber MedicareNumber,                                  
  @DisYear DisYear, @DisMonth DisMonth, @EligibleCount NumberEligible,                              
  COUNT(distinct SamplePop_id) SampleCount, @SampleType SampleType, CONVERT(INT,NULL) DSRPSurveyed,                                   
  CONVERT(INT,NULL) DSRPEligible, @FinalMethod Method, @PENumber PENumber, @NumberofPENumbers  NumberofPENumbers,                
  isnull(@PatInFile, 0) PatientsInFile, isnull(@CountPatInFileRecords,0) DistinctCountOfPatInFileRecords,                 
  isnull(@PatInFileServed, 0) PatientsInFileServed, isnull(@CountPatInFileServedRecords, 0) DistinctCountOfPatInFileServedRecords                                  
  FROM ExportFileMember                                  
  WHERE ExportFileGUID=@ExportFileGUID                                  
                                 
             
  --Return the sub header information if there are multiple export sets being combined.                                
  IF @SampleType=3 and (@ExportSetTypeID =2 or @ExportSetTypeID = 3)                              
  BEGIN                                
    SELECT c.sampleunit_id as strataname, c.AvailableCount as dsrseligible,                                
    count(samplepop_id) as dsrssamplesize                                    
    FROM ExportSetCMSAvailableCount c left join ExportFileMember m                                
    on c.ExportFileGUID=m.ExportFileGUID                                
    and c.sampleunit_id=m.sampleunit_id                      
    WHERE  c.ExportFileGUID=@ExportFileGUID                                  
    GROUP BY c.sampleunit_id, c.AvailableCount                                
  END                                
 END --@ReturnData = 1                                 
             
  if @SaveData = 1            
  BEGIN                          
  --Actual Header Record Select             
              
  Delete from ExportFileHeader where ExportFileGuid = @ExportFileGUID            
            
              
  insert into ExportFileHeader( ExportFileGUID,MedicareName,MedicareNumber,DisYear,DisMonth,            
         NumberEligible,SampleCount,SampleType,DSRPSurveyed,DSRPEligible,            
         method,PENumber,NumberofPENumbers,PatientsInFile,            
         DistinctCountOfPatInFileRecords,PatientsInFileServed,            
         DistinctCountOfPatInFileServedRecords)                            
  SELECT @ExportFileGUID as ExportFileGUID, @MedicareName MedicareName, @MedicareNumber MedicareNumber,                                  
  @DisYear DisYear, @DisMonth DisMonth, @EligibleCount NumberEligible,                              
  COUNT(distinct SamplePop_id) SampleCount, @SampleType SampleType, CONVERT(INT,NULL) DSRPSurveyed,                                   
  CONVERT(INT,NULL) DSRPEligible, @FinalMethod Method, @PENumber PENumber, @NumberofPENumbers  NumberofPENumbers,                
  @PatInFile PatientsInFile, @CountPatInFileRecords DistinctCountOfPatInFileRecords,                 
  @PatInFileServed PatientsInFileServed, @CountPatInFileServedRecords DistinctCountOfPatInFileServedRecords                                  
  FROM ExportFileMember                                  
  WHERE ExportFileGUID=@ExportFileGUID                                  
                                 
             
  --Return the sub header information if there are multiple export sets being combined.                                
  IF @SampleType=3 and (@ExportSetTypeID =2 or @ExportSetTypeID = 3)                              
  BEGIN              
              
      Delete from exportFileSubHeader where ExportFileGuid = @ExportFileGUID            
            
              
    insert into exportFileSubHeader(ExportFileGUID,strataname,dsrseligible,dsrssamplesize)                              
    SELECT @ExportFileGUID as ExportFileGUID, c.sampleunit_id as strataname, c.AvailableCount as dsrseligible,                                
    count(samplepop_id) as dsrssamplesize                                    
    FROM ExportSetCMSAvailableCount c left join ExportFileMember m                                
    on c.ExportFileGUID=m.ExportFileGUID                                
    and c.sampleunit_id=m.sampleunit_id                                
    WHERE  c.ExportFileGUID=@ExportFileGUID                                  
    GROUP BY c.sampleunit_id, c.AvailableCount                                
  END                            
  END --@SaveData = 1                
            
             
end  --@CreateHeader=1                              
                        
if @indebug = 1                        
 select '#ExportTables' as [#ExportTables], * from #ExportTables                        
                                  
--07/30/09 MWB                            
IF (SELECT COUNT(*) FROM #ExportTables)=1                               
 BEGIN                    
  IF @IncludeDispositionRecords = 0                    
   BEGIN                              
    SELECT @sql='SELECT distinct * FROM '+Table_Schema+'.'+Table_Name+' ' FROM #ExportTables                              
    --print @sql                    
    EXEC(@sql)                              
    GOTO Cleanup                              
   END                    
  ELSE                    
   BEGIN                    
    SELECT @sql='SELECT distinct VendorDispositionCode VDispCd, VendorDispositionLabel vDisLbl,                   
    VendorDispositionDesc vDispDsc, DispositionDate DispDate, NRCDispositionID dispID, strReportLabel                   
    RptLbl, HCAHPSValue HCAHPSVl,  BV.*                   
    FROM '+Table_Schema+'.'+Table_Name+' BV left outer join vw_FinalHCAHPSVendorDispositionData vdl on bv.SampPop = vdl.Samplepop_ID'                   
    FROM #ExportTables                            
    --print @sql                    
    EXEC(@sql)                              
    GOTO Cleanup                               
   END                    
 END                              
                        
--Now to build a select statement from the newly created tables                               
--Get the unique columns                                  
INSERT INTO #TableColumns (Table_Schema, Table_Name, Column_Name)                                  
SELECT c.Table_Schema, c.Table_Name, c.Column_Name                                  
FROM Information_Schema.Columns c, #ExportTables t                                  
WHERE t.Table_Schema=c.Table_Schema                                  
AND t.Table_Name=c.Table_Name                                  
                                  
CREATE INDEX tmpIndex ON #TableColumns (Table_Schema, Table_Name, Column_Name)                                  
CREATE INDEX tmpIndex2 ON #TableColumns (Column_Name)                                  
                                  
INSERT INTO #Columns (Column_Name, bitQuestion, bitUsed)                                  
SELECT Column_Name, CASE WHEN ISNUMERIC(SUBSTRING(Column_Name,2,6))=1 THEN 1 ELSE 0 END, 0                                  
FROM #TableColumns                                  
GROUP BY Column_Name, CASE WHEN ISNUMERIC(SUBSTRING(Column_Name,2,6))=1 THEN 1 ELSE 0 END                                  
ORDER BY 2,1                                  
                                  
CREATE INDEX tmpIndex3 ON #Columns (Column_Name)                                  
                                  
IF @@ROWCOUNT>1020                                  
BEGIN                                  
                                  
   RAISERROR ('Too many columns in the dataset',18,1)                                  
   GOTO Cleanup                                  
             
END                                  
                                  
UPDATE #ExportTables SET StatementBuilt=0                                  
                                  
--Now to build the select statements one table at a time                                  
SELECT TOP 1 @Table_Schema=Table_Schema, @Table_Name=Table_Name                                  
FROM #ExportTables                                  
WHERE StatementBuilt=0                                  
ORDER BY Table_Schema, Table_Name                                  
                                  
WHILE @@ROWCOUNT>0                                  
BEGIN                                  
                                  
   --Mark the table as being done                                  
   UPDATE #ExportTables                                   
   SET StatementBuilt=1                                  
   WHERE Table_Schema=@Table_Schema                                  
   AND Table_Name=@Table_Name                                 
                                  
   --Reset the tracking column                                  
   UPDATE #Columns SET bitUsed=0                                  
                                  
   --What columns exist                                  
   UPDATE c                                  
   SET bitUsed=1                                  
   FROM #Columns c, #TableColumns tc                                  
   WHERE tc.Table_Schema=@Table_Schema                                  
   AND tc.Table_Name=@Table_Name                                  
   AND tc.Column_Name=c.Column_Name                                  
                   
   if @IncludeDispositionRecords = 0                               
  begin                                  
     --Initialize the variable                                  
     SELECT @sql='SELECT'                                  
        end                    
    else                    
  begin       
   SELECT @sql='SELECT VendorDispositionCode VDispCd, VendorDispositionLabel vDisLbl, VendorDispositionDesc vDispDsc, DispositionDate DispDate, NRCDispositionID dispID, strReportLabel RptLbl, HCAHPSValue HCAHPSVl '                    
  end                    
                      
   --Set to 0 so every record in the #Columns table will get looked at                                  
   SELECT @Column_id=0                                  
                                  
   --Get the first column to work with                                  
   SELECT TOP 1 @Column_id=Column_id                                  
   FROM #Columns                                  
   WHERE Column_id>@Column_id                                  
   ORDER BY Column_id                                  
                                  
   --Loop while we have columns                                  
   WHILE @@ROWCOUNT>0                                  
   BEGIN                                  
                                  
                          
  --Add the column to the select statement                                  
   SELECT @sql=@sql+CASE WHEN @sql='SELECT' THEN ' ' ELSE ',' END+CASE bitUsed WHEN 0 THEN 'NULL ' ELSE '' END+Column_Name                                  
   FROM #Columns                                  
   WHERE Column_id=@Column_id                                  
                     
                                  
      --If the length of the statement exceeds 7900 characters, add the value to the #statements table with bitUnion=0 and reset the @sql variable                                  
      IF LEN(@sql)>7900                                  
      BEGIN                                  
                                  
         INSERT INTO #Statements (Statement, bitUnion)                                  
         SELECT @sql,0                                  
         SELECT @sql=''                                  
                                  
      END                                  
                                  
      --Get the next column                                  
      SELECT TOP 1 @Column_id=Column_id                                  
      FROM #Columns                                  
      WHERE Column_id>@Column_id                                  
      ORDER BY Column_id                                  
                                  
   END                                  
         
   if @IncludeDispositionRecords = 0                               
  begin                    
     --Add on the FROM clause                                  
     SELECT @sql=@sql+' FROM '+@Table_Schema+'.'+@Table_Name+' (NOLOCK) '                                            
  end                    
 else                    
  begin                    
     --Add on the FROM clause                       
     SELECT @sql=@sql+' FROM '+@Table_Schema+'.'+@Table_Name+' bv (NOLOCK) left outer join vw_FinalHCAHPSVendorDispositionData vdl on bv.samppop = vdl.Samplepop_ID '                                            
  end                      
                      
   --Insert @sql into #Statements with bitUnion=1.  I will use the bitUnion column to identify where to place the UNION statement                                  
 INSERT INTO #Statements (Statement, bitUnion)                                  
   SELECT @sql,1                                  
                                  
   --Get the next table                                  
   SELECT TOP 1 @Table_Schema=Table_Schema, @Table_Name=Table_Name                                  
   FROM #ExportTables                                  
   WHERE StatementBuilt=0                                  
   ORDER BY Table_Schema, Table_Name                                  
                                  
END                                  
                                  
--Need add the union statement onto all the statements with bitUnion=1, except for the last one.                                  
UPDATE #Statements                                  
SET Statement=Statement+' UNION '                                 
WHERE bitUnion=1                                  
AND a<(SELECT MAX(a) FROM #Statements)                                  
                                  
--This part of the procedure will build a single statement to execute                                      
DECLARE @sqldeclare VARCHAR(8000), @cnt INT                                      
                                      
--Dynamically declare the needed @sql variables                                      
SET @sqldeclare='DECLARE '                                      
                                      
--build the declare variables string                                      
SELECT @sqldeclare=@sqldeclare+'@sql'+CONVERT(VARCHAR,a)+' VARCHAR(8000),' FROM #Statements                                  
--get rid of the last comma                                      
SELECT @sqldeclare=LEFT(@sqldeclare,LEN(@sqldeclare)-1)                                      
                                      
--add code to give each variable a value                                      
SELECT @sqldeclare=@sqldeclare+' SELECT @sql'+CONVERT(VARCHAR,a)+'=Statement FROM #Statements WHERE a='+CONVERT(VARCHAR,a)                                   
FROM #Statements                                   
ORDER BY a DESC                                      
                                      
--now to start on the execute statements                                      
SELECT @sqldeclare=@sqldeclare + ' EXEC ('                                      
                                      
--Dynamically build the execute statements                                      
SELECT @sqldeclare=@sqldeclare+'@sql'+CONVERT(VARCHAR,a)+'+'                   
FROM #Statements                                   
ORDER BY a                                       
                                  
--get rid of the last "+"                                      
SELECT @sqldeclare=LEFT(@sqldeclare,LEN(@sqldeclare)-1)                                      
                                  
--close the execute statement                                      
SELECT @sqldeclare=@sqldeclare + ')'              
                       
if @indebug = 1                     
 begin                    
  select '#Statements' [#Statements], * from #Statements                    
  print '@sqldeclare'                    
  print @sqldeclare                                 
 end                    
EXEC (@sqldeclare)                                  
                                
Cleanup:                                  
--Get the HCAHPS deleted row count             
if @ReturnData = 1            
BEGIN                               
 SELECT sum(DeletedCount) as DeletedCount                                
 FROM #DeletedHCAHPSRecords                                  
END            
            
if @SaveData = 1            
BEGIN                
            
 Delete from ExportFileDeleteCount where ExportFileGuid = @ExportFileGUID            
             
 INSERT INTO ExportFileDeleteCount (ExportFileGUID, DeletedCount)                          
 SELECT @ExportFileGuid as ExportFileGUID, sum(DeletedCount) as DeletedCount                                
 FROM #DeletedHCAHPSRecords                                  
END            
            
            
if @indebug = 1                    
begin                    
 SELECT @sql=''                                  
 SELECT @sql=@sql+'Select * from '+Table_Schema+'.'+Table_Name+' ' FROM #ExportTables                                  
 EXEC (@sql)                       
end                    
            
            
if @SaveData = 1                    
BEGIN                    
            
 if @ExportSetTypeID = 4            
 BEGIN           
           
   IF exists (select 'x' from information_schema.columns where table_schema = 's'+@study_ID  and table_name = 'Big_table_view' and column_name = 'HHNQL')        
   BEGIN        
  if @indebug = 1 print 'HHNQL field exists'        
  set @HHNQLField = 'HHNQL as HHNQL'        
   END         
   ELSE        
   BEGIN        
  if @indebug = 1 print 'HHNQL field does not exists'        
  set @HHNQLField =  'Null as HHNQL'        
   END        
      
      
   --create copy of #exporttables for loop      
   select * into #tmp_tables from #exporttables      
      
   select top 1 @tmp_tablename = table_name, @tmp_tableschema = table_schema from #tmp_tables      
      
   while (@tmp_tablename is not null)      
   begin      
    --As per recent change, response data may be excluded from resultsets if study results table/view doesn't exist.      
    --Therefore check to see if question data exists, and null it out if not.      
    if exists (select 1 from information_schema.columns where column_name = 'Q038694' and table_schema = @tmp_tableschema and table_name = @tmp_tablename)      
    begin      
     if @IncludeOCSFields = 0            
     BEGIN            
   SELECT @sql=''                                  
   SELECT @SQL='Delete from ExportFileHHCAHPSDetails where ExportFileGuid =''' +CONVERT(VARCHAR(40),@ExportFileGUID) + ''' '            
   SELECT @sql=@sql+'Insert into ExportFileHHCAHPSDetails (            
   ExportFileGUID,SmpEncDt,SampPop,Rtrn_dt,Method,HHCatAge,HHVisCt,HHLBCt,HHAdmHsp,HHAdmRhb,HHAdmSNF,            
     HHAdmLTC,HHAdmOIP,HHAdmCom,HHPayMcr,HHPayMcd,HHPayIns,HHPayOth,HHHMO,HHDual,ICD9,ICD9_2,            
     ICD9_3,ICD9_4,ICD9_5,ICD9_6,HHSurg,HHESRD,HHADLDef,HHADLDUp,HHADLDLo,HHADLBth,HHADLToi,HHADLTrn,            
     HHNQL, HHDispo,Medicare,LangID,Sex,Sampset,Q038694,Q038695,Q038696,Q038697,Q038698,Q038699,Q038700,            
     Q038701,Q038702,Q038703,Q038704,Q038705,Q038706,Q038707,Q038708,Q038709,Q038710,Q038711,Q038712,            
     Q038713,Q038714,Q038715,Q038716,Q038717,Q038718,Q038719,Q038720,Q038721,Q038722,Q038723,            
     Q038724a,Q038724b,Q038724c,Q038724d,Q038724e,Q038725,Q038726,            
     Q038727a,Q038727b,Q038727c,Q038727d,Q038727e,Q038727f            
     )            
     Select ''' + cast(@ExportFileGUID as varchar(100)) + ''' as ExportFileGUID,            
     SmpEncDt,SampPop,Rtrn_dt,Method,HHCatAge,HHVisCt,HHLBCt,HHAdmHsp,HHAdmRhb,HHAdmSNF,            
     HHAdmLTC,HHAdmOIP,HHAdmCom,HHPayMcr,HHPayMcd,HHPayIns,HHPayOth,HHHMO,HHDual,ICD9,ICD9_2,            
     ICD9_3,ICD9_4,ICD9_5,ICD9_6,HHSurg,HHESRD,HHADLDef,HHADLDUp,HHADLDLo,HHADLBth,HHADLToi,HHADLTrn,            
     ' + @HHNQLField + ',HHDispo,Medicare,LangID,Sex,Sampset,Q038694,Q038695,Q038696,Q038697,Q038698,Q038699,Q038700,            
     Q038701,Q038702,Q038703,Q038704,Q038705,Q038706,Q038707,Q038708,Q038709,Q038710,Q038711,Q038712,            
     Q038713,Q038714,Q038715,Q038716,Q038717,Q038718,Q038719,Q038720,Q038721,Q038722,Q038723,            
     Q038724a,Q038724b,Q038724c,Q038724d,Q038724e,Q038725,Q038726,'      
      
     if exists (select 1 from information_schema.columns where column_name = 'Q038727a' and table_schema = @tmp_tableschema and table_name = @tmp_tablename)      
   select @sql=@sql+'Q038727a,Q038727b,Q038727c,Q038727d,Q038727e,Q038727f'      
     else      
   select @sql=@sql+'NULL,NULL,NULL,NULL,NULL,NULL'      
           
     select @sql=@sql+'      
   from '+@tmp_tableschema+'.'+@tmp_tablename+' '      
    END            
    ELSE            
    BEGIN            
   SELECT @sql=''                
   SELECT @SQL='Delete from ExportFileHHCAHPSDetails where ExportFileGuid =''' +CONVERT(VARCHAR(40),@ExportFileGUID) + ''' '            
   SELECT @sql=@sql+'Insert into ExportFileHHCAHPSDetails (            
   ExportFileGUID,SmpEncDt,SampPop,Rtrn_dt,Method,HHCatAge,HHVisCt,HHLBCt,HHAdmHsp,HHAdmRhb,HHAdmSNF,            
     HHAdmLTC,HHAdmOIP,HHAdmCom,HHPayMcr,HHPayMcd,HHPayIns,HHPayOth,HHHMO,HHDual,ICD9,ICD9_2,            
     ICD9_3,ICD9_4,ICD9_5,ICD9_6,HHSurg,HHESRD,HHADLDef,HHADLDUp,HHADLDLo,HHADLBth,HHADLToi,HHADLTrn,            
     HHNQL, HHDispo,Medicare,LangID,Sex,Sampset,HHBrnNum,HHOASPID,HHSOCDT,            
     Q038694,Q038695,Q038696,Q038697,Q038698,Q038699,Q038700,            
     Q038701,Q038702,Q038703,Q038704,Q038705,Q038706,Q038707,Q038708,Q038709,Q038710,Q038711,Q038712,            
     Q038713,Q038714,Q038715,Q038716,Q038717,Q038718,Q038719,Q038720,Q038721,Q038722,Q038723,            
     Q038724a,Q038724b,Q038724c,Q038724d,Q038724e,Q038725,Q038726,            
     Q038727a,Q038727b,Q038727c,Q038727d,Q038727e,Q038727f            
     )            
     Select ''' + cast(@ExportFileGUID as varchar(100)) + ''' as ExportFileGUID,            
     SmpEncDt,SampPop,Rtrn_dt,Method,HHCatAge,HHVisCt,HHLBCt,HHAdmHsp,HHAdmRhb,HHAdmSNF,            
     HHAdmLTC,HHAdmOIP,HHAdmCom,HHPayMcr,HHPayMcd,HHPayIns,HHPayOth,HHHMO,HHDual,ICD9,ICD9_2,            
     ICD9_3,ICD9_4,ICD9_5,ICD9_6,HHSurg,HHESRD,HHADLDef,HHADLDUp,HHADLDLo,HHADLBth,HHADLToi,HHADLTrn,            
     ' + @HHNQLField + ',HHDispo,Medicare,LangID,Sex,Sampset,HHBrnNum,HHOASPID,HHSOCDT,            
     Q038694,Q038695,Q038696,Q038697,Q038698,Q038699,Q038700,            
     Q038701,Q038702,Q038703,Q038704,Q038705,Q038706,Q038707,Q038708,Q038709,Q038710,Q038711,Q038712,            
     Q038713,Q038714,Q038715,Q038716,Q038717,Q038718,Q038719,Q038720,Q038721,Q038722,Q038723,            
     Q038724a,Q038724b,Q038724c,Q038724d,Q038724e,Q038725,Q038726,'      
      
     if exists (select 1 from information_schema.columns where column_name = 'Q038727a' and table_schema = @tmp_tableschema and table_name = @tmp_tablename)      
   select @sql=@sql+'Q038727a,Q038727b,Q038727c,Q038727d,Q038727e,Q038727f'      
     else      
   select @sql=@sql+'NULL,NULL,NULL,NULL,NULL,NULL'      
           
     select @sql=@sql+'      
   from '+@tmp_tableschema+'.'+@tmp_tablename+' '      
    END            
    end      
    else --study results don't exist      
    begin      
     if @IncludeOCSFields = 0            
     BEGIN            
   SELECT @sql=''                                  
   SELECT @SQL='Delete from ExportFileHHCAHPSDetails where ExportFileGuid =''' +CONVERT(VARCHAR(40),@ExportFileGUID) + ''' '            
   SELECT @sql=@sql+'Insert into ExportFileHHCAHPSDetails (            
   ExportFileGUID,SmpEncDt,SampPop,Rtrn_dt,Method,HHCatAge,HHVisCt,HHLBCt,HHAdmHsp,HHAdmRhb,HHAdmSNF,            
     HHAdmLTC,HHAdmOIP,HHAdmCom,HHPayMcr,HHPayMcd,HHPayIns,HHPayOth,HHHMO,HHDual,ICD9,ICD9_2,            
    ICD9_3,ICD9_4,ICD9_5,ICD9_6,HHSurg,HHESRD,HHADLDef,HHADLDUp,HHADLDLo,HHADLBth,HHADLToi,HHADLTrn,            
     HHNQL, HHDispo,Medicare,LangID,Sex,Sampset,Q038694,Q038695,Q038696,Q038697,Q038698,Q038699,Q038700,            
     Q038701,Q038702,Q038703,Q038704,Q038705,Q038706,Q038707,Q038708,Q038709,Q038710,Q038711,Q038712,            
     Q038713,Q038714,Q038715,Q038716,Q038717,Q038718,Q038719,Q038720,Q038721,Q038722,Q038723,            
     Q038724a,Q038724b,Q038724c,Q038724d,Q038724e,Q038725,Q038726,            
     Q038727a,Q038727b,Q038727c,Q038727d,Q038727e,Q038727f            
     )            
     Select ''' + cast(@ExportFileGUID as varchar(100)) + ''' as ExportFileGUID,            
     SmpEncDt,SampPop,Rtrn_dt,Method,HHCatAge,HHVisCt,HHLBCt,HHAdmHsp,HHAdmRhb,HHAdmSNF,            
     HHAdmLTC,HHAdmOIP,HHAdmCom,HHPayMcr,HHPayMcd,HHPayIns,HHPayOth,HHHMO,HHDual,ICD9,ICD9_2,            
     ICD9_3,ICD9_4,ICD9_5,ICD9_6,HHSurg,HHESRD,HHADLDef,HHADLDUp,HHADLDLo,HHADLBth,HHADLToi,HHADLTrn,            
     ' + @HHNQLField + ',HHDispo,Medicare,LangID,Sex,Sampset,NULL,NULL,NULL,NULL,NULL,NULL,NULL,            
     NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,            
     NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,            
     NULL,NULL,NULL,NULL,NULL,NULL,NULL,            
     NULL,NULL,NULL,NULL,NULL,NULL            
     from '+@tmp_tableschema+'.'+@tmp_tablename+' '      
    END            
    ELSE            
    BEGIN            
   SELECT @sql=''                
   SELECT @SQL='Delete from ExportFileHHCAHPSDetails where ExportFileGuid =''' +CONVERT(VARCHAR(40),@ExportFileGUID) + ''' '            
   SELECT @sql=@sql+'Insert into ExportFileHHCAHPSDetails (            
   ExportFileGUID,SmpEncDt,SampPop,Rtrn_dt,Method,HHCatAge,HHVisCt,HHLBCt,HHAdmHsp,HHAdmRhb,HHAdmSNF,            
     HHAdmLTC,HHAdmOIP,HHAdmCom,HHPayMcr,HHPayMcd,HHPayIns,HHPayOth,HHHMO,HHDual,ICD9,ICD9_2,            
     ICD9_3,ICD9_4,ICD9_5,ICD9_6,HHSurg,HHESRD,HHADLDef,HHADLDUp,HHADLDLo,HHADLBth,HHADLToi,HHADLTrn,            
     HHNQL, HHDispo,Medicare,LangID,Sex,Sampset,HHBrnNum,HHOASPID,HHSOCDT,            
     Q038694,Q038695,Q038696,Q038697,Q038698,Q038699,Q038700,            
     Q038701,Q038702,Q038703,Q038704,Q038705,Q038706,Q038707,Q038708,Q038709,Q038710,Q038711,Q038712,            
     Q038713,Q038714,Q038715,Q038716,Q038717,Q038718,Q038719,Q038720,Q038721,Q038722,Q038723,            
     Q038724a,Q038724b,Q038724c,Q038724d,Q038724e,Q038725,Q038726,            
     Q038727a,Q038727b,Q038727c,Q038727d,Q038727e,Q038727f            
     )            
     Select ''' + cast(@ExportFileGUID as varchar(100)) + ''' as ExportFileGUID,            
     SmpEncDt,SampPop,Rtrn_dt,Method,HHCatAge,HHVisCt,HHLBCt,HHAdmHsp,HHAdmRhb,HHAdmSNF,            
     HHAdmLTC,HHAdmOIP,HHAdmCom,HHPayMcr,HHPayMcd,HHPayIns,HHPayOth,HHHMO,HHDual,ICD9,ICD9_2,            
     ICD9_3,ICD9_4,ICD9_5,ICD9_6,HHSurg,HHESRD,HHADLDef,HHADLDUp,HHADLDLo,HHADLBth,HHADLToi,HHADLTrn,            
     ' + @HHNQLField + ',HHDispo,Medicare,LangID,Sex,Sampset,HHBrnNum,HHOASPID,HHSOCDT,            
     NULL,NULL,NULL,NULL,NULL,NULL,NULL,            
     NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,            
     NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,            
     NULL,NULL,NULL,NULL,NULL,NULL,NULL,            
     NULL,NULL,NULL,NULL,NULL,NULL            
     from '+@tmp_tableschema+'.'+@tmp_tablename+' '      
    END            
    end  --Q038694 exists      
      
    delete #tmp_tables where table_name = @tmp_tablename       
    select @tmp_tablename = null      
       select top 1 @tmp_tablename = table_name, @tmp_tableschema = table_schema from #tmp_tables      
      
 end --while      
      
    if @indebug = 1 print @sql            
    EXEC (@sql)                       
   END --@ExportSetTypeID =1            
END --@saveData = 1              
                                 
--Get rid of the permanent tables                 
SELECT @sql=''                                  
SELECT @sql=@sql+'DROP TABLE '+Table_Schema+'.'+Table_Name+' ' FROM #ExportTables                                  
EXEC (@sql)                    
                                  
--Now the temp tables                                  
IF OBJECT_ID('tempdb..#ExportSets2') IS NOT NULL DROP TABLE #ExportSets2                                  
IF OBJECT_ID('tempdb..#ExportTables') IS NOT NULL DROP TABLE #ExportTables                                  
IF OBJECT_ID('tempdb..#samplesets') IS NOT NULL Drop table #samplesets                 
IF OBJECT_ID('tempdb..#SampleSetResults') IS NOT NULL Drop table #SampleSetResults                 
IF OBJECT_ID('tempdb..#HHsamplesets') IS NOT NULL Drop table #HHsamplesets                 
IF OBJECT_ID('tempdb..#HHSampleSetResults') IS NOT NULL Drop table #HHSampleSetResults                 
                                  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                                  
SET NOCOUNT OFF                                  
                                
                                
                                
--------------------

GO