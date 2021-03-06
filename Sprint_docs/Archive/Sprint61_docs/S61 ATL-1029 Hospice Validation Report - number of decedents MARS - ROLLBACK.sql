/*

	ROLLBACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	S61 ATL-1029 Hospice Validation Report - number of decedents

	As a Data Management Specialist, I would like to see a red warning appear at the top of the Validation Report in the case of the following two scenarios – 
		1.	Error – Incorrect data for number of decedents – check number of decedents and number of No Publicity patients.
		2.	This error would be populated when the number of records loaded in the file + HSP_NumNoPub does not equal the value populated for HSP_NumDecd.

	Tim Butler

	ALTER PROCEDURE [dbo].[LD_RunValidation]  


*/


USE [QP_Load]
GO
/****** Object:  StoredProcedure [dbo].[LD_RunValidation]    Script Date: 10/28/2016 10:14:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[LD_RunValidation]      
 @File_id INT      
AS      
      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
      
SET NOCOUNT ON      
      
DECLARE @sql VARCHAR(8000), @Study_id INT, @Package_id INT, @Version INT      
DECLARE @TableName VARCHAR(60), @FieldName VARCHAR(42), @strLoadingDest VARCHAR(200)      
DECLARE @Table_id INT, @Field_id INT, @LowLimit INT      
    
--variables used in validation warning message process    
declare @DRGFieldID int, @MSDRGFieldID int, @Sex int, @HServiceType int    
declare @maxDRGinFile varchar(5), @MaxDRGinTable varchar(5)    
    
select @DRGFieldID =Field_ID from qualisys.qp_Prod.dbo.metafield where strField_nm = 'DRG'    
select @MSDRGFieldID =Field_ID from qualisys.qp_Prod.dbo.metafield where strField_nm = 'MSDRG'    
select @Sex =Field_ID from qualisys.qp_Prod.dbo.metafield where strField_nm = 'Sex'    
select @HServiceType =Field_ID from qualisys.qp_Prod.dbo.metafield where strField_nm = 'HServiceType'    
    
    
      
SELECT @strLoadingDest=strParam_Value FROM Loading_Params WHERE strParam_nm='Loading Destination'      
      
SELECT @Package_id=p.Package_id, @Version=p.intVersion, @Study_id=Study_id      
FROM DataFile df, Package_View p      
WHERE df.DataFile_id=@File_id      
AND df.Package_id=p.Package_id      
AND df.intversion=p.intVersion      
      
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
EXEC (@sql)      
    
    
--Need to make sure all lookup tables are deduped.Otherwise      
-- the presample counts will be inaccurate.      
--Find the lookup tables that may need to be deduped      
SELECT DISTINCT strTable_nm+'_load' Table_Name, strField_nm Field_Name      
INTO #deduptbls      
FROM #MetaData      
WHERE strTable_nm NOT IN ('Population','Encounter')      
AND bitMatchField_flg=1      
      
--Get all of the columns in the lookup tables.We need to determine the Identity column      
SELECT DISTINCT c.Table_Schema+'.'+c.Table_Name Table_Name, c.Column_Name Field_Name      
INTO #work      
FROM Information_Schema.Columns c, #deduptbls d      
WHERE c.Table_Schema='S'+LTRIM(STR(@Study_id))      
AND c.Table_Name=d.Table_Name      
    
      
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
 EXEC (@sql)      
       
 --Delete the current working record      
 DELETE #work WHERE Table_Name=@TableName AND Field_Name=@FieldName      
       
 --Get the next record to check      
 SELECT TOP 1 @TableName=Table_Name, @FieldName=Field_Name FROM #work      
      
END      
      
DECLARE @sqlgroup VARCHAR(2000)      
      
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
       
 EXEC (@sql)       
       
 DELETE #deduptbls WHERE Table_Name=@TableName      
       
 SELECT TOP 1 @TableName=Table_Name FROM #deduptbls      
      
END      
    
DROP TABLE #work      
DROP TABLE #deduptbls      
DROP TABLE #Identity      
      
--First to work on the NULL counts      
SELECT d.Table_id, md.strTable_nm, d.Field_id, md.strField_nm      
INTO #NULL      
FROM Destination_View d, #MetaData md      
WHERE Package_id=@Package_id      
AND intVersion=@Version      
AND bitNULLCount=1      
AND d.Table_id=md.Table_id      
AND d.Field_id=md.Field_id      
    
    
--Now to loop thru the fields      
SELECT TOP 1 @TableName=strTable_nm, @Table_id=Table_id, @FieldName=strField_nm, @Field_id=Field_id      
FROM #NULL      
ORDER BY Table_id,Field_id      
      
WHILE @@ROWCOUNT>0      
BEGIN      
      
 SET @sql='INSERT INTO VR_NULLCounts (DataFile_id,Table_id,strTable_nm,Field_id,strField_nm,Occurrences)      
 SELECT '+LTRIM(STR(@File_id))+','+LTRIM(STR(@Table_id))+','''+@TableName+''','+LTRIM(STR(@Field_id))+','''+@FieldName+''', COUNT(*)      
 FROM S'+LTRIM(STR(@Study_id))+'.'+@TableName+'_Load      
 WHERE DataFile_id='+LTRIM(STR(@File_id))+'      
 AND '+@FieldName+' IS NULL'      
 EXEC (@sql)      
       
 DELETE #NULL WHERE strTable_nm=@TableName AND strField_nm=@FieldName      
       
 SELECT TOP 1 @TableName=strTable_nm, @Table_id=Table_id, @FieldName=strField_nm, @Field_id=Field_id      
 FROM #NULL      
 ORDER BY Table_id,Field_id      
      
END      
      
--Now to get the freq counts      
SELECT d.Table_id, md.strTable_nm, d.Field_id, md.strField_nm, intFreqLimit      
INTO #Freqs      
FROM Destination_View d, #MetaData md      
WHERE Package_id=@Package_id      
AND intVersion=@Version      
AND intFreqLimit>0      
AND d.Table_id=md.Table_id      
AND d.Field_id=md.Field_id      
    
--Now to loop thru the fields      
SELECT TOP 1 @TableName=strTable_nm, @Table_id=Table_id, @FieldName=strField_nm, @Field_id=Field_id,      
 @LowLimit=intFreqLimit      
FROM #Freqs      
ORDER BY Table_id,Field_id      
      
WHILE @@ROWCOUNT>0      
BEGIN      
      
 SET @sql='INSERT INTO VR_Freqs (DataFile_id,Table_id,strTable_nm,Field_id,strField_nm,strValue,Occurrences,LowLimit)      
 SELECT '+LTRIM(STR(@File_id))+','+LTRIM(STR(@Table_id))+','''+@TableName+''','+LTRIM(STR(@Field_id))+','''+@FieldName+''',       
  '+@FieldName+',COUNT(*),'+LTRIM(STR(@LowLimit))+'      
 FROM S'+LTRIM(STR(@Study_id))+'.'+@TableName+'_Load      
 WHERE DataFile_id='+LTRIM(STR(@File_id))+'      
 GROUP BY '+@FieldName+'      
 HAVING COUNT(*)>='+LTRIM(STR(@LowLimit))      
 EXEC (@sql)      
       
 DELETE #Freqs WHERE strTable_nm=@TableName AND strField_nm=@FieldName      
       
 SELECT TOP 1 @TableName=strTable_nm, @Table_id=Table_id, @FieldName=strField_nm, @Field_id=Field_id,      
  @LowLimit=intFreqLimit      
 FROM #Freqs      
 ORDER BY Table_id,Field_id      
      
END      
      
--Match Field Validation      
SELECT md.Table_id, md.strTable_nm, md.Field_id, md.strField_nm, mfv.bitMatchField      
INTO #mfv      
FROM MatchFieldValidation mfv, #MetaData md, PackageTable_View p      
WHERE mfv.Study_id=@Study_id      
AND mfv.Table_id=md.Table_id      
AND mfv.Field_id=md.Field_id      
AND p.Package_id=@Package_id      
AND p.intVersion=@Version      
AND mfv.Table_id=p.Table_id      
      
CREATE TABLE #mfv_work (strMatchValue VARCHAR(220), strCheckValue VARCHAR(2200))      
CREATE TABLE #return (strMatchValue VARCHAR(220))      
      
SELECT TOP 1 @TableName=strTable_nm FROM #mfv ORDER BY Table_id      
WHILE @@ROWCOUNT>0      
BEGIN      
      
 --Only want to include files that are not abandoned.      
 --Get the datafile_ids that are currently in the table.      
 CREATE TABLE #DFs (DataFile_id INT)      
       
 SELECT @sql='INSERT INTO #DFs (DataFile_id)      
 SELECT DataFile_id       
 FROM S'+LTRIM(STR(@Study_id))+'.'+@TableName+'_Load      
 GROUP BY DataFile_id'      
 EXEC (@sql)      
       
 --Get rid of abandoned datafile_ids      
 DELETE t      
 FROM #DFs t, DataFileState dfs      
 WHERE t.DataFile_id=dfs.DataFile_id      
 AND dfs.State_id=11      
       
 --Now to build a comma seperated string of datafile_ids      
 DECLARE @DataFiles VARCHAR(3000)      
 SELECT @DataFiles=''      
       
 SELECT @DataFiles=','+LTRIM(STR(DataFile_id))      
 FROM #DFs      
       
 --Get rid of the leading comma      
 SELECT @DataFiles=SUBSTRING(@DataFiles,2,6000)      
       
 DROP TABLE #DFs      
       
 SET @sql='INSERT INTO VR_MatchFieldValidation (DataFile_id,strTable_nm,strMatchValue,strCheckValue)      
 SELECT '+LTRIM(STR(@File_id))+','''+@TableName+''','''      
       
 SELECT @sql=@sql+strField_nm+'+'      
 FROM #mfv      
 WHERE strTable_nm=@TableName      
 AND bitMatchField=1      
 ORDER BY Field_id      
       
 SELECT @sql=SUBSTRING(@sql,1,(LEN(@sql)-1))+''','''      
       
 SELECT @sql=@sql+strField_nm+'+'      
 FROM #mfv      
 WHERE strTable_nm=@TableName      
 AND bitMatchField=0      
 ORDER BY Field_id      
       
 SELECT @sql=SUBSTRING(@sql,1,(LEN(@sql)-1))+''''      
       
 EXEC (@sql)      
       
 TRUNCATE TABLE #mfv_work      
 TRUNCATE TABLE #return      
       
 SELECT @sql='INSERT INTO #mfv_work (strMatchValue,strCheckValue)      
 SELECT DISTINCT '      
       
 SELECT @sql=@sql+'CONVERT(VARCHAR,'+strField_nm+')+'''+'+''+'      
 FROM #mfv      
 WHERE strTable_nm=@TableName      
 AND bitMatchField=1      
 ORDER BY Field_id      
       
 SELECT @sql=SUBSTRING(@sql,1,(LEN(@sql)-5))+','      
       
 SELECT @sql=@sql+'CONVERT(VARCHAR,'+strField_nm+')+'''+'+''+'      
 FROM #mfv      
 WHERE strTable_nm=@TableName      
 AND bitMatchField=0      
 ORDER BY Field_id      
       
 SELECT @sql=SUBSTRING(@sql,1,(LEN(@sql)-5))+'      
 FROM S'+LTRIM(STR(@Study_id))+'.'+@TableName+'_Load WHERE DataFile_id IN ('+@DataFiles+')'      
       
 EXEC (@sql)      
       
 INSERT INTO #return      
 SELECT strMatchValue      
 FROM #mfv_work      
 GROUP BY strMatchValue      
 HAVING COUNT(*)>1      
       
 INSERT INTO VR_MatchFieldValidation (DataFile_id,strTable_nm,strMatchValue,strCheckValue)      
 SELECT @File_id, @TableName, w.strMatchValue, w.strCheckValue      
 FROM #return t, #mfv_work w      
 WHERE t.strMatchValue=w.strMatchValue      
 ORDER BY w.strMatchValue      
       
 DELETE #mfv WHERE strTable_nm=@TableName      
       
 SELECT TOP 1 @TableName=strTable_nm FROM #mfv ORDER BY Table_id      
      
END      
      
--If we are not loading into the Pop table, we will skip the presample      
IF (SELECT COUNT(*)       
  FROM #MetaData t, PackageTable_View pt       
  WHERE t.strTable_nm LIKE 'Population%'       
  AND t.Table_id=pt.Table_id       
  AND pt.Package_id=@Package_id       
  AND pt.intVersion=@Version)>0      
EXEC LD_PersistantAssignment @File_id      
      
DROP TABLE #MetaData      
DROP TABLE #NULL      
DROP TABLE #Freqs      
DROP TABLE #mfv      
    
      
--Check the data file for a DRG code greater then the max value in the DRG master table (HCAHPSIP)    
--This could happen if MSDRG is mapped to DRG field.    
    
--First checks if DRG is even in the current package (Field_ID 18 is DRG field from MetaField    
if exists (select 'x' from Destination_View where package_ID = @Package_ID and intVersion=@Version and Field_ID=@DRGFieldID)    
 begin    
  create table #compare (maxDRG  varchar(5), MaxDRGTable  varchar(5))    
  set @sql = 'Insert into #compare select max(cast(isnull(DRG,0) as int)) , (Select max(cast(DRG as int)) from hcahpsip) from S'+LTRIM(STR(@Study_id))+'.Encounter_Load where DataFile_ID = ' + cast(@File_ID as varchar(10))   
  exec (@sql)    
    
    
  Select @maxDRGinFile=isnull(MaxDRG,0), @MaxDRGinTable=MaxDRGTable from #compare    
  if cast(@maxDRGinFile as int) > cast(@MaxDRGinTable as int)    
   begin     
    Insert into LD_LoadWarnings (dataFile_ID, Package_ID, intVersion,Study_ID, WarningMsg) select @File_id, @Package_ID, @Version, @Study_ID, 'DRG field contains data with values greater than ' + @MaxDRGinTable + '.  Please check DRG mapping.'    
   end    
  Drop table #compare    
 end    
    
    
--Next check for HserviceType (Field_ID 1206) and Sex (Field_ID 14)     
--if found we want to make sure there is no records with a Sex of 'M' and HServicetype of 1    
--this would be men having babies (or OBGYN classified visits)    
if exists (select 'x' from Destination_View where package_ID = @Package_ID and intVersion=@Version and Field_ID=@HServiceType)     
 begin     
  if exists (select 'x' from Destination_View where package_ID = @Package_ID and intVersion=@Version and Field_ID =@Sex)    
   begin    
    create table #ManBabies (HServiceType varchar(10), Sex varchar(6))    
    set @sql = 'Insert into #ManBabies Select EL.HserviceType, PL.Sex from S'+LTRIM(STR(@Study_id))+'.Encounter_Load EL, S'+LTRIM(STR(@Study_id))+'.Population_Load PL where EL.Pop_ID = PL.Pop_ID and EL.DataFile_ID = ' + cast(@File_ID as varchar(10)) + ' 
and EL.Hservicetype = ''1'' and PL.Sex = ''M'''    
 --Print @SQL  
    EXEC (@sql)    
        
    IF OBJECT_ID('tempdb..#ManBabies') IS NOT NULL     
     begin    
          
      --now just checking if any records come back    
      if exists(select 'x' from #ManBabies)    
       begin    
        Insert into LD_LoadWarnings (dataFile_ID, Package_ID, intVersion,Study_ID, WarningMsg) select @File_id, @Package_ID, @Version, @Study_ID, 'Loaded files contain an HServiceType of 1 and a Sex code of M.'    
       end    
    
      drop table #ManBabies              
     end    
        
   end    
 end    
    
--Next check for CPT4, CPT4_2, CPT4_3 fields
--if found we want to make sure there are no occurrences having an alphabetic first character in any of them
--GCodes (alphabetic codes) are intended to be in HCPCSLv12cd, HCPCSLv12cd_2, or HCPCSLv12cd_3 instead
if exists (select 'x' from Destination_View where package_ID = @Package_ID and intVersion=@Version and Field_ID in 
	(select Field_ID from qualisys.qp_Prod.dbo.metafield where 
		strField_nm in ('CPT4', 'CPT4_2','CPT4_3') ))     
 begin     
  create table #GCodesInCPTFields (Field varchar(16), Value varchar(6))    

  if exists (select 'x' from Destination_View where package_ID = @Package_ID and intVersion=@Version and Field_ID in 
	(select Field_ID from qualisys.qp_Prod.dbo.metafield where 
		strField_nm = 'CPT4') )    
   begin    
    set @sql = 'Insert into #GCodesInCPTFields Select ''CPT4'', EL.CPT4 
	from S'+LTRIM(STR(@Study_id))+'.Encounter_Load EL
	where EL.DataFile_ID = ' + cast(@File_ID as varchar(10)) + ' 
	and EL.CPT4 like ''[ABCDEFGHIJKLMNOPQRSTUVWXYZ]%'''
 --Print @SQL  
    EXEC (@sql)    
   end    
        
  if exists (select 'x' from Destination_View where package_ID = @Package_ID and intVersion=@Version and Field_ID in 
	(select Field_ID from qualisys.qp_Prod.dbo.metafield where 
		strField_nm = 'CPT4_2') )    
   begin    
    set @sql = 'Insert into #GCodesInCPTFields Select ''CPT4_2'', EL.CPT4_2 
	from S'+LTRIM(STR(@Study_id))+'.Encounter_Load EL
	where EL.DataFile_ID = ' + cast(@File_ID as varchar(10)) + ' 
	and EL.CPT4_2 like ''[ABCDEFGHIJKLMNOPQRSTUVWXYZ]%'''
 --Print @SQL  
    EXEC (@sql)    
   end    
        
  if exists (select 'x' from Destination_View where package_ID = @Package_ID and intVersion=@Version and Field_ID in 
	(select Field_ID from qualisys.qp_Prod.dbo.metafield where 
		strField_nm = 'CPT4_3') )    
   begin    
    set @sql = 'Insert into #GCodesInCPTFields Select ''CPT4_3'', EL.CPT4_3 
	from S'+LTRIM(STR(@Study_id))+'.Encounter_Load EL
	where EL.DataFile_ID = ' + cast(@File_ID as varchar(10)) + ' 
	and EL.CPT4_3 like ''[ABCDEFGHIJKLMNOPQRSTUVWXYZ]%'''
 --Print @SQL  
    EXEC (@sql)    
   end    
        
IF OBJECT_ID('tempdb..#GCodesInCPTFields') IS NOT NULL     
    begin    
          
    --now just checking if any records come back    
    if exists(select 'x' from #GCodesInCPTFields)    
    begin    
		Insert into LD_LoadWarnings (dataFile_ID, Package_ID, intVersion,Study_ID, WarningMsg) 
		select distinct @File_id, @Package_ID, @Version, @Study_ID, 'HCPCS: '+ Value + ' was found in field: ' + Field
		from #GCodesInCPTFields
    end    
    
    drop table #GCodesInCPTFields
    end    
 end    
    
--Next check for HCPCSLv12cd, HCPCSLv12cd_2, HCPCSLv12cd_3 fields
--if found we want to make sure there are no occurrences of numerical first characters in any of them
--CPT Codes are intended to be in CPT4, CPT4_2, CPT4_3  instead
if exists (select 'x' from Destination_View where package_ID = @Package_ID and intVersion=@Version and Field_ID in 
	(select Field_ID from qualisys.qp_Prod.dbo.metafield where 
		strField_nm in ('HCPCSLvl2cd', 'HCPCSLvl2cd_2','HCPCSLvl2cd_3') ))     
 begin     
  create table #CPTCodesInHCPCSLvl12cdFields (Field varchar(16), Value varchar(6))    

  if exists (select 'x' from Destination_View where package_ID = @Package_ID and intVersion=@Version and Field_ID in 
	(select Field_ID from qualisys.qp_Prod.dbo.metafield where 
		strField_nm ='HCPCSLvl2cd' ))   begin    
    set @sql = 'Insert into #CPTCodesInHCPCSLvl12cdFields Select ''HCPCSLvl2cd'', EL.HCPCSLvl2cd
	from S'+LTRIM(STR(@Study_id))+'.Encounter_Load EL
	where EL.DataFile_ID = ' + cast(@File_ID as varchar(10)) + ' 
	and EL.HCPCSLvl2cd like ''[0123456789]%''' 
 --Print @SQL  
    EXEC (@sql)    
        
   end    
        
  if exists (select 'x' from Destination_View where package_ID = @Package_ID and intVersion=@Version and Field_ID in 
	(select Field_ID from qualisys.qp_Prod.dbo.metafield where 
		strField_nm ='HCPCSLvl2cd_2' ))   begin    
    set @sql = 'Insert into #CPTCodesInHCPCSLvl12cdFields Select ''HCPCSLvl2cd_2'', EL.HCPCSLvl2cd_2
	from S'+LTRIM(STR(@Study_id))+'.Encounter_Load EL 
	where EL.DataFile_ID = ' + cast(@File_ID as varchar(10)) + ' 
	and EL.HCPCSLvl2cd_2 like ''[0123456789]%''' 
 --Print @SQL  
    EXEC (@sql)    
        
   end    
        
  if exists (select 'x' from Destination_View where package_ID = @Package_ID and intVersion=@Version and Field_ID in 
	(select Field_ID from qualisys.qp_Prod.dbo.metafield where 
		strField_nm ='HCPCSLvl2cd_3' ))   begin    
    set @sql = 'Insert into #CPTCodesInHCPCSLvl12cdFields Select ''HCPCSLvl2cd_3'', EL.HCPCSLvl2cd_3
	from S'+LTRIM(STR(@Study_id))+'.Encounter_Load EL
	where EL.DataFile_ID = ' + cast(@File_ID as varchar(10)) + ' 
	and EL.HCPCSLvl2cd_3 like ''[0123456789]%''' 
 --Print @SQL  
    EXEC (@sql)    
        
   end    
        
  IF OBJECT_ID('tempdb..#CPTCodesInHCPCSLvl12cdFields') IS NOT NULL     
    begin    
          
    --now just checking if any records come back    
    if exists(select 'x' from #CPTCodesInHCPCSLvl12cdFields)    
    begin    
		Insert into LD_LoadWarnings (dataFile_ID, Package_ID, intVersion,Study_ID, WarningMsg) 
		select distinct @File_id, @Package_ID, @Version, @Study_ID, 'CPT Code: '+ Value + ' was found in field: ' + Field
		from #CPTCodesInHCPCSLvl12cdFields
    end    
    
    drop table #CPTCodesInHCPCSLvl12cdFields
    end    
 end    
    
-- now we need to check that the HServicetype field is mapped correctly.    
-- we will do this by checking if there is a MSDRG field (and HServiceType Field) => and then if so     
-- we will then check that the formula being used is GETMSDRGService    
if exists (select 'x' from Destination_View where package_ID = @Package_ID and intVersion=@Version and Field_ID=@MSDRGFieldID)     
 begin     	
  if exists (select 'x' from Destination_View where package_ID = @Package_ID and intVersion=@Version and Field_ID=@HServiceType)    
   begin   
	create table #CheckForMSDRG (MSDRG varchar(10))
    set @sql = 'Insert Into #CheckForMSDRG Select MSDRG from S'+LTRIM(STR(@Study_id))+'.Encounter_Load where MSDRG is not null and DataFile_ID = ' + cast(@File_ID as varchar(10))    
    exec (@sql)    
        
    --now just checking if any records come back    
    IF OBJECT_ID('tempdb..#CheckForMSDRG') IS NOT NULL 	
     begin    
      if exists(select 'x' from #CheckForMSDRG)    
       begin    
        if exists (select 'x' from Destination_View where package_ID = @Package_ID and intVersion=@Version and Field_ID =@HServiceType and formula not like '%DTSDestination("HServiceType") = GetMSDRGService(%')    
         begin    
          Insert into LD_LoadWarnings (dataFile_ID, Package_ID, intVersion,Study_ID, WarningMsg) select @File_id, @Package_ID, @Version, @Study_ID, 'HServiceType may be mapped incorrectly. Please check the DTS.'    
         end    
        Drop table #CheckForMSDRG    
       end    
     end    
   end    
 end    

  /*
 Now, check to see if this dataset contains only 1 month of data.  Hospice ONLY!
 */

