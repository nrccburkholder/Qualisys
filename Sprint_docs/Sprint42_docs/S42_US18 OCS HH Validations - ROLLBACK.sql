/*

Sprint 42 User Story 18: OCS HH Validations.

Brendan Goble

ROLLBACK

*/

use QP_DataLoad
go

delete from Validation_Definitions where Field_nm in ('MRN', 'HHOASISPatID');
go

if exists (select * from sys.procedures where name = 'LD_RunValidation' and schema_id = SCHEMA_ID('dbo'))
	drop procedure dbo.LD_RunValidation;
go
CREATE PROCEDURE [dbo].[LD_RunValidation]                    
 @File_id INT, @indebug int = 0                    
AS                    
    
    
/*** History ***/
--08/31/2010, dmp, Added warning for records that have both HHPay_Mcare & HHPay_Mcaid missing
--03/08/2011, dmp, Changed threshold for combined medicare/medicaid payers from 5 to 10
--03/17/2011, dmp, Added message for count of combined medicare/medicaid payers when over threshold
--05/14/2013, DRM, Changed threshold for combined medicare/medicaid payers from 10 to 30
--06/10/2014, CAA/DRH, INC0032381 added WITH(ROWLOCK) hint to DELETE Validation_Counts statement to prevent deadlock contention
/***************/        
/*            
Test Code            
select * From datafile            
LD_RunValidation 173, 1            
            
*/            
            
if @indebug = 1 print 'Start QP_DataLoading LD_RunValidation'            
            
--Deletes are done here in case the validation (post Pervasive) process is restarted            
--all prior records need to be cleaned out.            
delete from DataFileLoadMsg where DataFile_ID = @File_id   

--06/10/2014, CAA/DRH, INC0032381 added WITH(ROWLOCK) hint to DELETE Validation_Counts statement to prevent deadlock contention
--delete from Validation_Counts where DataFile_ID = @File_id            
delete from Validation_Counts WITH (ROWLOCK) where DataFile_ID = @File_id            

delete from MatchFieldValidation where DataFile_ID = @File_id            
                    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                    
                    
SET NOCOUNT ON                    
                    
DECLARE @sql VARCHAR(8000), @Study_id INT               
DECLARE @TableName VARCHAR(60), @FieldName VARCHAR(42), @strLoadingDest VARCHAR(200)                    
DECLARE @Table_id INT, @LowLimit INT             
            
Declare @survey_ID int, @client_ID int, @RecordCount int, @surveyType_ID int, @CheckForValue varchar(100)              
                  
--variables used in validation warning message process                  
declare @DRGFieldID int, @MSDRGFieldID int, @Sex int, @HServiceType int                  
declare @maxDRGinFile varchar(5), @MaxDRGinTable varchar(5)                  
            
DECLARE @CurrID int, @CurrMin datetime, @CurrMax datetime            
DECLARE @PrevID int, @PrevMin datetime, @PrevMax datetime        
        
/*****************************************************************/        
--new variable for Medicare/Medicaid combined null warning        
declare @PayerNullCount int            
/*****************************************************************/        
            
Create table #dataFiles (id int identity (1,1), datafile_ID int, MinDate datetime, MaxDate datetime)            
            
            
--get validation threshold data            
Select @survey_ID = survey_ID,             
  @Study_id = study_ID,             
  @client_ID = Client_ID,             
  @RecordCount = df.intRecords            
from DataFile df where DataFile_id = @File_id            
            
if @indebug = 1            
begin            
 print '@client_ID = ' + cast(@client_ID as varchar(10))            
 print '@Study_id = ' + cast(@Study_id as varchar(10))            
 print '@survey_ID = ' + cast(@survey_ID as varchar(10))            
 print '@RecordCount = ' + cast(@RecordCount as varchar(10))            
end            
        
if @RecordCount = 0        
begin        
 insert into DataFileLoadMsg (DataFile_ID, ErrorLevel_ID, ErrorMessage)  select @File_id, 3, '0 Records loaded from file.'                  
end        
                    
SELECT @strLoadingDest=strParam_Value FROM Loading_Params WHERE strParam_nm='Loading Destination'                    
            
if @indebug = 1 print '@strLoadingDest = ' + cast(@strLoadingDest as varchar(100))             
                    
--SELECT @Package_id=p.Package_id, @Version=p.intVersion, @Study_id=Study_id                    
--FROM DataFile df, Package_View p                    
--WHERE df.DataFile_id=@File_id                    
--AND df.Package_id=p.Package_id                    
--AND df.intversion=p.intVersion                    
                    
