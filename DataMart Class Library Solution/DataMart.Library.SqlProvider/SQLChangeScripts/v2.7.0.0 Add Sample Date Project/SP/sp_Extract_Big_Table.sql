ALTER PROCEDURE SP_Extract_Big_Table      
AS      

-- Modified 10/17/06 - SJS - Added datSampleEncounterDate field to Big_Table_Work from qp_prod.dbo.Big_View_Web
      
DECLARE @strsql VARCHAR(8000), @study INT, @field VARCHAR(30), @datatype CHAR(1), @length INT      
DECLARE @strsel VARCHAR(3000), @table VARCHAR(200), @user VARCHAR(10), @cnt INT, @SampleSet INT      
DECLARE @View_id INT, @WebUser VARCHAR(10), @Server VARCHAR(100)      
      
SELECT @Server=strParam_Value FROM DataMart_Params WHERE strParam_nm='QualPro Server'      
      
SELECT @strsql='EXEC '+@Server+'QP_Prod.dbo.SP_Phase4_Update_ExtractTables'      
EXEC (@strsql)      
      
SELECT @strsql='EXEC '+@Server+'QP_Prod.dbo.SP_Phase4_Web_Extract_Flg'      
EXEC (@strsql)      
      
CREATE TABLE #SampleSets (      
     Study_id INT,       
     SampleSet_id INT)      
      
SELECT @strsql='INSERT INTO #SampleSets       
SELECT Study_id, SampleSet_id      
FROM '+@Server+'QP_Prod.dbo.WEB_SampleSets'      
EXEC (@strsql)      
      
SELECT DISTINCT study_id      
INTO #s      
FROM #SampleSets      
      
SET NOCOUNT ON      
      
CREATE TABLE #columns (field VARCHAR(128))      
CREATE TABLE #alter (strfield_nm VARCHAR(20), strfielddatatype VARCHAR(20), intfieldlength INT)      
     