DECLARE @survyetype_id int

select @survyetype_id = surveytype_id
from Qualisys.QP_Prod.dbo.SurveyType
where surveytype_dsc = 'Hospice CAHPS'

if exists(select 1 from Qualisys.QP_Prod.dbo.Survey_Def where study_id = @Study_id and surveytype_id = @survyetype_id)
begin

	DECLARE @count int
	DECLARE @dynSQL nvarchar(1000)

	set @dynSQL = 'SELECT @cnt = count(*)
	FROM (select DatePart(yyyy, ServiceDate) yr, DatePart(mm, ServiceDate) mo
		from S'+LTRIM(STR(@Study_id))+'.Encounter_Load
		where servicedate is not null
		and DataFile_id = ' + cast(@File_id as varchar(10)) + '
		group by DatePart(yyyy, ServiceDate), DatePart(mm, ServiceDate)) t'

	exec sp_executesql @dynSQL, N' @cnt int OUTPUT', @count OUTPUT
 
	if @count > 1
	begin
		Insert into LD_LoadWarnings (dataFile_ID, Package_ID, intVersion,Study_ID, WarningMsg) select @File_id, @Package_ID, @Version, @Study_ID, 'This dataset contains more than one(1) month.'
	end 
	

	-- Check for inconsistent HSP_NumDecd, HSP_NumLiveDisch, or HSP_NumNoPub counts
	-- Inconsistent means the counts are missing (null or blank) or are different within the same CCN and service month.
	create table #InconsistentHospiceCount (WarningMsg varchar(1000))

	set @sql = '
	insert into #InconsistentHospiceCount
	select ''Inconsistent HSP_NumDecd count for CCN '' + CCN + '' and service month '' + cast(Month as varchar(2)) + ''/'' + cast(Year as varchar(4)) + ''.''
	from
	(
		select CCN, datepart(month, ServiceDate) as Month, datepart(year, ServiceDate) as Year
		from S'+LTRIM(STR(@Study_id))+'.Encounter_Load
		where CCN is not null 
		and ServiceDate is not null
		and DataFile_id = ' + cast(@File_id as varchar(10)) + '
		group by CCN, datepart(month, ServiceDate), datepart(year, ServiceDate)
		having count(distinct HSP_NumDecd) > 1
	) as Inconsistent
	'
	exec(@sql)

	set @sql = '
	insert into #InconsistentHospiceCount
	select ''Inconsistent HSP_NumLiveDisch count for CCN '' + CCN + '' and service month '' + cast(Month as varchar(2)) + ''/'' + cast(Year as varchar(4)) + ''.''
	from
	(
		select CCN, datepart(month, ServiceDate) as Month, datepart(year, ServiceDate) as Year
		from S'+LTRIM(STR(@Study_id))+'.Encounter_Load
		where CCN is not null 
		and ServiceDate is not null
		and DataFile_id = ' + cast(@File_id as varchar(10)) + '
		group by CCN, datepart(month, ServiceDate), datepart(year, ServiceDate)
		having count(distinct HSP_NumLiveDisch) > 1
	) as Inconsistent
	'
	exec(@sql)

	set @sql = '
	insert into #InconsistentHospiceCount
	select ''Inconsistent HSP_NumNoPub count for CCN '' + CCN + '' and service month '' + cast(Month as varchar(2)) + ''/'' + cast(Year as varchar(4)) + ''.''
	from
	(
		select CCN, datepart(month, ServiceDate) as Month, datepart(year, ServiceDate) as Year
		from S'+LTRIM(STR(@Study_id))+'.Encounter_Load
		where CCN is not null 
		and ServiceDate is not null
		and DataFile_id = ' + cast(@File_id as varchar(10)) + '
		group by CCN, datepart(month, ServiceDate), datepart(year, ServiceDate)
		having count(distinct HSP_NumNoPub) > 1
	) as Inconsistent
	'
	exec(@sql)

	set @sql = '
	insert into #InconsistentHospiceCount
	select top 1 ''This dataset contains records where HSP_NumDecd is missing.''
	from S'+LTRIM(STR(@Study_id))+'.Encounter_Load
	where (HSP_NumDecd is null or ltrim(rtrim(HSP_NumDecd)) = '''')
	and DataFile_id = ' + cast(@File_id as varchar(10))

	exec(@sql)

	set @sql = '
	insert into #InconsistentHospiceCount
	select top 1 ''This dataset contains records where HSP_NumLiveDisch is missing.''
	from S'+LTRIM(STR(@Study_id))+'.Encounter_Load
	where (HSP_NumLiveDisch is null or ltrim(rtrim(HSP_NumLiveDisch)) = '''')
	and DataFile_id = ' + cast(@File_id as varchar(10))

	exec(@sql)

	set @sql = '
	insert into #InconsistentHospiceCount
	select top 1 ''This dataset contains records where HSP_NumNoPub is missing.''
	from S'+LTRIM(STR(@Study_id))+'.Encounter_Load
	where (HSP_NumNoPub is null or ltrim(rtrim(HSP_NumNoPub)) = '''')
	and DataFile_id = ' + cast(@File_id as varchar(10))

	exec(@sql)

	insert into LD_LoadWarnings (dataFile_ID, Package_ID, intVersion,Study_ID, WarningMsg)
	select @File_id, @Package_ID, @Version, @Study_ID, WarningMsg from #InconsistentHospiceCount

	drop table #InconsistentHospiceCount
end
       
       
SET NOCOUNT OFF      