--Get the table and field names                    
CREATE TABLE #MetaData (                 
 Table_id   INT,                    
 strTable_nm  VARCHAR(42),                    
 Field_id   INT,                    
 strField_nm  VARCHAR(42),                    
 bitMatchField_flg  BIT,                    
 DataType_id   INT,                    
 intLength    INT,                    
 bitPII    BIT,                    
 bitAllowUS   BIT                    
)                    
                    
SET @sql='INSERT INTO #MetaData                    
EXEC '+@strLoadingDest+'SP_SYS_DestinationFields '+LTRIM(STR(@Study_id))                    
if @indebug = 1 print @sql            
EXEC (@sql)                    
            
if @indebug = 1 select '#MetaData' [#MetaData], * from #MetaData                  
                  
--Need to make sure all lookup tables are deduped.Otherwise                    
-- the presample counts will be inaccurate.                    
--Find the lookup tables that may need to be deduped                    
SELECT DISTINCT strTable_nm+'_load' Table_Name, strField_nm Field_Name                    
INTO #deduptbls                    
FROM #MetaData                    
WHERE strTable_nm NOT IN ('Population','Encounter')                    
AND bitMatchField_flg=1                    
            
if @indebug = 1 select '#deduptbls' [#deduptbls], * from #deduptbls                  
                    
--Get all of the columns in the lookup tables.We need to determine the Identity column                    
SELECT DISTINCT c.Table_Schema+'.'+c.Table_Name Table_Name, c.Column_Name Field_Name                    
INTO #work                    
FROM Information_Schema.Columns c, #deduptbls d                    
WHERE c.Table_Schema='S'+LTRIM(STR(@Study_id))                    
AND c.Table_Name=d.Table_Name                    
            
if @indebug = 1 select '#work' [#work], * from #work                  
                    
--Temp table to hold the identity column for each lookup table.                    
CREATE TABLE #Identity (Table_Name VARCHAR(60), Field_Name VARCHAR(42))                    
                    
--Loop thru the fields until we find the identity column.                    
SELECT TOP 1 @TableName=Table_Name, @FieldName=Field_Name FROM #work                    
WHILE @@ROWCOUNT>0                    
BEGIN                    
                    
 --Build and executer the statement to check for the identity property.                    
 --If we find the identity column, we delete all remaining columns for the given table.                    
 SELECT @sql='IF (SELECT COLUMNPROPERTY( OBJECT_ID('''+@TableName+'''),'''+@FieldName+''',''IsIdentity''))=1                    
  BEGIN                    
 INSERT INTO #Identity SELECT '''+@TableName+''','''+@FieldName+'''                    
 DELETE #work WHERE Table_name='''+@TableName+'''                    
  END'              
                  
 if @indebug = 1 print @sql                
 EXEC (@sql)                    
                     
 --Delete the current working record                    
 DELETE #work WHERE Table_Name=@TableName AND Field_Name=@FieldName                    
                     
 --Get the next record to check                    
 SELECT TOP 1 @TableName=Table_Name, @FieldName=Field_Name FROM #work                    
                    
END                    
                    
DECLARE @sqlgroup VARCHAR(2000)                    
            
if @indebug = 1 select '#deduptbls' [#deduptbls], * from #deduptbls            
                    
--Now to actually do the dedup                    
SELECT TOP 1 @TableName=Table_Name FROM #deduptbls                    
WHILE @@ROWCOUNT>0                    
BEGIN                    
                     
 SELECT @sqlgroup=''                    
                     
 --Build the list of match field(s)                  
 SELECT @sqlgroup=@sqlgroup+Field_Name+','                 
 FROM #deduptbls                    
 WHERE Table_Name=@TableName                    
                     
 --Build and execute the dedup query.                    
 SELECT @sql='DELETE a                    
  FROM S'+LTRIM(STR(@Study_id))+'.'+@TableName+' a                     
 LEFT OUTER JOIN                     
  (SELECT '+@sqlgroup+'MAX('+Field_Name+') '+Field_Name+'                     
 FROM S'+LTRIM(STR(@Study_id))+'.'+@TableName+'                     
 GROUP BY '+SUBSTRING(@sqlgroup,1,(LEN(@sqlgroup)-1))+') b                    
  ON a.'+Field_Name+'=b.'+Field_Name+'                    
  WHERE b.'+Field_Name+' IS NULL'                    
 FROM #Identity                    
 WHERE Table_Name='S'+LTRIM(STR(@Study_id))+'.'+@TableName                    
             
 if @indebug = 1 print @sql                    
 EXEC (@sql)                     
                     
 DELETE #deduptbls WHERE Table_Name=@TableName                    
                     
 SELECT TOP 1 @TableName=Table_Name FROM #deduptbls                    
                    
END                    
                  
DROP TABLE #work                    
DROP TABLE #deduptbls                    
DROP TABLE #Identity                    
                    
--First to work on the NULL counts              
            
Select @surveyType_ID = surveytype_ID from Survey_Def where SURVEY_ID = @survey_ID            
        
/***************************************************************/        
/* Added 08/31/2010 dmp        
 Warning for records that have both HHPay_Mcare & HHPay_Mcaid missing */        
        
If @surveyType_ID = 3    --HHCAHPS survey        
begin        
 declare @totalrows int    
 --check for fields in data structure        
 select @totalrows = count(*) from INFORMATION_SCHEMA.COLUMNS        
 where TABLE_NAME = 'encounter_load'        
 and TABLE_SCHEMA = 's' + CAST(@Study_id as varchar(10))        
 and COLUMN_NAME in ('HHPay_Mcare', 'HHPay_Mcaid')        
  
 create table #dmp_tmp (total int)  
         
 if @totalrows < 2        
  insert into DataFileLoadMsg (DataFile_ID, ErrorLevel_ID, ErrorMessage)  select @File_id, 3, 'Payer fields do not exist.'        
 else        
 begin        
  set @sql = 
  'insert into #dmp_tmp select COUNT(*) as total 
  from s' + LTRIM(STR(@Study_id)) + '.encounter_load 
  where HHPay_Mcare = ''M'' 
  and HHPay_Mcaid = ''M''
  and DataFile_id = ' + LTRIM(STR(@File_id))        
  if @indebug = 1 print @sql        
      
  exec(@sql)        
  select @PayerNullCount = total from #dmp_tmp      
      
  if @indebug = 1        
  begin        
   print @PayerNullCount        
   print @RecordCount        
  end        
      
--  select ROUND(((@PayerNullCount * 1.0) / @RecordCount),2) * 100        
  if (@RecordCount > 0)
	-- Changed threshold from 5 to 10, 03/08/2011, dmp
	-- Changed threshold from 10 to 30, 05/14/2013, DRM
	if (((@PayerNullCount * 1.0) / @RecordCount) * 100  >= 30)      
	  insert into DataFileLoadMsg (DataFile_ID, ErrorLevel_ID, ErrorMessage)  select @File_id, 3, 'More than 30 percent missing Medicare/Medicaid.'        
	  --added count of records with both missing, 03/17/2011, dmp
	if (((@PayerNullCount * 1.0) / @RecordCount) * 100  >= 30)      
	  insert into DataFileLoadMsg (DataFile_ID, ErrorLevel_ID, ErrorMessage)  select @File_id, 3, 'Count of missing Medicare/Medicaid: ' + LTRIM(STR(@PayerNullCount))
  drop table #dmp_tmp      
 end        
end        

      
/*************************************************************/        
            
Select nvd.Table_nm as strTable_nm, nvd.Field_nm as strField_nm, nvd.CheckForValue as CheckForValue            
 into #NULL_temp            
 from Validation_Definitions nvd            
 where (Client_ID = @client_ID or Client_ID is Null) and            
   (study_ID = @Study_id or study_ID is Null) and            
   (survey_ID = @survey_ID or survey_ID is Null) and      
   (surveytype_ID = @surveyType_ID or surveytype_ID is Null)            
            
if @indebug = 1 select '#NULL_temp' [#NULL_temp], * from #NULL_temp                  
            
Select  n.strTable_nm, n.strField_nm, n.CheckForValue            
into #null            
from INFORMATION_SCHEMA.COLUMNS c, #NULL_temp n            
where n.strtable_nm + '_Load' = c.TABLE_NAME and            
  c.TABLE_SCHEMA = 's' + CAST(@Study_id as varchar(10)) and            
  c.COLUMN_NAME = n.strfield_nm            
              
            
if @indebug = 1 select '#NULL' [#NULL], * from #NULL                 
                  
--Now to loop thru the fields                    
SELECT TOP 1 @TableName=strTable_nm,             
    @FieldName=strField_nm,             
    @CheckForValue = CheckForValue                    
FROM #NULL                    
ORDER BY strTable_nm,strField_nm                    
                    
WHILE @@ROWCOUNT>0                   
BEGIN                    
            
if @indebug = 1 print '@TableName= ' + isnull(cast(@TableName as varchar(100)), '')            
if @indebug = 1 print '@FieldName= ' + isnull(cast(@FieldName as varchar(100)), '')            
if @indebug = 1 print '@CheckForValue= ' + isnull(cast(@CheckForValue as varchar(100)), '')            
                    
 SET @sql='INSERT INTO Validation_Counts (DataFile_id,strTable_nm,strField_nm,Occurrences)           SELECT '+LTRIM(STR(@File_id))+','''+@TableName+''','''+@FieldName+''', COUNT(*)                    
 FROM S'+LTRIM(STR(@Study_id))+'.'+@TableName+'_Load                    
 WHERE DataFile_id='+LTRIM(STR(@File_id))            
             
 if @CheckForValue is null      
 SET @sql= @sql + ' AND '+@FieldName+' IS NULL'                    
 else            
 SET @sql= @sql + ' AND '+@FieldName+ ' = ''' + @CheckForValue + ''''            
             
 if @indebug = 1 print @sql             
 EXEC (@sql)                    
                     
 DELETE #NULL WHERE strTable_nm=@TableName AND strField_nm=@FieldName                    
                     
SELECT TOP 1 @TableName=strTable_nm,             
    @FieldName=strField_nm,             
    @CheckForValue = CheckForValue                    
FROM #NULL                    
ORDER BY strTable_nm,strField_nm                    
          
END                    
            
if @RecordCount > 0            
BEGIN            
 --Get threshold Counts            
 Select nvd.Field_nm, nvd.FailureThresholdPct, nvd.CheckForValue             
 into #NullThresholds            
 from Validation_Definitions nvd            
 where (Client_ID = @client_ID or Client_ID is Null) and            
   (study_ID = @Study_id or study_ID is Null) and            
   (survey_ID = @survey_ID or survey_ID is Null) and            
   (surveytype_ID = @surveyType_ID or surveytype_ID is Null)            
            
 if @indebug = 1 select '#NullThresholds' [#NullThresholds], * from #NullThresholds                 
            
 --update raw numbers in count table            
 update VRN            
 set  vrn.threshold = t.FailureThresholdPct,            
   vrn.checkForValue = t.checkforvalue,            
   vrn.PctOfTotalNull = round(((occurrences * 1.0) / @RecordCount), 2) * 100            
 from Validation_Counts vrn, #NullThresholds t            
 where vrn.strField_nm = t.field_nm            
            
 --create error message detail line            
 insert into DataFileLoadMsg (DataFile_ID, ErrorLevel_ID, ErrorMessage)            
 Select @File_id, 3, vc.strField_nm + ' Field in the ' + vc.strTable_nm + ' table exceeds Null count Threshold.  Please check data file details.' as Message                
 from Validation_Counts vc            
 where vc.DataFile_id = @File_id and            
   vc.PctOfTotalNull >= (vc.Threshold)             
   and vc.PctOfTotalNull <> 0            
            
END            
           
--Match Field Validation            
            
            
--Population Match field validation                
Create table #PopMtch (FromIdenitier varchar(50), Pop_mtch varchar(100), Pop_mtch_Val varchar(100), Counts int)            
Create table #PopMtchDups ( Pop_mtch varchar(100), counts int)            
set @sql = 'INSERT INTO #PopMtch ' +             
' Select ''DataFile'', pop_mtch, Pop_mtch_Val, Count(*) ' +            
' from S'+LTRIM(STR(@Study_id))+'.population_Load WHERE DataFile_id = '+ cast(@File_id as varchar(15)) +            
' group by pop_mtch, Pop_mtch_Val'             
--if needed            
--set @sql = @sql + 'INSERT INTO #PopMtch ' +             
--' Select ''POPULATION TABLE'', pop_mtch, Pop_mtch_Val, count(*) ' +            
--' from Qualisys.QP_Prod.S'+LTRIM(STR(@Study_id))+'.population' +            
--' group by pop_mtch, Pop_mtch_Val'            
            
 if @indebug = 1 print @sql             
 EXEC (@sql)                    
            
            
insert into #PopMtchDups            
Select pop_mtch, COUNT(*)            
from #PopMtch            
group by pop_mtch            
having COUNT(*) > 1            
            
if @indebug = 1 select '#PopMtchDups' [#PopMtchDups], * from #PopMtchDups            
            
Insert into MatchFieldValidation (DataFile_ID, table_nm, p.Mtch, p.Mtch_Val)            
Select @File_id, 'POPULATION', p.pop_mtch, p.pop_mtch_val            
from #PopMtch p, #PopMtchDups pd            
where p.Pop_mtch = pd.pop_mtch            
            
if @indebug = 1              
begin            
 Select @File_id, 'POPULATION', p.pop_mtch, p.pop_mtch_val            
 from #PopMtch p, #PopMtchDups pd            
 where p.Pop_mtch = pd.pop_mtch            
end            
            
--Encounter Match field validation                
Create table #EncMtch (FromIdenitier varchar(50), Enc_mtch varchar(100), Enc_mtch_Val varchar(100), Counts int)            
Create table #EncMtchDups ( Enc_mtch varchar(100), counts int)            
set @sql = 'INSERT INTO #EncMtch ' +             
' Select ''DataFile'', Enc_mtch, Enc_mtch_Val, Count(*) ' +            
' from S'+LTRIM(STR(@Study_id))+'.Encounter_Load WHERE DataFile_id = '+ cast(@File_id as varchar(15)) +            
' group by Enc_mtch, Enc_mtch_Val'             
--if needed            
--set @sql = @sql + 'INSERT INTO #EncMtch ' +             
--' Select ''Encounter TABLE'', Enc_mtch, Enc_mtch_Val, count(*) ' +            
--' from Qualisys.QP_Prod.S'+LTRIM(STR(@Study_id))+'.Encounter' +            
--' group by Enc_mtch, Enc_mtch_Val'            
            
 if @indebug = 1 print @sql             
 EXEC (@sql)                    
            
            
insert into #EncMtchDups            
Select Enc_mtch, COUNT(*)            
from #EncMtch            
group by Enc_mtch            
having COUNT(*) > 1            
            
if @indebug = 1 select '#EncMtchDups' [#EncMtchDups], * from #EncMtchDups            
            
Insert into MatchFieldValidation (DataFile_ID, table_nm, e.Mtch, e.Mtch_Val)            
Select @File_id, 'Encounter', e.Enc_mtch, e.Enc_mtch_val            
from #EncMtch e, #EncMtchDups pd            
where e.Enc_mtch = pd.Enc_mtch            
            
if @indebug = 1              
begin            
 Select @File_id, 'Encounter', e.Enc_mtch, e.Enc_mtch_val            
 from #EncMtch e, #EncMtchDups pd            
 where e.Enc_mtch = pd.Enc_mtch            
end            
          
          
if (select COUNT(*) from MatchFieldValidation where DataFile_ID = @File_id and Table_nm = 'Population') > 0          
begin          
 insert into DataFileLoadMsg (DataFile_ID, ErrorLevel_ID, ErrorMessage)  select @File_id, 3, 'Error in Population table Match Field Validation.  See details below.'                  
end            
          
if (select COUNT(*) from MatchFieldValidation where DataFile_ID = @File_id and Table_nm = 'Encounter') > 0          
begin          
 insert into DataFileLoadMsg (DataFile_ID, ErrorLevel_ID, ErrorMessage)  select @File_id, 3, 'Error in Encounter table Match Field Validation.  See details below.'                  
end            
                    
----If we are not loading into the Pop table, we will skip the presample                    
--IF (SELECT COUNT(*)                     
--  FROM #MetaData t, PackageTable_View pt                     
--  WHERE t.strTable_nm LIKE 'Population%'                     
--  AND t.Table_id=pt.Table_id                     
--  AND pt.Package_id=@Package_id                     
--  AND pt.intVersion=@Version)>0                    
--EXEC LD_PersistantAssignment @File_id                    
                    
DROP TABLE #MetaData                    
DROP TABLE #NULL                    
                       
                  
                    
--Check the data file for a DRG code greater then the max value in the DRG master table (HCAHPSIP)                  
--This could happen if MSDRG is mapped to DRG field.                  
                  
--First checks if DRG is even in the current package (Field_ID 18 is DRG field from MetaField                  
if exists (select 'x' from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'S' + CAST(@study_ID as varchar(10)) and TABLE_NAME = 'Encounter_Load' and COLUMN_NAME = 'DRG' )                  
 begin                  
  create table #compare (maxDRG  varchar(5), MaxDRGTable  varchar(5))                    set @sql = 'Insert into #compare select max(cast(isnull(DRG,0) as int)) , (Select max(cast(DRG as int)) from hcahpsip) from S'+LTRIM(STR(@Study_id))+'.Encounter_Load
 
where DataFile_ID = ' + cast(@File_ID as varchar(10))                 
              
  if @indebug = 1 print @sql            
  exec (@sql)                  
                  
                  
  Select @maxDRGinFile=isnull(MaxDRG,0), @MaxDRGinTable=MaxDRGTable from #compare                  
  if cast(@maxDRGinFile as int) > cast(@MaxDRGinTable as int)                  
   begin                   
    insert into DataFileLoadMsg (DataFile_ID, ErrorLevel_ID, ErrorMessage)  select @File_id, 3, 'DRG field contains data with values greater than ' + @MaxDRGinTable + '.  Please check DRG mapping.'                  
   end         
  Drop table #compare                  
 end                  
                  
                  
--Next check for HserviceType (Field_ID 1206) and Sex (Field_ID 14)                   
--if found we want to make sure there is no records with a Sex of 'M' and HServicetype of 1                  
--this would be men having babies (or OBGYN classified visits)                  
if exists (select 'x' from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'S' + CAST(@study_ID as varchar(10)) and TABLE_NAME = 'Encounter_Load' and COLUMN_NAME = 'HServiceType')                   
 begin                   
  if exists (select 'x' from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'S' + CAST(@study_ID as varchar(10)) and TABLE_NAME = 'Population_Load' and COLUMN_NAME = 'Sex')            
   begin                  
    create table #ManBabies (HServiceType varchar(10), Sex varchar(6))                  
    set @sql = 'Insert into #ManBabies Select EL.HserviceType, PL.Sex from S'+LTRIM(STR(@Study_id))+'.Encounter_Load EL, S'+LTRIM(STR(@Study_id))+'.Population_Load PL where EL.Pop_ID = PL.Pop_ID and EL.DataFile_ID = ' + cast(@File_ID as varchar(10)) + '  

 
     
     
        
          
and EL.Hservicetype = ''1'' and PL.Sex = ''M'''                  
    if @indebug = 1 print @sql                
    EXEC (@sql)                  
                      
    IF OBJECT_ID('tempdb..#ManBabies') IS NOT NULL                   
     begin                  
                        
      --now just checking if any records come back                  
      if exists(select 'x' from #ManBabies)                  
       begin                  
        insert into DataFileLoadMsg (DataFile_ID, ErrorLevel_ID, ErrorMessage)  select @File_id, 3, 'Loaded files contain an HServiceType of 1 and a Sex code of M.'                  
       end                  
                  
      drop table #ManBabies                            
     end                  
                      
   end                
 end                    
            
insert into #dataFiles (datafile_ID, MinDate, MaxDate)            
select df.Datafile_ID, df.datMinDate, df.datMaxDate             
from DataFile df            
where Survey_ID = @survey_ID             
order by datafile_ID            
            
Select @currID = ID,  @currMin = df.MinDate, @currMax = df.MaxDate            
from #dataFiles df            
where datafile_ID = @File_id            
            
Select @PrevID = ID,  @PrevMin = df.MinDate, @PrevMax = df.MaxDate            
from #dataFiles df            
where id = @currID - 1            
            
if @currMin is not null and            
 @PrevMax is not null and            
 @CurrMax is not null             
 BEGIN             
  if @currMin <= DATEADD(d,1,@PrevMax) and @CurrMax > @PrevMax            
  BEGIN            
   --error here            
   insert into DataFileLoadMsg (DataFile_ID, ErrorLevel_ID, ErrorMessage)  select @File_id, 3, 'Min Max Encounter Date problems.'                  
  END            
 END            
--ELSE            
-- BEGIN            
--  --dates are not populated.  Error here?            
-- END            
            
            
drop table #PopMtch             
drop table #PopMtchDups            
drop table #EncMtch            
drop table #EncMtchDups            
            
drop table #dataFiles            
                     
SET NOCOUNT OFF                    
              
if @indebug = 1 print 'END QP_DataLoading LD_RunValidation'              
              
            
if (select COUNT(*) from DataFileLoadMsg where ErrorLevel_ID > 2 and datafile_ID = @File_id) > 0            
Select 0            
else            
Select 1 
go