WHILE (SELECT count(*) FROM #s ) > 0      
BEGIN --loop1      
      
TRUNCATE TABLE #alter      
TRUNCATE TABLE #columns      
      
SET @study=(SELECT TOP 1 study_id FROM #s)      
      
SET @WebUser=(SELECT uid FROM sysusers WHERE name='s'+CONVERT(VARCHAR,@study))      
      
CREATE TABLE #uid (uid INT)      
SELECT @strsql='INSERT INTO #uid      
SELECT uid FROM '+@Server+'QP_Prod.dbo.SysUsers       
WHERE name=''S'+LTRIM(STR(@Study))+''''      
EXEC (@strsql)      
      
SELECT @user=uid FROM #uid      
      
DROP TABLE #uid      
      
WHILE (SELECT count(*) FROM #SampleSets WHERE study_id=@study) > 0      
BEGIN --SampleSet loop      
      
SET @SampleSet=(SELECT TOP 1 SampleSet_id FROM #SampleSets WHERE study_id=@study)      
      
PRINT @SampleSet      
      
--Get the SampleSet/SampleUnit combinations that need to be Removed for this SampleSet.  Rarely will add to the table.      
--We will set the strUnitSelectType in Big_Table to 'X' for any records that have a match in this table.  We will not keep       
-- results for these records.      
--Find the distinct values for the SampleSet currently being pulled over      
CREATE TABLE #Remove (      
     SampleSet_id INT,       
     SampleUnit_id INT,       
     strUnitSelectType VARCHAR(10),       
     datSampleCreate_dt DATETIME,      
     Target INT)      
      
SELECT @strsql='INSERT INTO #Remove       
SELECT SampleSet_id, SampleUnit_id, strUnitSelectType, datSampleCreate_dt, Target      
FROM '+@Server+'QP_Prod.dbo.WEB_UnitSelectType_View      
WHERE SampleSet_id='+LTRIM(STR(@SampleSet))      
EXEC (@strsql)      
      
--Create a temp table to hold the SampleSet/SampleUnits that only have one entry.      
SELECT SampleSet_id, SampleUnit_id      
INTO #Single      
FROM #Remove      
GROUP BY SampleSet_id, SampleUnit_id      
HAVING COUNT(*)=1      
      
--We want to now remove Indirects at targeted units      
INSERT INTO SampleRemove (SampleSet_id, SampleUnit_id, strUnitSelectType)      
SELECT DISTINCT s.SampleSet_id, s.SampleUnit_id, 'I'      
FROM #Remove r, #Single s      
WHERE s.SampleSet_id=r.SampleSet_id      
AND s.SampleUnit_id=r.SampleUnit_id      
AND r.strUnitSelectType='I'      
AND r.Target>0      
      
--Remove the records from the previous query from further inspection      
DELETE r      
FROM #Remove r, #Single s      
WHERE s.SampleSet_id=r.SampleSet_id      
AND s.SampleUnit_id=r.SampleUnit_id      
AND r.strUnitSelectType='I'      
AND r.Target>0      
      
--Insert a record for the single occurance SampleSet/SampleUnits      
INSERT INTO UnitSelectType (SampleSet_id, SampleUnit_id, strUnitSelectType, datSampleCreate_dt)      
SELECT t.SampleSet_id, t.SampleUnit_id, strUnitSelectType, datSampleCreate_dt      
FROM #Remove t, #Single s      
WHERE s.SampleSet_id=t.SampleSet_id      
AND s.SampleUnit_id=t.SampleUnit_id      
      
--Delete the SampleSet/SampleUnits that only have one entry in the temp table      
DELETE r      
FROM #Remove r, #Single t      
WHERE t.SampleSet_id=r.SampleSet_id      
AND t.SampleUnit_id=r.SampleUnit_id      
      
--insert a record for the SampleSet/SampleUnits that have both      
INSERT INTO UnitSelectType (SampleSet_id, SampleUnit_id, strUnitSelectType, datSampleCreate_dt)      
SELECT DISTINCT SampleSet_id, SampleUnit_id, 'B', datSampleCreate_dt      
FROM #Remove       
      
--Insert into the sampleRemove table for the indirects      
INSERT INTO SampleRemove      
SELECT DISTINCT SampleSet_id, SampleUnit_id, 'I'      
FROM #Remove       
      
--Cleanup      
DROP TABLE #Remove      
DROP TABLE #Single      
      
-- To be used when we extract on a SampleSet basis.        
SET @strsql='EXEC '+@Server+'QP_Prod.dbo.SP_Phase4_Big_View_Web '+CONVERT(VARCHAR,@SampleSet)      
      
EXEC (@strsql)      
      
CREATE TABLE #View (View_id INT)      
      
SELECT @strsql='INSERT INTO #View      
SELECT id FROM '+@Server+'QP_Prod.dbo.SysObjects      
WHERE uid='+LTRIM(STR(@User))+'      
AND name=''Big_View_Web'''      
EXEC (@strsql)  
      
SELECT @View_id=View_id FROM #View      
  
DROP TABLE #View      
      
IF EXISTS (SELECT * FROM sysobjects WHERE name='Big_Table_Work' AND uid=@WebUser)      
BEGIN  --loop2      
      
SET @strsql='INSERT INTO #columns SELECT name FROM syscolumns ' +      
 ' WHERE id=object_id(N''[S'+LTRIM(STR(@Study))+'].[BIG_TABLE_Work]'') ' +      
 ' AND OBJECTPROPERTY(id, N''IsTable'')=1 ' +      
 ' INSERT INTO #alter SELECT strfield_nm, strfielddatatype, intfieldlength ' +      
 ' FROM (SELECT sc.name strfield_nm, st.name strfielddatatype,  ' +      
  ' sc.length intfieldlength  ' +      
  ' FROM '+@server+'QP_Prod.dbo.syscolumns sc, '+@server+'QP_Prod.dbo.systypes st ' +      
  ' WHERE id='+CONVERT(VARCHAR,@View_id) +      
  ' and sc.xtype=st.xtype ' +      
 ' ) m ' +      
 ' LEFT OUTER JOIN #columns c ' +      
 ' ON m.strField_nm=c.field ' +      
 ' WHERE c.field is null '       
EXEC (@strsql)      
      
IF (SELECT count(*) FROM #alter)=0      
GOTO populate      
      
SET @strsql=' ALTER TABLE s'+LTRIM(STR(@Study))+'.Big_Table_Work ADD '       
      
-- Add new fields to the big_table for the study.       
WHILE (SELECT COUNT(*) FROM #alter) > 0      
BEGIN --loop3      
      
SET @field=(SELECT TOP 1 strfield_nm FROM #alter)      
SET @datatype=(SELECT strfielddatatype FROM #alter WHERE strfield_nm=@field)      
SET @length=(SELECT intfieldlength FROM #alter WHERE strfield_nm=@field)      
      
      
IF (SELECT strfielddatatype FROM #alter WHERE strfield_nm=@field)='VARCHAR'      
      
SET @strsql=@strsql+' '+@field+' VARCHAR('+CONVERT(VARCHAR,@length)+'), '      
      
IF (SELECT strfielddatatype FROM #alter WHERE strfield_nm=@field)='INT'      
      
SET @strsql=@strsql+' '+@field+' INT, '       
      
IF (SELECT strfielddatatype FROM #alter WHERE strfield_nm=@field)='DATETIME'      
      
SET @strsql=@strsql+' '+@field+' DATETIME, '       
      
DELETE #alter WHERE strfield_nm=@field      
      
END --loop3      
      
SET @strsql=LEFT(@strsql,(LEN(@strsql)-1))      
      
SET @strsql=@strsql       
      
EXEC (@strsql)      
      
END --loop2      
      
-- This section will create the big_table if it does not exist      
      
ELSE       
BEGIN --loop4      
SET @strsql='INSERT INTO #alter ' +      
 ' SELECT sc.name, st.name, sc.length ' +      
  ' FROM '+@server+'QP_Prod.dbo.syscolumns sc, '+@server+'QP_Prod.dbo.systypes st ' +      
  ' WHERE id='+CONVERT(VARCHAR,@View_id) +      
  ' AND sc.xtype=st.xtype ' +      
  ' AND sc.name NOT IN (''QuestionForm_id'',''datUndeliverable'',''SamplePop_id'', ' +      
  ' ''SampleSet_id'',''SampleUnit_id'',''datreportdate'',''datSampleEncounterDate'',''strunitselecttype'',' +
  ' ''numweight'',''study_id'',''survey_id'',''QtrTable'',''datSampleCreate_dt'')'      
EXEC (@strsql)       
       
SET @strsql=' CREATE TABLE s'+LTRIM(STR(@Study))+'.Big_Table_Work (' +      
 ' QtrTable VARCHAR(10), '+--AS ' +      
-- ' convert(varchar(10),(convert(varchar,year(datReportDate))+''_'' ' +      
-- '+convert(varchar,datepart(quarter,datReportDate)))), ' +      
 ' questionform_id INT, datUndeliverable DATETIME, SamplePop_id INT NOT NULL, ' +      
 ' SampleSet_id INT, SampleUnit_id INT NOT NULL, datReportDate DATETIME, datSampleEncounterDate DATETIME,' +
 ' strUnitSelectType CHAR(1), numWeight FLOAT, ' +      
 ' study_id INT, survey_id INT, datSampleCreate_dt DATETIME, '+      
 ' DaysFromFirstMailing INT, DaysFromCurrentMailing INT, bitComplete BIT, '+  
 ' HDisposition VARCHAR(20), '  
      
-- Add fields to the big_table for the study.      
  
WHILE (SELECT COUNT(*) FROM #alter) > 0      
BEGIN --loop5      
      
SET @field=(SELECT TOP 1 strfield_nm FROM #alter)      
SET @datatype=(SELECT strfielddatatype FROM #alter WHERE strfield_nm=@field)      
SET @length=(SELECT intfieldlength FROM #alter WHERE strfield_nm=@field)      
      
IF (SELECT strfielddatatype FROM #alter WHERE strfield_nm=@field)='VARCHAR'      
      
SET @strsql=@strsql+' '+@field+' VARCHAR('+CONVERT(VARCHAR,@length)+'), '      
      
IF (SELECT strfielddatatype FROM #alter WHERE strfield_nm=@field)='INT'      
      
SET @strsql=@strsql+' '+@field+' INT, '       
      
IF (SELECT strfielddatatype FROM #alter WHERE strfield_nm=@field)='DATETIME'      
      
SET @strsql=@strsql+' '+@field+' DATETIME, '       
      
DELETE #alter WHERE strfield_nm=@field      
      
END --loop5      
      
SET @strsql=LEFT(@strsql,(LEN(@strsql)-1))      
      
SET @strsql=@strsql+') '      
      
EXEC (@strsql)   
  
      
SET @strsql='ALTER TABLE s'+LTRIM(STR(@Study))+'.Big_Table_Work WITH NOCHECK ADD       
 CONSTRAINT [PK_big_table_work] PRIMARY KEY  CLUSTERED       
 (      
  [SamplePop_id],      
  [SampleUnit_id]      
 )  ON [PRIMARY] '      
EXEC (@strsql)      
      
END --loop4      
      
populate:      
      
-- Now we will add all records for returned surveys.      
--   These get inserted INTO '+@server+'QP_Prod.dbo.questionform_extract      
--   with a tiextracted value of 1.  The first step is to build the       
--   SELECT statement.      
      
TRUNCATE TABLE #columns      
      
SET @strsql=' INSERT INTO #columns SELECT name FROM syscolumns ' +      
 ' WHERE id=object_id(N''[S'+LTRIM(STR(@Study))+'].[BIG_TABLE_WORK]'') ' +      
 ' AND OBJECTPROPERTY(id, N''IsTable'')=1 ' +      
 ' AND name NOT IN (''QtrTable'',''bitComplete'',''DaysFromFirstMailing'',''DaysFromCurrentMailing'',''HDisposition'')'     
EXEC (@strsql)      
      
SET @strsel=''      
      
WHILE (SELECT COUNT(*) FROM #columns) > 0      
BEGIN --loop6      
      
SET @field=(SELECT TOP 1 field FROM #columns)      
      
SET @strsel=@strsel+@field+', '      
      
DELETE #columns WHERE field=@field      
      
END --loop6      
      
SET @strsel=LEFT(@strsel,(LEN(@strsel)-1))      
     
SET NOCOUNT OFF      
      
SET @strsql='INSERT INTO s'+LTRIM(STR(@Study))+'.Big_Table_Work (QtrTable, '+@strsel+') ' +      
 ' SELECT dbo.YearQtr(datReportDate), '+@strsel+      
 ' FROM '+@server+'QP_Prod.s'+LTRIM(STR(@Study))+'.Big_View_Web '      

-- string lengths
select len(@strsel) AS strsel_len, len(@strsql) AS strsql_len

EXEC (@strsql)      
      
SET @strsql='UPDATE b '+CHAR(10)+      
 ' SET b.strUnitSelectType=''X'' '+CHAR(10)+      
 ' FROM S'+LTRIM(STR(@Study))+'.Big_Table_Work b, SampleRemove sr '+CHAR(10)+      
 ' WHERE b.SampleSet_id=sr.SampleSet_id '+CHAR(10)+      
 ' AND b.SampleUnit_id=sr.SampleUnit_id '+CHAR(10)+      
 ' AND b.strUnitSelectType=''I'''      
EXEC (@strsql)      
  
-- Now lets default any HCAHPS survey disposition to '08' (NonResponse After Max Attempts), where surveytype_id = 2 "HCAHPS" for this samplest  
SET @strSQL = 'UPDATE b SET HDisposition = ''08'' ' + CHAR(10) +   
 ' FROM S'+LTRIM(STR(@Study))+'.Big_Table_Work b, ClientStudySurvey c ' + CHAR(10) +   
 ' WHERE b.survey_id = c.survey_id and c.surveytype_id = 2 AND b.sampleset_id = ' + LTRIM(STR(@SampleSet))  
EXEC (@strsql)          
      
SET NOCOUNT ON      
      
DELETE #SampleSets WHERE SampleSet_id=@SampleSet AND study_id=@study      
      
SELECT @strsql='UPDATE '+@server+'QP_Prod.dbo.SampleSet      
SET web_extract_flg=1      
WHERE SampleSet_id='+LTRIM(STR(@SampleSet))      
EXEC (@strsql)      
      
END --SampleSet loop      
      
---------------------------------------------------------------------------------------------------------------------------------------------------------      
--  Response Rate PART 1 of 3 (SampleSet/SampleUnit Sampled Count - Update/Insert)      
  EXEC sp_Extract_RespRate @study, @procpart=1      
      
---------------------------------------------------------------------------------------------------------------------------------------------------------      
      
DELETE #s WHERE study_id=@study      
      
END --loop 1      
      
DROP TABLE #columns      
DROP TABLE #alter      
DROP TABLE #s      
DROP TABLE #SampleSets