/***********************************************************************************
						Table Creations/Alterations/Populations
***********************************************************************************/

CREATE TABLE ExportSetCMSAvailableCount (
ExportFileGUID UNIQUEIDENTIFIER NOT NULL,
AvailableCount INT NOT NULL,
CONSTRAINT PK_ESCAC_ExportFileID PRIMARY KEY (ExportFileGUID)
)

------------------------------------------------------------------------------------
GO

ALTER TABLE Extract_SR_NonQuestion ADD LangID INT

------------------------------------------------------------------------------------
GO

ALTER TABLE SampleUnit ADD bitHCAHPS BIT, MedicareNumber VARCHAR(20), MedicareName varchar(45), 
   strFacility_nm VARCHAR(100), City VARCHAR(42), State CHAR(2), Country VARCHAR(42), 
   strRegion_nm VARCHAR(42), AdmitNumber INT, BedSize INT, bitPeds BIT, bitTeaching BIT, 
   bitTrauma BIT, bitReligious BIT, bitGovernment BIT, bitRural BIT, bitForProfit BIT, 
   bitRehab BIT, bitCancerCenter BIT, bitPicker BIT, bitFreeStanding BIT, AHA_id INT

GO
------------------------------------------------------------------------------------
GO

CREATE TABLE ExportSetType (
ExportSetTypeID INT IDENTITY(1,1),
ExportSetTypeName VARCHAR(50),
HCAHPSHeaderRecord BIT,
CONSTRAINT EST_ExportSetTypeID PRIMARY KEY (ExportSetTypeID)
)

GO
------------------------------------------------------------------------------------
GO

INSERT INTO ExportSetType (ExportSetTypeName,HCAHPSHeaderRecord)
SELECT 'Picker',0
INSERT INTO ExportSetType (ExportSetTypeName,HCAHPSHeaderRecord)
SELECT 'HCAHPS IP',1
INSERT INTO ExportSetType (ExportSetTypeName,HCAHPSHeaderRecord)
SELECT 'CHART',1

GO
------------------------------------------------------------------------------------
GO

ALTER TABLE ExportSet ADD ExportSetTypeID INT NOT NULL DEFAULT(1), SampleUnit_id INT
ALTER TABLE ExportSet DROP COLUMN ExportCount

GO
------------------------------------------------------------------------------------
GO

CREATE TABLE ExportSchedule (
ExportScheduleID INT IDENTITY(1,1) PRIMARY KEY,
RunDate DATETIME NOT NULL,
ReturnsOnly BIT NOT NULL,
DirectsOnly BIT NOT NULL,
FileType INT NOT NULL,
ScheduledBy VARCHAR(42) NOT NULL,
ScheduledDate DATETIME NOT NULL,
StartedDate DATETIME NULL
)

GO
------------------------------------------------------------------------------------
GO

CREATE TABLE ExportScheduleExportSet (
ExportScheduleID INT NOT NULL,
ExportSetID INT NOT NULL,
CONSTRAINT PK_ESES_Schedule_Set PRIMARY KEY (ExportScheduleID,ExportSetID),
CONSTRAINT FK_ESES_ExportSet FOREIGN KEY (ExportSetID) REFERENCES ExportSet(ExportSetID)
)

GO
------------------------------------------------------------------------------------
GO

ALTER TABLE ExportFile ADD bitScheduledExport BIT NOT NULL DEFAULT(0), ReturnsOnly BIT, DirectsOnly BIT
ALTER TABLE ExportFile ADD bitSuccessful BIT, ErrorMessage VARCHAR(200), StackTrace VARCHAR(6000)
ALTER TABLE ExportFile ADD ExportFileGUID UNIQUEIDENTIFIER
ALTER TABLE ExportFile ADD bitNeedsNotification bit NOT NULL CONSTRAINT DF_ExportFile_bitNeedsNotification DEFAULT 0

GO
------------------------------------------------------------------------------------
GO

CREATE TABLE ExportFileMember (
ExportFileGUID UNIQUEIDENTIFIER NOT NULL,
SamplePop_id INT NOT NULL,
bitIsReturned BIT NOT NULL,
CONSTRAINT PK_EFM_ExportFile_SamplePop PRIMARY KEY (ExportFileGUID, SamplePop_id) --,
-- CONSTRAINT FK_EFM_ExportFile FOREIGN KEY (ExportFileGUID) REFERENCES ExportFile (ExportFileGUID)
)

GO
------------------------------------------------------------------------------------
GO

INSERT INTO DataMart_Params
SELECT 'ExportManagerStop','S','ExportManager','2130',NULL,NULL,'Specifies when scheduled exports should stop.'
INSERT INTO DataMart_Params
SELECT 'ExportManagerStart','S','ExportManager','0500',NULL,NULL,'Specifies when scheduled exports should start.'

-----------------------------------------------------------------------------------------------
GO

CREATE TABLE DispositionLog (
Study_id INT NOT NULL,
SamplePop_id INT NOT NULL,
Disposition_id INT NOT NULL,
ReceiptType_id INT NOT NULL,
datLogged DATETIME NOT NULL,
LoggedBy VARCHAR(42) NOT NULL,
DaysFromCurrent INT,
DaysFromFirst INT,
BitEvaluated BIT DEFAULT(0)
CONSTRAINT PK_DispositionLog_Samp_Study PRIMARY KEY (Study_id,SamplePop_id,Disposition_id,datLogged)
)

GO
------------------------------------------------------------------------------------
GO

DECLARE @SQL VARCHAR(8000), @Server VARCHAR(100)      
      
SELECT @Server=strParam_Value FROM DataMart_Params WHERE strParam_nm='QualPro Server'      

SET @SQL = 'INSERT INTO DispositionLog (Study_id,SamplePop_id,Disposition_id,ReceiptType_id,datLogged,LoggedBy) ' + CHAR(10) +
			'SELECT Study_id,SamplePop_id,Disposition_id,ReceiptType_id,datLogged,LoggedBy ' + CHAR(10) +
			'FROM ' @server + 'QP_Prod.dbo.ETL_DispositionLog_View_Backfill'
EXEC (@SQL)

GO
------------------------------------------------------------------------------------
GO

ALTER TABLE ClientStudySurvey ADD datHCAHPSReportable DATETIME, SurveyType_id INT

GO
------------------------------------------------------------------------------------
GO

 CREATE TABLE [dbo].[Disposition](  
  [Disposition_id] [int] NOT NULL,  
  [strDispositionLabel] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
  [Action_id] [int] NULL,  
  [HCAHPSValue] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
  [strReportLabel] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
  [HCAHPSHierarchy] [int] NULL,  
  CONSTRAINT [PK_Disposition] PRIMARY KEY CLUSTERED   
 (  
  [Disposition_id] ASC  
 ) ON [PRIMARY]  
 ) ON [PRIMARY]  

GO
------------------------------------------------------------------------------------
GO



/***********************************************************************************
								Functions							
***********************************************************************************/

CREATE FUNCTION dbo.ExportCanRun (@Date DATETIME)
RETURNS BIT
AS
BEGIN

DECLARE @Stop INT, @Start INT, @Now INT, @Run BIT


SELECT @Start=CONVERT(INT,strParam_Value) FROM DataMart_Params WHERE strParam_nm='ExportManagerStart'
SELECT @Stop=CONVERT(INT,strParam_Value) FROM DataMart_Params WHERE strParam_nm='ExportManagerStop'

SELECT @Start=ISNULL(@Start,0),
  @Stop=ISNULL(@Stop,0),
  @Now=(DATEPART(hh,@Date)*100)+DATEPART(mi,@Date)

IF @Now>@Stop AND @Now<@Start AND @Start>@Stop SELECT @Run=0
ELSE IF @Now>@Stop AND @Start<@Stop SELECT @Run=0
ELSE IF @Now<@Start AND @Start<@Stop SELECT @Run=0

SELECT @Run=ISNULL(@Run,1)

RETURN @Run

END

GO
-----------------------------------------------------------------------------------------------

/***********************************************************************************
								Stored Procedures							
***********************************************************************************/
GO
ALTER PROCEDURE SP_Extract_Big_Table      
AS      
      
DECLARE @strsql VARCHAR(8000), @study INT, @field VARCHAR(30), @datatype CHAR(1), @length INT      
DECLARE @strsel VARCHAR(2000), @table VARCHAR(200), @user VARCHAR(10), @cnt INT, @SampleSet INT      
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
  ' ''SampleSet_id'',''SampleUnit_id'',''datreportdate'',''strunitselecttype'',' +      
  ' ''numweight'',''study_id'',''survey_id'',''QtrTable'',''datSampleCreate_dt'')'      
EXEC (@strsql)       
       
SET @strsql=' CREATE TABLE s'+LTRIM(STR(@Study))+'.Big_Table_Work (' +      
 ' QtrTable VARCHAR(10), '+--AS ' +      
-- ' convert(varchar(10),(convert(varchar,year(datReportDate))+''_'' ' +      
-- '+convert(varchar,datepart(quarter,datReportDate)))), ' +      
 ' questionform_id INT, datUndeliverable DATETIME, SamplePop_id INT NOT NULL, ' +      
 ' SampleSet_id INT, SampleUnit_id INT NOT NULL, datReportDate DATETIME, ' +      
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
 
GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO

ALTER PROCEDURE SP_Extract_BubbleData          
AS          
          
/**************************************************************************************************************************************************/          
-- Modified 6/24/04 SS -- Identify and include ONLY studies that have a Big_Table_NULL to move data from......           
          
/**************************************************************************************************************************************************/          
SET NOCOUNT ON          
          
DECLARE @Nstrsql NVARCHAR(4000), @strsql VARCHAR(8000), @user VARCHAR(10), @Study INT, @Survey INT, @strfield VARCHAR(42)          
DECLARE @cnt INT, @core INT, @strCore VARCHAR(20), @Server VARCHAR(50), @Gen DATETIME, @complete INT, @notcomplete INT    
    
-- Need ID value for breakoff and complete dispositions (06) and (01) respectively.    
SELECT @notcomplete = disposition_id FROM DISPOSITION WHERE HCAHPSValue = '06'    
SELECT @complete = disposition_Id FROM DISPOSITION WHERE HCAHPSValue = '01'        
          
SELECT @Server=strParam_Value FROM Datamart_Params WHERE strParam_nm='QualPro Server'        
        
SELECT @strsql='EXEC '+@Server+'QP_Prod.dbo.SP_Phase3_QuestionResult_For_Extract'         
        
EXEC (@strsql)         
          
TRUNCATE TABLE QuestionResult_work          
TRUNCATE TABLE Extract_SR_NonQuestion          
          
CREATE TABLE #CoreFlds (strField_nm VARCHAR(20), QstnCore INT, Val INT, bitSingle BIT, bitUsed BIT)          
CREATE TABLE #UpdateBigTable (SamplePop_id INT, TableSchema VARCHAR(10), TableName VARCHAR(200),       
   bitComplete BIT, DaysFromFirstMailing INT, DaysFromCurrentMailing INT, LangID INT)      
-- CREATE TABLE #TableCheck (TableSchema VARCHAR(10), TableName VARCHAR(200))      
         
SELECT @strsql='INSERT INTO QuestionResult_Work (QuestionForm_id, strLithoCode, SamplePop_id, Val, '+CHAR(10)+        
'   SampleUnit_id, QstnCore, datMailed, datImported, Study_id, datGenerated, Survey_id) '+CHAR(10)+        
'SELECT QuestionForm_id, strLithoCode, SamplePop_id, Val, '+CHAR(10)+        
'   SampleUnit_id, QstnCore, datMailed, datImported, Study_id, datGenerated, Survey_id '+CHAR(10)+        
'FROM '+@Server+'QP_Prod.dbo.cmnt_QuestionResult_Work'         
EXEC (@strsql)         
          
--Now to insert into Extract_SR_NonQuestion for the datamart          
--This is used at a later step in the extract          
SELECT @strsql='INSERT INTO Extract_SR_NonQuestion (Study_id, QuestionForm_id, SamplePop_id, SampleUnit_id, '+CHAR(10)+        
'   strLithoCode, SampleSet_id, datReturned, datReportDate, strUnitSelectType, bitComplete, '+CHAR(10)+      
'   DaysFromFirstMailing, DaysFromCurrentMailing, LangID) '+CHAR(10)+        
'SELECT Study_id, QuestionForm_id, SamplePop_id, SampleUnit_id, '+CHAR(10)+        
'   strLithoCode, SampleSet_id, datReturned, datReportDate, strUnitSelectType, bitComplete, '+CHAR(10)+      
'   DaysFromFirstMailing, DaysFromCurrentMailing, LangID '+CHAR(10)+        
'FROM '+@Server+'QP_Prod.dbo.Phase4_NonQuestion_View'        
EXEC (@strsql)         
        
          
--Update bithasResults in clientStudySurvey so the Survey can be accessed via the applications          
UPDATE ClientStudySurvey SET bitHasResults=1          
WHERE Survey_id IN (SELECT DISTINCT Survey_id          
FROM Extract_SR_NonQuestion e, SampleUnit su          
WHERE e.SampleUnit_id=su.SampleUnit_id)          
          
--Delete records we don't want to keep.  They will join to the Sampleremove table.          
DELETE q          
FROM Extract_SR_NonQuestion q, SampleRemove s          
WHERE q.SampleSet_id=s.SampleSet_id          
AND q.SampleUnit_id=s.SampleUnit_id          
AND q.strUnitSelectType=s.strUnitSelectType          
          
SELECT DISTINCT Study_id, QstnCore          
INTO #Study          
FROM QuestionResult_work          
          
--get the distinct QstnCore/Val that are Valid for each Study          
SELECT DISTINCT t.Study_id, t.QstnCore, Val, nummarkcount          INTO #Valid          
FROM #Study t, clientStudySurvey css, Questions q, scales s          
WHERE t.Study_id=css.Study_id          
AND css.Survey_id=q.Survey_id          
AND t.QstnCore=q.QstnCore          
AND q.Survey_id=s.Survey_id          
AND q.scaleid=s.scaleid          
AND q.language=1          
AND q.language=s.language          
          
CREATE INDEX tmpValid ON #Valid (Study_id, QstnCore, Val)          
        
--Log the inValid responses          
INSERT INTO InValid_Entries (QuestionForm_id,strLithoCode,SamplePop_id,Val,SampleUnit_id,QstnCore,datMailed,datImported,Study_id)        
SELECT q.QuestionForm_id,q.strLithoCode,q.SamplePop_id,q.Val,q.SampleUnit_id,q.QstnCore,q.datMailed,q.datImported,q.Study_id        
FROM QuestionResult_Work q LEFT OUTER JOIN #Valid t          
ON q.Study_id=t.Study_id          
AND q.QstnCore=t.QstnCore          
AND (q.Val=t.Val    
OR q.Val-10000=t.Val)-- We add 10000 to any responses that should have been skipped.    
WHERE t.Val IS NULL          
AND q.Val NOT IN (-9,-8,-7)          
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
AND q.Val NOT IN (-9,-8,-7)          
AND q.Val IS NOT NULL          
          
--Delete duplicate returns that are in the same extract          
SELECT SamplePop_id, MIN(strLithoCode) Litho          
INTO #keep          
FROM Extract_SR_NonQuestion          
GROUP BY SamplePop_id, SampleUnit_id          
          
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
        
--Need to Populate datReportDate with the return date for Surveys that report on return date          
--First get the SampleUnits for the given Surveys          
SELECT SampleUnit_id          
INTO #RD          
FROM SampleUnit su, clientStudySurvey css          
WHERE css.strReportDateField='ReturnDate'          
AND css.Survey_id=su.Survey_id          
          
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
          
--loop thru the studies          
WHILE (SELECT COUNT(*) FROM #move)>0          
BEGIN          
          
 SELECT TOP 1 @Study=Study_id FROM #move          
           
 --We will move the records back into a work table and then run the movefromwork          
 SET @strsql='UPDATE b '+CHAR(10)+         
  ' SET b.datReportDate=t.datReportDate '+CHAR(10)+         
  ' FROM S'+CONVERT(VARCHAR,@Study)+'.Big_Table_NULL b, #move t '+CHAR(10)+         
  ' WHERE t.SamplePop_id=b.SamplePop_id '           
 EXEC (@strsql)          
           
 CREATE TABLE #RetColumns (col VARCHAR(42))       
           
 INSERT INTO #RetColumns           
 SELECT sc.name          
 FROM sysobjects so, sysusers su, syscolumns sc          
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
           
 EXEC (@strsql)          
           
 DROP TABLE #RetColumns          
           
 --Delete the records for the Study          
 DELETE #move WHERE Study_id=@Study          
           
--end the loop          
END          
          
--use the movefromwork procedure to put the records in the appropriate table          
EXEC SP_DBM_MoveFromWork 'Big_Table'          
          
--clean up          
DROP TABLE #move          
DROP TABLE #RD          
          
--Loop through the studies to first build the vertical table and then use it to Populate the horizontal table          
WHILE (SELECT COUNT(*) FROM #Study)>0          
BEGIN --loop3          
           
 SET @Study=(SELECT TOP 1 Study_id FROM #Study ORDER BY Study_id)          
           
 SET @user=(SELECT uid FROM SYSUSERS WHERE NAME='s'+CONVERT(VARCHAR,@Study))          
           
 --if the Results already exist, we will just delete the new records          
 --First get rid of the QuestionForms          
 PRINT 'First get rid of the QuestionForms'        
 SET @strsql='IF EXISTS (SELECT * '+char(10)+         
  ' FROM sysobjects  '+char(10)+         
  ' WHERE type=''v''  '+char(10)+         
  ' AND name=''Study_Results_view'' AND uid=('+CHAR(10)+         
  ' SELECT uid  '+char(10)+         
  ' FROM sysusers  '+char(10)+         
  ' WHERE name=''S'+CONVERT(VARCHAR,@Study)+''')) '+char(10)+         
  ' BEGIN '+CHAR(10)+         
  ' DELETE e '+CHAR(10)+         
  ' FROM Extract_SR_NonQuestion e, S'+CONVERT(VARCHAR,@Study)+CHAR(10)+         
  '.Study_Results_View s'+CHAR(10)+         
  ' WHERE e.SamplePop_id=s.SamplePop_id '+CHAR(10)+         
  ' DELETE e '+CHAR(10)+         
  ' FROM QuestionResult_Work e, S'+CONVERT(VARCHAR,@Study)+CHAR(10)+         
  '.Study_Results_View s'+CHAR(10)+         
  ' WHERE e.SamplePop_id=s.SamplePop_id '+CHAR(10)+         
  ' END'          
           
 EXEC (@strsql)          
           
 PRINT 'Deleted duplicates '+CONVERT(VARCHAR,GETDATE())          
           
 --get the reportdate from big_table_view          
 PRINT 'Get the reportdate from big_table_view'        
 set @strsql='UPDATE n '+CHAR(10)+       
  ' SET n.datReportDate=b.datReportDate '+CHAR(10)+         
  ' FROM S'+CONVERT(VARCHAR,@Study)+'.Big_Table_View b, Extract_SR_NonQuestion n '+CHAR(10)+         
  ' WHERE n.Study_id='+CONVERT(VARCHAR,@Study)+CHAR(10)+         
  ' AND n.SamplePop_id=b.SamplePop_id '+CHAR(10)+         
  ' AND n.SampleUnit_id=b.SampleUnit_id '          
           
 EXEC (@strsql)          
       
 -- Populate the bitComplete and daysfrommailing columns in big_table      
 -- Get the values we need to deal with      
 TRUNCATE TABLE #UpdateBigTable      
--  TRUNCATE TABLE #TableCheck      
      
INSERT INTO #UpdateBigTable (SamplePop_id, TableSchema, TableName,       
   bitComplete, DaysFromFirstMailing, DaysFromCurrentMailing, LangID)    
 SELECT SamplePop_id, 'S'+LTRIM(STR(Study_id)) TableSchema, 'Big_Table_'+dbo.YearQtr(datReportDate) TableName,       
   bitComplete, DaysFromFirstMailing, DaysFromCurrentMailing, LangID     
 FROM Extract_SR_NonQuestion      
 WHERE Study_id=@Study      
    
-- This will add the complete/notcomplete dispostion HCAHPS value to the dispostionlog table when we extract a HCAHPS survey (flagged bitcomplete=1/0) to the Datamart    
INSERT INTO DispositionLog (Study_id, Samplepop_id, Disposition_id, Receipttype_id, datLogged, LoggedBy, DaysFromCurrent, DaysFromFirst)    
SELECT study_id, samplepop_id, disposition_id, receipttype, datLogged, Loggedby, DaysFromCurrent, DaysFromFirst     
FROM ( SELECT DISTINCT study_id, samplepop_id, CASE bitComplete WHEN 1 THEN @complete WHEN 0 THEN @notcomplete ELSE NULL END AS disposition_id, 0 AS receipttype, datReturned AS datLogged,    
 '#nrcsql' AS Loggedby, DaysFromCurrentMailing AS DaysFromCurrent, DaysFromFirstMailing  AS DaysFromFirst    
 FROM Extract_SR_NonQuestion WHERE study_id = @Study AND bitComplete IN (1,0)    
     ) t1    
WHERE NOT EXISTS (    
 SELECT * FROM DispositionLog t2     
 WHERE t1.Study_id=t2.Study_id AND t1.SamplePop_id=t2.SamplePop_id AND t1.Disposition_id=t2.Disposition_id AND t1.datLogged=t2.datLogged)    
        
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
      
 -- Now to populate the fields      
 SELECT @strsql=''      
 SELECT @strsql=@strsql+'UPDATE b SET bitComplete=t.bitComplete, DaysFromFirstMailing=t.DaysFromFirstMailing,'+CHAR(10)+      
 ' DaysFromCurrentMailing=t.DaysFromCurrentMailing, LangID=t.LangID'+CHAR(10)+      
 'FROM '+TableSchema+'.'+TableName+' b, #UpdateBigTable t'+CHAR(10)+      
 'WHERE t.SamplePop_id=b.SamplePop_id'+CHAR(10)      
 FROM (SELECT DISTINCT TableSchema, TableName FROM #UpdateBigTable) a      
      
 EXEC (@strsql)      
      
 -- Now to update/populate the RR_ReturnCountByDays table      
 SELECT CONVERT(INT,NULL) Survey_id, SampleSet_id, SampleUnit_id, DaysFromFirstMailing, DaysFromCurrentMailing, COUNT(*) intReturned      
 INTO #Returns      
 FROM Extract_SR_NonQuestion      
 WHERE Study_id=@Study      
 GROUP BY SampleSet_id, SampleUnit_id, DaysFromFirstMailing, DaysFromCurrentMailing      
      
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
 UNION          
 SELECT DISTINCT 'Q'+RIGHT('00000'+CONVERT(VARCHAR,QstnCore),6)+          
  CASE WHEN Val BETWEEN 1 AND 26 THEN CHAR(96+Val) ELSE '' END , QstnCore, Val, 0 , 0          
 FROM #Valid          
 WHERE Study_id=@Study          
 AND numMarkCount>1          
           
 SET NOCOUNT OFF          
           
 IF NOT EXISTS (SELECT * FROM SYSOBJECTS WHERE NAME='Study_Results_Vertical_Work' AND uid=@user)          
           
 BEGIN --loop4          
           
  SET @strsql='CREATE TABLE S'+CONVERT(VARCHAR,@Study)+'.Study_Results_Vertical_Work ('+         
   ' QtrTable VARCHAR(10), SamplePop_id INT, SampleUnit_id INT, strLithoCode VARCHAR(10), SampleSet_id INT, datReturned DATETIME, '+          
   ' QstnCore INT, intResponseVal INT, datReportDate DATETIME, bitComplete BIT) '           
            
  EXEC (@strsql)          
           
 END --loop4          
           
 SET @strsql='INSERT INTO s'+CONVERT(VARCHAR,@Study)+'.Study_Results_Vertical_Work  '+         
  ' (QtrTable, SamplePop_id,SampleUnit_id,strLithoCode,SampleSet_id,datreturned,QstnCore,intresponseVal,datreportdate,bitComplete ) '+         
  ' SELECT dbo.YearQtr(datReportDate), w.SamplePop_id, n.SampleUnit_id, n.strLithoCode, n.Sampleset_id, n.datReturned, QstnCore, Val, datReportDate,bitComplete '+         
  ' FROM QuestionResult_work w, extract_sr_nonQuestion n'+          
  ' where w.Study_id='+CONVERT(VARCHAR,@Study)+          
  ' and w.Study_id=n.Study_id '+          
  ' and w.SamplePop_id=n.SamplePop_id '+        
  ' and w.strLithoCode=n.strLithoCode'          
           
 EXEC (@strsql)          
           
 SET @strsql='CREATE INDEX DedupValues ON S'+CONVERT(VARCHAR,@Study)+'.Study_Results_Vertical_Work (SamplePop_id, SampleUnit_id, QstnCore, intresponseVal)'          
           
 --Need to make sure we only have one response for each SamplePop/SampleUnit/QstnCore combination for single response Questions          
 CREATE TABLE #Dedup (SamplePop_id INT, SampleUnit_id INT, QstnCore INT, datReportDate DATETIME, SampleSet_id INT, datReturned DATETIME, bitComplete BIT)          
           
 --Find the duplicates          
 SET @strsql='INSERT INTO #Dedup select SamplePop_id, SampleUnit_id, w.QstnCore, w.datReportDate, SampleSet_id, datReturned, bitComplete '+CHAR(10)+         
  ' FROM s'+CONVERT(VARCHAR,@Study)+'.Study_Results_Vertical_Work w, #CoreFlds t '+CHAR(10)+         
  ' WHERE w.QstnCore=t.QstnCore '+CHAR(10)+         
  ' AND t.bitSingle=1 '+CHAR(10)+         
  ' GROUP BY SamplePop_id, SampleUnit_id, w.QstnCore, w.datReportDate, SampleSet_id, datReturned, bitComplete HAVING COUNT(*)>1 '          
           
 EXEC (@strsql)          
           
 IF (SELECT COUNT(*) FROM #Dedup)>0          
 BEGIN          
           
 --Delete all duplicate responses.  We will insert new records based on the Values in #Dedup          
 SET @strsql='DELETE w '+CHAR(10)+         
  ' FROM #Dedup t, s'+CONVERT(VARCHAR,@Study)+'.Study_Results_Vertical_Work w '+CHAR(10)+         
  ' WHERE t.SamplePop_id=w.SamplePop_id '+CHAR(10)+         
  ' AND t.SampleUnit_id=w.SampleUnit_id '+CHAR(10)+         
  ' AND t.QstnCore=w.QstnCore '          
           
 EXEC (@strsql)          
           
 --Insert where the SampleUnits match          
 SET @strsql='INSERT INTO s'+convert(varchar,@Study)+'.Study_Results_Vertical_Work '+CHAR(10)+         
  ' SELECT dbo.YearQtr(datReportDate), t.SamplePop_id, t.SampleUnit_id, q.strLithoCode, t.Sampleset_id, '+CHAR(10)+         
  ' t.datReturned, t.QstnCore, Val, t.datReportDate, bitComplete '+CHAR(10)+         
  ' FROM QuestionResult_Work q, #Dedup t '+CHAR(10)+         
  ' WHERE t.SamplePop_id=q.SamplePop_id '+CHAR(10)+         
  ' AND t.SampleUnit_id=q.SampleUnit_id '+CHAR(10)+         
  ' AND t.QstnCore=q.QstnCore '           
           
 EXEC (@strsql)          
           
 SET @strsql='DELETE t '+CHAR(10)+         
  ' FROM #dedup t, s'+convert(varchar,@Study)+'.Study_Results_Vertical_Work w '+CHAR(10)+         
  ' WHERE t.SamplePop_id=w.SamplePop_id '+CHAR(10)+         
  ' AND t.SampleUnit_id=w.SampleUnit_id '+CHAR(10)+         
  ' AND t.QstnCore=w.QstnCore '          
           
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
    ' WHERE t.SamplePop_id=q.SamplePop_id '+CHAR(10)+         
    ' AND t.QstnCore=q.QstnCore '+CHAR(10)+         
    ' AND q.Val>-1 '          
             
   EXEC (@strsql)          
             
   SET @strsql='DELETE t '+CHAR(10)+         
    ' FROM #dedup t, s'+convert(varchar,@Study)+'.Study_Results_Vertical_Work w '+CHAR(10)+         
    ' WHERE t.SamplePop_id=w.SamplePop_id '+CHAR(10)+         
    ' AND t.SampleUnit_id=w.SampleUnit_id '+CHAR(10)+         
    ' AND t.QstnCore=w.QstnCore '          
             
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
    ' WHERE t.SamplePop_id=q.SamplePop_id '+CHAR(10)+         
    ' AND t.QstnCore=q.QstnCore '           
             
   EXEC (@strsql)          
             
   SET @strsql='DELETE t '+CHAR(10)+         
    ' FROM #dedup t, s'+convert(varchar,@Study)+'.Study_Results_Vertical_Work w '+CHAR(10)+         
    ' WHERE t.SamplePop_id=w.SamplePop_id '+CHAR(10)+         
    ' AND t.SampleUnit_id=w.SampleUnit_id '+CHAR(10)+         
    ' AND t.QstnCore=w.QstnCore '          
             
   EXEC (@strsql)          
            
  END          
           
 END          
           
 --Get rid of the temp table before the next loop          
 DROP TABLE #Dedup          
           
 SET @strsql='CREATE INDEX AggValues ON S'+CONVERT(VARCHAR,@Study)+'.Study_Results_Vertical_Work (datReportDate, SampleUnit_id, QstnCore, intresponseVal)'          
 EXEC (@strsql)          
    
 SET @strsql='CREATE INDEX QstnCoreSamplePop ON S'+CONVERT(VARCHAR,@Study)+'.Study_Results_Vertical_Work (QstnCore, SamplePop_id)'          
 EXEC (@strsql)          
           
 IF NOT EXISTS (SELECT * FROM SYSOBJECTS WHERE NAME='Study_Results_Work' AND uid=@user)          
 BEGIN -- SRW loop          
           
 PRINT 'Create '+CONVERT(VARCHAR,@Study)+' table '+CONVERT(VARCHAR,GETDATE())          
           
 SET @strsql='CREATE TABLE S'+CONVERT(VARCHAR,@Study)+'.Study_Results_Work '+         
  ' (QtrTable VARCHAR(10), SamplePop_id INT NOT NULL, SampleUnit_id INT NOT NULL, strLithoCode VARCHAR(10), '+         
  ' SampleSet_id INT, datReturned SMALLDATETIME, datReportDate SMALLDATETIME, bitComplete BIT)'          
           
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
           
 EXEC (@strsql)          
           
 PRINT 'Alter table '+CONVERT(VARCHAR,GETDATE())          
           
 --reinitialize the variable          
 IF (SELECT COUNT(*) FROM #CoreFlds WHERE bitUsed=0)>1          
 SET @strsql='ALTER TABLE S'+CONVERT(VARCHAR,@Study)+'.Study_Results_work ADD '          
 ELSE           
 SET @strsql=''          
           
 END          
           
 UPDATE #CoreFlds SET bitUsed=1 WHERE strField_nm=@strCore          
           
 END  -- Alter loop           
           
 EXEC (@strsql)          
 --PRINT @strsql           
           
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
   EXEC sp_Extract_RespRate @Study, @procpart=2          
           
 ---------------------------------------------------------------------------------------------------------------------------------------------------------          
         
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
          
SELECT @strsql='EXEC '+@Server+'QP_Prod.DBO.SP_DBM_Comments_Extract_to_History'        
EXEC (@strsql)          
          
DROP TABLE #Study          
DROP TABLE #Valid          
DROP TABLE #CoreFlds          
       
GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO

ALTER PROCEDURE dbo.SP_Extract_ApplicationTables
AS
  
-- Modified 5/24/05 SS -- Changed scales refresh to reorder #scales then update scales rather than update then reorder.  

-- creat temp tbl , update joinable records on perm tbl,append on new records,
--**********************************************************************************************
DECLARE @Server VARCHAR(100), @sql VARCHAR(8000)

SELECT @Server=strParam_Value FROM DataMart_Params WHERE strParam_nm='QualPro Server'

CREATE TABLE #CommentTypes (CmntType_id INT,strCmntType_nm VARCHAR(15),
  bitRetired BIT)

SELECT @sql='INSERT INTO #CommentTypes (CmntType_id,strCmntType_nm,bitRetired)
SELECT CmntType_id,strCmntType_nm,bitRetired
FROM '+@Server+'QP_Prod.dbo.CommentTypes'
EXEC (@sql)

UPDATE c
SET c.strCmntType_nm=t.strCmntType_nm,c.bitRetired=t.bitRetired
FROM CommentTypes c,#CommentTypes t
WHERE c.CmntType_id=t.CmntType_id

DELETE t
FROM CommentTypes c,#CommentTypes t
WHERE c.CmntType_id=t.CmntType_id

INSERT INTO CommentTypes (CmntType_id,strCmntType_nm,bitRetired)
SELECT CmntType_id,strCmntType_nm,bitRetired
FROM #CommentTypes

DROP TABLE #CommentTypes

--**********************************************************************************************
CREATE TABLE #CommentValences (CmntValence_id INT,strCmntValence_nm VARCHAR(10),
  bitRetired BIT)

SELECT @sql='INSERT INTO #CommentValences (CmntValence_id,strCmntValence_nm,bitRetired)
SELECT CmntValence_id,strCmntValence_nm,bitRetired
FROM '+@Server+'QP_Prod.dbo.CommentValences'
EXEC (@sql)

UPDATE cv
SET cv.strCmntValence_nm=t.strCmntValence_nm,cv.bitRetired=t.bitRetired
FROM CommentValences cv,#CommentValences t
WHERE cv.CmntValence_id=t.CmntValence_id

DELETE t
FROM CommentValences cv,#CommentValences t
WHERE cv.CmntValence_id=t.CmntValence_id

INSERT INTO CommentValences (CmntValence_id,strCmntValence_nm,bitRetired)
SELECT CmntValence_id,strCmntValence_nm,bitRetired
FROM #CommentValences

DROP TABLE #CommentValences

--**********************************************************************************************

CREATE TABLE #CommentCodes (CmntCode_id INT,CmntSubHeader_id INT,
strCmntCode_nm VARCHAR(100),bitRetired bit,strModifiedby VARCHAR(50),
datModified DATETIME)

SELECT @sql='INSERT INTO #CommentCodes (CmntCode_id,CmntSubHeader_id,strCmntCode_nm,
bitRetired,strModifiedby,datModified)
--Modified the query to combine the SubHeader with the Code.
SELECT CmntCode_id,h.CmntSubHeader_id,strCmntSubHeader_nm+'': ''+strCmntCode_nm,c.bitRetired,
c.strModifiedby,c.datModified
FROM '+@Server+'QP_Prod.dbo.CommentCodes c,'+@Server+'QP_Prod.dbo.CommentSubHeaders h
WHERE c.CmntSubHeader_id=h.CmntSubHeader_id'
EXEC (@sql)

UPDATE c
SET c.CmntSubHeader_id=t.CmntSubHeader_id,c.strCmntCode_nm=t.strCmntCode_nm,
c.bitRetired=t.bitRetired,c.strModifiedby=t.strModifiedby,
c.datModified=t.datModified
FROM CommentCodes c,#CommentCodes t
WHERE c.CmntCode_id=t.CmntCode_id

DELETE t
FROM CommentCodes c,#CommentCodes t
WHERE c.CmntCode_id=t.CmntCode_id

INSERT INTO CommentCodes (CmntCode_id,CmntSubHeader_id,strCmntCode_nm,bitRetired,
strModifiedby,datModified)
SELECT CmntCode_id,CmntSubHeader_id,strCmntCode_nm,bitRetired,
strModifiedby,datModified
FROM #CommentCodes

DROP TABLE #CommentCodes


--**********************************************************************************************
-- listing of tables in each Study

CREATE TABLE #MetaTable (Table_id INT,strTable_nm VARCHAR(20),strTable_dsc VARCHAR(80),
Study_id INT,bitUsesAddress BIT)

SELECT @sql='INSERT INTO #MetaTable (Table_id,strTable_nm,strTable_dsc,Study_id,
bitUsesAddress)     
SELECT Table_id,strTable_nm,strTable_dsc,Study_id,bitUsesAddress
FROM '+@Server+'QP_Prod.dbo.MetaTable'
EXEC (@sql)

UPDATE m
SET m.strTable_nm=t.strTable_nm,m.strTable_dsc=t.strTable_dsc,
m.Study_id=t.Study_id,m.bitUsesAddress=t.bitUsesAddress
FROM MetaTable m,#MetaTable t
WHERE m.Table_id=t.Table_id

DELETE t
FROM MetaTable m,#MetaTable t
WHERE m.Table_id=t.Table_id

INSERT INTO MetaTable (Table_id,strTable_nm,strTable_dsc,Study_id,
bitUsesAddress)
SELECT Table_id,strTable_nm,strTable_dsc,Study_id,bitUsesAddress
FROM #MetaTable

DROP TABLE #MetaTable

--**********************************************************************************************
-- Add and new users (new studies based upon contents of MetaTable.
EXEC SP_Extract_AddUsers

--**********************************************************************************************

-- list of availble Fields that can be added to Study specific tables
CREATE TABLE #MetaField (Field_id INT,strField_nm VARCHAR(20),
strField_dsc VARCHAR(80),FieldGroup_id INT,strFieldDataType CHAR(1),
intFieldLength INT,strFieldEditMask VARCHAR(20),intSpecialField_cd INT,
strFieldShort_nm CHAR(8),bitSysKey BIT,bitPhase1Field bit,
intAddrCleanCode INT,intAddrCleanGroup INT)

SELECT @sql='INSERT INTO #MetaField (Field_id,strField_nm,strField_dsc,FieldGroup_id,
strFieldDataType,intFieldLength,strFieldEditMask,intSpecialField_cd,
strFieldShort_nm,bitSysKey,bitPhase1Field,intAddrCleanCode,intAddrCleanGroup)
SELECT Field_id,strField_nm,strField_dsc,FieldGroup_id,
strFieldDataType,intFieldLength,strFieldEditMask,intSpecialField_cd,
strFieldShort_nm,bitSysKey,bitPhase1Field,intAddrCleanCode,intAddrCleanGroup
FROM '+@Server+'QP_Prod.dbo.MetaField'
EXEC (@sql)

UPDATE m
--SET m.strField_nm=t.strField_nm ,m.strField_dsc=t.strField_dsc,
SET m.strField_nm=t.strField_nm,
m.FieldGroup_id=t.FieldGroup_id,m.strFieldDataType=t.strFieldDataType,
m.intFieldlength=t.intFieldlength,m.strFieldEditMask=t.strFieldEditMask,
m.intSpecialField_cd=t.intSpecialField_cd,m.strFieldShort_nm=t.strFieldShort_nm,
m.bitSysKey=t.bitSysKey,m.bitPhase1Field=t.bitPhase1Field,
m.intAddrCleanCode=t.intAddrCleanCode,m.intAddrCleanGroup=t.intAddrCleanGroup
FROM MetaField m,#MetaField t
WHERE m.Field_id=t.Field_id

DELETE t
FROM MetaField m,#MetaField t
WHERE m.Field_id=t.Field_id

INSERT INTO MetaField (Field_id,strField_nm,strField_dsc,FieldGroup_id,
strFieldDataType,intFieldLength,strFieldEditMask,intSpecialField_cd,
strFieldShort_nm,bitSysKey,bitPhase1Field,intAddrCleanCode,intAddrCleanGroup)
SELECT Field_id,strField_nm,strField_dsc,FieldGroup_id,
strFieldDataType,intFieldLength,strFieldEditMask,intSpecialField_cd,
strFieldShort_nm,bitSysKey,bitPhase1Field,intAddrCleanCode,intAddrCleanGroup
FROM #MetaField

DROP TABLE #MetaField


--**********************************************************************************************

-- listing of what Fields are in what table as it exists in Qualisys

CREATE TABLE #MetaStructure (Table_id INT,Field_id INT,bitKeyField_flg BIT,
bitUserField_flg BIT,bitMatchField_flg BIT,bitPostedField_flg BIT,Study_id INT)

SELECT @sql='INSERT INTO #MetaStructure (Table_id,Field_id,bitKeyField_flg,bitUserField_flg,
bitMatchField_flg,bitPostedField_flg,Study_id)
SELECT Table_id,Field_id,bitKeyField_flg,bitUserField_flg,bitMatchField_flg,
bitPostedField_flg,Study_id
FROM '+@Server+'QP_Prod.dbo.WEB_MetaStructure_Veiw'
EXEC (@sql)

UPDATE ms
SET ms.bitKeyField_flg=t.bitKeyField_flg,ms.bitUserField_flg=t.bitUserField_flg,
ms.bitMatchField_flg=t.bitMatchField_flg,ms.bitPostedField_flg=t.bitPostedField_flg,
ms.Study_id=t.Study_id
FROM MetaStructure ms,#MetaStructure t
WHERE ms.Table_id=t.Table_id
AND ms.Field_id=t.Field_id

DELETE t
FROM MetaStructure ms,#MetaStructure t
WHERE ms.Table_id=t.Table_id
AND ms.Field_id=t.Field_id

--if we are adding records for a new Study,we need to add the default computed columns
SELECT DISTINCT Study_id,MIN(Table_id) Table_id
INTO #comp
FROM #MetaStructure
GROUP BY Study_id

--DELETE studies that we are just adding new Fields
DELETE c
FROM #comp c,MetaStructure m
WHERE c.Study_id=m.Study_id
--and Field_id in (2,17)

--insert the two default computed Fields
INSERT INTO MetaStructure (Table_id,Field_id,bitKeyField_flg,bitUserField_flg,
bitMatchField_flg,bitPostedField_flg,Study_id,bitCalculated,strFormula,bitAvailableFilter)
SELECT Table_id,Field_id,0,0,0,1,Study_id,1,strFormulaDefault,1
FROM #comp c,MetaField m
WHERE m.Field_id IN (2,17)

--drop the temp table
DROP TABLE #comp

INSERT INTO MetaStructure (Table_id,Field_id,bitKeyField_flg,bitUserField_flg,
bitMatchField_flg,bitPostedField_flg,Study_id)
SELECT Table_id,Field_id,bitKeyField_flg,bitUserField_flg,bitMatchField_flg,
bitPostedField_flg,Study_id
FROM #MetaStructure

DROP TABLE #MetaStructure

--**********************************************************************************************

CREATE TABLE #Client (Client_id INT,strClient_nm VARCHAR(40))

-- list of Clients in qualisys
SELECT @sql='INSERT INTO #Client (Client_id,strClient_nm)
SELECT Client_id,strClient_nm
FROM '+@Server+'QP_Prod.dbo.Client'
EXEC (@sql)

UPDATE c
SET c.strClient_nm=t.strClient_nm
FROM #Client t,Client c
WHERE t.Client_id=c.Client_id

DELETE t
FROM #Client t,Client c
WHERE t.Client_id=c.Client_id

INSERT INTO Client (Client_id,strClient_nm)
SELECT Client_id,strClient_nm
FROM #Client

DROP TABLE #Client

--**********************************************************************************************
-- list of Studys and Surveys and acct dir / and the reporting Field


CREATE TABLE #ClientStudySurvey (strClient_NM VARCHAR(40),strStudy_NM VARCHAR(10), strQSurvey_NM VARCHAR(42), strSurvey_NM VARCHAR(42),  
Client_ID INT,Study_id INT,Survey_ID INT,AD VARCHAR(42),strReportDateField VARCHAR(42), datHCAHPSReportable DATETIME, SurveyType_id INT)  

SELECT @sql='INSERT INTO #ClientStudySurvey (strClient_nm,strStudy_nm,strQSurvey_nm,strSurvey_nm,Client_id,Study_id,Survey_id,ad,  
 strReportDateField, datHCAHPSReportable, SurveyType_id)  
SELECT DISTINCT RTRIM(LTRIM(strClient_nm)),RTRIM(LTRIM(strStudy_nm)),RTRIM(LTRIM(strQSurvey_nm)),RTRIM(LTRIM(strSurvey_nm)),Client_id,Study_id,Survey_id,strntlogin_nm,  
 strReportDateField, datHCAHPSReportable, SurveyType_id FROM '+@Server+'QP_Prod.dbo.WEB_ClientStudySurvey_View'  
EXEC (@sql)  

UPDATE c  
SET c.strClient_nm=t.strClient_nm,c.strStudy_nm=t.strStudy_nm,c.strQSurvey_nm=t.strQSurvey_nm,c.strSurvey_nm=t.strSurvey_nm,c.ad=t.ad,  
 c.strReportDateField=t.strReportDateField,c.Client_id=t.Client_id,c.Study_id=t.Study_id, c.datHCAHPSReportable = t.datHCAHPSReportable, c.SurveyType_id = t.SurveyType_id 
FROM #ClientStudySurvey t,ClientStudySurvey c  
WHERE t.Survey_id=c.Survey_id         
  
DELETE t  
FROM #ClientStudySurvey t,ClientStudySurvey c  
WHERE t.Survey_id=c.Survey_id  
  
INSERT INTO ClientStudySurvey (strClient_nm,strStudy_nm,strQSurvey_nm,strSurvey_nm,Client_id,Study_id,Survey_id,ad,  
 strReportDateField,bitHasResults, datHCAHPSReportable, SurveyType_id)  
SELECT DISTINCT strClient_nm,strStudy_nm,strQSurvey_nm,strSurvey_nm,Client_id,Study_id,Survey_id,ad,  
 strReportDateField,0, datHCAHPSReportable, SurveyType_id 
FROM #ClientStudySurvey  
  
DROP TABLE #ClientStudySurvey  
        
--**********************************************************************************************
-- list of Valid Questions for any given Survey


CREATE TABLE #Questions (Survey_id INT,Language INT,Scaleid INT,Label VARCHAR(60),QstnCore INT,
   Section_id INT,Item INT,subSection INT,numMarkCount INT,strQuestionLabel VARCHAR(60),strFullQuestion VARCHAR(6000),
   bitMeanable BIT,strSection_nm VARCHAR(500))

SELECT @sql='INSERT INTO #Questions (Survey_id,Language,Scaleid,Label,QstnCore,Section_id,Item,subSection,numMarkCount,strQuestionLabel,
   strFullQuestion,bitMeanable,strSection_nm)
SELECT Survey_id,Language,Scaleid,RTRIM(LTRIM(Label)),QstnCore,Section_id,Item,subSection,numMarkCount,
   RTRIM(LTRIM(Label)),strfullquestion,bitMeanable,strSection_nm
FROM '+@Server+'QP_Prod.dbo.WEB_Questions_View'
EXEC (@sql)

CREATE INDEX tmpq ON #Questions (Survey_id,QstnCore,Language)

UPDATE q
SET q.Label=t.Label,q.Scaleid=t.Scaleid,q.Section_id=t.Section_id,q.Item=t.Item,
q.subSection=t.subSection,q.numMarkCount=t.numMarkCount,
q.strQuestionLabel=t.strQuestionLabel,q.strFullQuestion=t.strFullQuestion,
q.bitMeanable=t.bitMeanable,q.strSection_nm=t.strSection_nm
FROM #Questions t,Questions q
WHERE t.Survey_id=q.Survey_id
AND t.QstnCore=q.QstnCore
AND t.Language=q.Language
      
DELETE t
FROM #Questions t,Questions q
WHERE t.Survey_id=q.Survey_id
AND t.QstnCore=q.QstnCore
AND t.Language=q.Language

SELECT DISTINCT Study_id,QstnCore
INTO #qstnwork
FROM #Questions t,ClientStudySurvey c
WHERE t.Survey_id=c.Survey_id

DELETE t
FROM #qstnwork t,Questions q,ClientStudySurvey c
WHERE t.Study_id=c.Study_id
AND c.Survey_id=q.Survey_id
AND t.QstnCore=q.QstnCore

DECLARE @st INT,@sql2 VARCHAR(2000)

SELECT TOP 1 @st=Study_id FROM #qstnwork

WHILE @@ROWCOUNT > 0
BEGIN

 CREATE TABLE #rollup (Dimension_id INT,QstnCore INT)

 SET @sql2='IF NOT EXISTS (SELECT * '+CHAR(10)+
   ' FROM sysobjects so,sysusers su '+CHAR(10)+
   ' WHERE so.name=''QuestionRollup'' '+CHAR(10)+
   ' AND so.uid=su.uid '+CHAR(10)+
   ' AND su.name=''S'+CONVERT(VARCHAR,@st)+''') '+CHAR(10)+
   ' CREATE TABLE S'+CONVERT(VARCHAR,@st)+'.QuestionRollup ( '+CHAR(10)+
   ' Dimension_id INT,QstnCore INT)'

 EXEC (@sql2)

 TRUNCATE TABLE #rollup

 INSERT INTO #rollup
 SELECT DISTINCT Dimension_id,qr.QstnCore
 FROM QuestionRollup qr,ClientStudySurvey c,#qstnwork q
 WHERE c.Study_id=@st
 AND q.QstnCore=qr.QstnCore

 SET @sql2='INSERT INTO S' + CONVERT(VARCHAR,@st) + '.QuestionRollup ' + CHAR(10) +
  ' SELECT Dimension_id,QstnCore FROM #rollup'

 EXEC (@sql2)

 DROP TABLE #rollup

 DELETE #qstnwork WHERE Study_id=@st

 SELECT TOP 1 @st=Study_id FROM #qstnwork

END

INSERT INTO Questions (Survey_id,Language,Scaleid,Label,QstnCore,Section_id,Item,subSection,numMarkCount,strQuestionLabel,strFullQuestion,
   bitMeanable,strSection_nm)
SELECT DISTINCT Survey_id,Language,Scaleid,Label,QstnCore,Section_id,Item,subSection,numMarkCount,strQuestionLabel,strFullQuestion,
   bitMeanable,strSection_nm
FROM #Questions

DROP TABLE #qstnwork
DROP TABLE #Questions

--Now to make sure all Labels are updated.
CREATE TABLE #ql (QstnCore INT, strQstnLabel VARCHAR(100))

SELECT @sql='INSERT INTO #ql
SELECT QstnCore, strQstnLabel
FROM '+@Server+'QP_Prod.dbo.QuestionLabel'
EXEC (@sql)

UPDATE q
SET q.strQuestionLabel=strQstnLabel, q.Label=strQstnLabel
FROM Questions q,#ql ql
WHERE q.QstnCore=ql.QstnCore

DROP TABLE #ql
  
----------
CREATE TABLE #Scales (Survey_id INT,Language INT,Scaleid INT,Val INT,Label VARCHAR(60), strScaleLabel VARCHAR(60),bitMissing BIT,max_ScaleOrder INT, ScaleOrder INT)
  
SELECT @sql='INSERT INTO #Scales (Survey_id,Language,Scaleid,Val,Label,strScaleLabel,bitMissing, max_ScaleOrder, ScaleOrder)
 SELECT DISTINCT Survey_id,Language,QPC_id,Val,RTRIM(LTRIM(Label)),RTRIM(LTRIM(Label)),Missing,NULL max_ScaleOrder,ScaleOrder 
FROM '+@Server+'QP_Prod.dbo.WEB_Scales_View'
EXEC (@sql)

CREATE INDEX tmps ON #Scales (Survey_id,Language,Scaleid,Val)
  
EXEC SP_Extract_ScaleRefresh
  
BEGIN TRAN

 UPDATE s
 SET s.Label=t.Label,s.strScaleLabel=t.strScaleLabel,s.bitMissing=t.bitMissing,
  s.ScaleOrder=t.ScaleOrder
 FROM #Scales t,Scales s
 WHERE t.Survey_id=s.Survey_id
 AND t.Language=s.Language
 AND t.Scaleid=s.Scaleid
 AND t.Val=s.Val

 IF @@ERROR <> 0
 BEGIN
  ROLLBACK TRAN
  RETURN
 END

 DELETE t     
 FROM #Scales t,Scales s
 WHERE t.Survey_id=s.Survey_id
 AND t.Language=s.Language
 AND t.Val=s.Val
 AND t.Scaleid=s.Scaleid

 IF @@ERROR <> 0
 BEGIN
  ROLLBACK TRAN
  RETURN
 END

 DELETE t      
 FROM #Scales t, (SELECT Survey_id,Language,Scaleid,Val FROM #Scales GROUP BY Survey_id,Language,Scaleid,Val HAVING COUNT(*)>1) b      
 WHERE t.Survey_id=b.Survey_id      
 AND t.Language=b.Language      
 AND t.Scaleid=b.Scaleid      
 AND t.Val=b.Val      
      
 IF @@ERROR <> 0
 BEGIN
  ROLLBACK TRAN
  RETURN
 END
      
 INSERT INTO Scales (Survey_id,Language,Scaleid,Val,Label,strScaleLabel,bitMissing,max_ScaleOrder,ScaleOrder)
  SELECT DISTINCT Survey_id,Language,Scaleid,Val,Label,strScaleLabel,bitMissing,max_ScaleOrder,ScaleOrder
  FROM #Scales

 IF @@ERROR <> 0
 BEGIN
  ROLLBACK TRAN
 RETURN
 END

 DROP TABLE #Scales

 IF @@ERROR <> 0
 BEGIN
  ROLLBACK TRAN
  RETURN
 END

COMMIT TRAN 
----------  

-- Set numMarkCount equal to the maximun scale Value.
SELECT q.Survey_id,QstnCore,MAX(Val) numMarkCount
INTO #nmc
FROM Questions q,Scales s
WHERE q.numMarkCount>1       
AND q.Survey_id=s.Survey_id
AND q.Scaleid=s.Scaleid
GROUP BY q.Survey_id,QstnCore

UPDATE q
SET q.numMarkCount=t.numMarkCount
FROM Questions q,#nmc t
WHERE q.Survey_id=t.Survey_id
AND q.QstnCore=t.QstnCore

DROP TABLE #nmc

CREATE TABLE #SamplePlan (SamplePlan_ID INT,ROOTSAMPLEUNIT_ID INT,EMPLOYEE_ID INT,Survey_ID INT,DATCREATE_DT DATETIME)

SELECT @sql='INSERT INTO #SamplePlan (SamplePlan_ID,ROOTSAMPLEUNIT_ID,EMPLOYEE_ID,Survey_ID,DATCREATE_DT)
SELECT DISTINCT SamplePlan_ID,ROOTSAMPLEUNIT_ID,EMPLOYEE_ID,Survey_ID,DATCREATE_DT 
FROM '+@Server+'QP_Prod.dbo.SamplePlan'
EXEC (@sql)

DELETE t
FROM #SamplePlan t,SamplePlan s
WHERE t.Survey_id=s.Survey_id

INSERT INTO SamplePlan (SamplePlan_ID,ROOTSAMPLEUNIT_ID,EMPLOYEE_ID,Survey_ID,DATCREATE_DT)
SELECT DISTINCT SamplePlan_ID,ROOTSAMPLEUNIT_ID,EMPLOYEE_ID,Survey_ID,DATCREATE_DT
FROM #SamplePlan

DROP TABLE #SamplePlan

-- EXEC '+@Server+'QP_ProD.DBO.SP_DBM_Populate_ReportingHierarchy

-- Update (t)SampleUnit ************************************************************************************************************
CREATE TABLE #SampleUnit (SampleUnit_id INT,ParentSampleUnit_id INT,strSampleUnit_nm VARCHAR(42),Survey_id INT,
 Study_id INT,strUnitSelectType CHAR(1),intLevel INT,strLevel_nm VARCHAR(20), bitSuppress BIT,
 bitHCAHPS BIT, MedicareNumber VARCHAR(20), MedicareName varchar(45), 
 strFacility_nm VARCHAR(100), City VARCHAR(42), State CHAR(2), Country VARCHAR(42), 
 strRegion_nm VARCHAR(42), AdmitNumber INT, BedSize INT, bitPeds BIT, bitTeaching BIT, 
 bitTrauma BIT, bitReligious BIT, bitGovernment BIT, bitRural BIT, bitForProfit BIT, 
 bitRehab BIT, bitCancerCenter BIT, bitPicker BIT, bitFreeStanding BIT, AHA_id INT)
      
SELECT @sql='INSERT INTO #SampleUnit (SampleUnit_id,ParentSampleUnit_id,strSampleUnit_nm,Survey_id,Study_id, 
  strUnitSelectType,intLevel,strLevel_nm,bitSuppress,bitHCAHPS,MedicareNumber, MedicareName,strFacility_nm,
  City,State,Country,strRegion_nm,AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,bitGovernment,
  bitRural,bitForProfit,bitRehab,bitCancerCenter,bitPicker,bitFreeStanding,AHA_id)
SELECT SampleUnit_id,ParentSampleUnit_id,RTRIM(LTRIM(strSampleUnit_nm)),Survey_id,Study_id,
  strUnitSelectType,intLevel,RTRIM(LTRIM(strLevel_nm)),bitSuppress,bitHCAHPS,MedicareNumber, 
  MedicareName,strFacility_nm,City,State,Country,strRegion_nm,AdmitNumber,BedSize,bitPeds,
  bitTeaching,bitTrauma,bitReligious,bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,
  bitPicker,bitFreeStanding,AHA_id
FROM '+@Server+'QP_Prod.dbo.WEB_SampleUnits_View'
EXEC (@sql)

UPDATE su
SET su.strSampleUnit_nm=t.strSampleUnit_nm, su.Study_id=t.Study_id, su.Survey_id=t.Survey_id,       
 su.strUnitSelectType=CASE WHEN su.strUnitSelectType <> t.strUnitSelectType THEN 'B' ELSE
 su.strUnitSelectType END, su.bitSuppress=t.bitSuppress,bitHCAHPS=t.bitHCAHPS,
 MedicareNumber=t.MedicareNumber,MedicareName=t.MedicareName,strFacility_nm=t.strFacility_nm,
 City=t.City,State=t.State,Country=t.Country,strRegion_nm=t.strRegion_nm,AdmitNumber=t.AdmitNumber,
 BedSize=t.BedSize,bitPeds=t.bitPeds,bitTeaching=t.bitTeaching,bitTrauma=t.bitTrauma,
 bitReligious=t.bitReligious,bitGovernment=t.bitGovernment,bitRural=t.bitRural,
 bitForProfit=t.bitForProfit,bitRehab=t.bitRehab,bitCancerCenter=t.bitCancerCenter,
 bitPicker=t.bitPicker,bitFreeStanding=t.bitFreeStanding,AHA_id=t.AHA_id
FROM SampleUnit su,#SampleUnit t
WHERE t.SampleUnit_id=su.SampleUnit_id

DELETE t
FROM SampleUnit su,#SampleUnit t
WHERE t.SampleUnit_id=su.SampleUnit_id

-- Figure out which plans need to be reordered
CREATE TABLE #ReOrderSampleUnit (Survey_id INT,SamplePlan_id INT)

INSERT INTO #ReOrderSampleUnit (Survey_id,SamplePlan_id)
SELECT DISTINCT su.Survey_id,SamplePlan_id
FROM #SampleUnit su,SamplePlan sp
WHERE su.Survey_id=sp.Survey_id

INSERT INTO SampleUnit (SampleUnit_id,ParentSampleUnit_id,strSampleUnit_nm,Survey_id,Study_id,
 strUnitSelectType,intLevel,strLevel_nm,bitSuppress,bitHCAHPS,MedicareNumber, MedicareName,strFacility_nm,
 City,State,Country,strRegion_nm,AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,bitGovernment,
 bitRural,bitForProfit,bitRehab,bitCancerCenter,bitPicker,bitFreeStanding,AHA_id)
SELECT SampleUnit_id,ParentSampleUnit_id,strSampleUnit_nm,Survey_id,Study_id,strUnitSelectType,
 intLevel,strLevel_nm,bitSuppress,bitHCAHPS,MedicareNumber, MedicareName,strFacility_nm,
 City,State,Country,strRegion_nm,AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,bitGovernment,
 bitRural,bitForProfit,bitRehab,bitCancerCenter,bitPicker,bitFreeStanding,AHA_id
FROM #SampleUnit

DROP TABLE #SampleUnit

-- Update (t)SampleUnitSection ************************************************************************************************************
-- Create #temp table to hold '+@Server+'(t)SampleUnitSection records
CREATE TABLE #SampleUnitSection (SampleUnitSection_id INT,SampleUnit_id INT,
  SelQstnsSection INT,SelQstnsSurvey_id INT)

-- Gather all '+@Server+'(t)SampleUnitSection records into a #temp table
SELECT @sql='INSERT INTO #SampleUnitSection (SampleUnitSection_id,SampleUnit_id,
  SelQstnsSection,SelQstnsSurvey_id)
SELECT SampleUnitSection_id,SampleUnit_id,SelQstnsSection,SelQstnsSurvey_id
FROM '+@Server+'QP_Prod.dbo.SampleUnitSection'
EXEC (@sql)
  
BEGIN TRAN
 DELETE SampleUnitSection WHERE selqstnsSurvey_id  NOT IN (4,5,7) -- 4,5,7 are Demo Site info

 IF @@ERROR <> 0
 BEGIN
  ROLLBACK TRAN
  RETURN
 END

 -- DELETE (#t)SampleUnitSection where not exists (f)SampleUnit_id in (t)SampleUnit
 -- Chg 5/2/03 SJS

 DELETE FROM #SampleUnitSection WHERE NOT EXISTS (SELECT * FROM SampleUnit su WHERE #SampleUnitSection.sampleunit_id=su.sampleunit_id)
 IF @@ERROR <> 0
 BEGIN
  ROLLBACK TRAN
  RETURN
 END

 -- Insert net (#t)SampleUnitSection records in (t)SampleUnitSection
 INSERT INTO SampleUnitSection (SampleUnitSection_id,SampleUnit_id,
  SelQstnsSection,SelQstnsSurvey_id)
 SELECT SampleUnitSection_id,SampleUnit_id,SelQstnsSection,SelQstnsSurvey_id
 FROM #SampleUnitSection

 IF @@ERROR <> 0
 BEGIN
  ROLLBACK TRAN
  RETURN
 END

 -- Commit the transaction (sections) that did NOT produce an error (@@ERROR<>0)
COMMIT TRAN
  
DROP TABLE #SampleUnitSection

--Now to reorder (t)SampleUnit***********************************************************************************************************************
DECLARE @SamplePlan INT

WHILE (SELECT COUNT(*) FROM #ReOrderSampleUnit) > 0
BEGIN

SET @SamplePlan=(SELECT TOP 1 SamplePlan_id FROM #ReOrderSampleUnit ORDER BY SamplePlan_id)

SET @sql='EXEC SP_Extract_SampleUnits '+CONVERT(VARCHAR,@SamplePlan)

EXEC (@sql)

DELETE #ReOrderSampleUnit WHERE SamplePlan_id=@SamplePlan

END

DROP TABLE #ReOrderSampleUnit

CREATE TABLE #SampleUnit_Full (SAMPLEUNIT_ID INT,CRITERIASTMT_ID INT,SamplePlan_ID INT,PARENTSAMPLEUNIT_ID INT,STRSAMPLEUNIT_NM VARCHAR(42),INTTARGETRETURN INT,INTMINCONFIDENCE INT,
INTMAXMARGIN INT,NUMINITRESPONSERATE INT,NUMRESPONSERATE INT,REPORTING_HIERARCHY_ID INT)

SELECT @sql='INSERT INTO #SampleUnit_Full (SAMPLEUNIT_ID,CRITERIASTMT_ID,SamplePlan_ID,PARENTSAMPLEUNIT_ID,STRSAMPLEUNIT_NM,INTTARGETRETURN,INTMINCONFIDENCE,INTMAXMARGIN,NUMINITRESPONSERATE,
NUMRESPONSERATE,REPORTING_HIERARCHY_ID)
SELECT DISTINCT SAMPLEUNIT_ID,CRITERIASTMT_ID,SamplePlan_ID,PARENTSAMPLEUNIT_ID,STRSAMPLEUNIT_NM,INTTARGETRETURN,INTMINCONFIDENCE,INTMAXMARGIN,NUMINITRESPONSERATE,NUMRESPONSERATE,
REPORTING_HIERARCHY_ID FROM '+@Server+'QP_Prod.dbo.sampleunit'
EXEC (@sql)

UPDATE s
SET s.criteriastmt_id=t.criteriastmt_id,s.SamplePlan_ID=t.SamplePlan_ID,s.PARENTSAMPLEUNIT_ID=t.PARENTSAMPLEUNIT_ID,
 s.STRSAMPLEUNIT_NM=t.STRSAMPLEUNIT_NM,s.INTTARGETRETURN=t.INTTARGETRETURN,s.INTMINCONFIDENCE=t.INTMINCONFIDENCE,
 s.INTMAXMARGIN=t.INTMAXMARGIN,s.NUMINITRESPONSERATE=t.NUMINITRESPONSERATE,s.NUMRESPONSERATE=t.NUMRESPONSERATE,
 s.REPORTING_HIERARCHY_ID=t.REPORTING_HIERARCHY_ID
FROM #SampleUnit_Full t,SampleUnit_Full s
WHERE t.sampleunit_id=s.sampleunit_id

DELETE t
FROM #SampleUnit_Full t,SampleUnit_Full s
WHERE t.sampleunit_id=s.sampleunit_id

INSERT INTO SampleUnit_Full (SAMPLEUNIT_ID,CRITERIASTMT_ID,SamplePlan_ID,PARENTSAMPLEUNIT_ID,STRSAMPLEUNIT_NM,INTTARGETRETURN,INTMINCONFIDENCE,INTMAXMARGIN,NUMINITRESPONSERATE,
NUMRESPONSERATE,REPORTING_HIERARCHY_ID)
SELECT DISTINCT SAMPLEUNIT_ID,CRITERIASTMT_ID,SamplePlan_ID,PARENTSAMPLEUNIT_ID,STRSAMPLEUNIT_NM,INTTARGETRETURN,INTMINCONFIDENCE,INTMAXMARGIN,NUMINITRESPONSERATE,NUMRESPONSERATE,
REPORTING_HIERARCHY_ID
FROM #SampleUnit_Full

DROP TABLE #SampleUnit_Full

CREATE TABLE #Unscaled_Questions (Survey_id INT,QstnCore INT,Label VARCHAR(60),strCmntorhand CHAR(1))

SELECT @sql='INSERT INTO #Unscaled_Questions (Survey_id,QstnCore,Label,strCmntorhand)
SELECT Survey_id,QstnCore,questionLabel,strCmntorhand
FROM '+@Server+'QP_Prod.dbo.Comments_Unscaled_Questions_View'
EXEC (@sql)

UPDATE u
SET u.Label=t.Label,u.strCmntorhand=t.strCmntorhand
FROM #Unscaled_Questions t,Unscaled_Questions u
WHERE t.Survey_id=u.Survey_id
AND t.QstnCore=u.QstnCore

DELETE t
FROM #Unscaled_Questions t,Unscaled_Questions u
WHERE t.Survey_id=u.Survey_id
AND t.QstnCore=u.QstnCore

INSERT INTO Unscaled_Questions (Survey_id,QstnCore,Label,strCmntorhand)
SELECT Survey_id,QstnCore,Label,strCmntorhand
FROM #Unscaled_Questions  

DROP TABLE #Unscaled_Questions

-- removed 20030730-sjs (see sp_extract_resprate)
-- CREATE TABLE #RespRateCount (Survey_id INT,SampleSet_id INT,SampleUnit_id INT,
--  intSampled INT,intUD INT,intReturned INT,datSampleCreate_dt DATETIME)
--
-- INSERT INTO #RespRateCount (Survey_id,SampleSet_id,SampleUnit_id,intSampled,
--   intUD,intReturned,datSampleCreate_dt)
-- SELECT Survey_id,SampleSet_id,SampleUnit_id,intSampled,intUD,intReturned,
--   datSampleCreate_dt
-- FROM '+@Server+'QP_Prod.dbo.RespRateCount
--
-- BEGIN TRAN
--
--  DELETE RespRateCount
-- 
--  INSERT INTO RespRateCount (Survey_id,SampleSet_id,SampleUnit_id,intSampled,
--intUD,intReturned,datSampleCreate_dt)
--  SELECT Survey_id,SampleSet_id,SampleUnit_id,intSampled,intUD,intReturned,
--datSampleCreate_dt
--  FROM #RespRateCount
--
-- COMMIT TRAN
--
-- DROP TABLE #RespRateCount

CREATE TABLE #Global_Attribute (Survey_id INT,Study_id INT,strContactName VARCHAR(40),
 strContactPhone VARCHAR(25),intQuarter INT)

SELECT @sql='INSERT INTO #Global_Attribute (Survey_id,Study_id,strContactName,strContactPhone,intQuarter)
SELECT Survey_id,Study_id,strContactName,strContactPhone,intQuarter
FROM '+@Server+'QP_Prod.dbo.WEB_Global_Attribute_View'
EXEC (@sql)

TRUNCATE TABLE Global_Attribute

INSERT INTO Global_Attribute (Survey_id,Study_id,strContactName,strContactPhone,intQuarter)
SELECT Survey_id,Study_id,strContactName,strContactPhone,intQuarter
FROM #Global_Attribute

DROP TABLE #Global_Attribute

CREATE TABLE #Employee_Access (strNTLogin_nm VARCHAR(20),Study_id INT)

SELECT @sql='INSERT INTO #Employee_Access (strNTLogin_nm,Study_id)
SELECT strNTLogin_nm,Study_id  
FROM '+@Server+'QP_Prod.dbo.WEB_Employee_Access_View'
EXEC (@sql)

TRUNCATE TABLE Employee_Access      

INSERT INTO Employee_Access (strNTLogin_nm,Study_id)
SELECT strNTLogin_nm,Study_id
FROM #Employee_Access

DROP TABLE #Employee_Access

CREATE TABLE #lu_EmployeeSecurity (strNTLogin_nm VARCHAR(20))

SELECT @sql='INSERT INTO #lu_EmployeeSecurity (strNTLogin_nm)
SELECT strNTLogin_nm
FROM '+@Server+'QP_Prod.dbo.Employee'
EXEC (@sql)

DELETE t
FROM #lu_EmployeeSecurity t,lu_EmployeeSecurity l
WHERE t.strNTLogin_nm=l.strNTlogin_nm

INSERT INTO lu_EmployeeSecurity (strNTLogin_nm,strPassword,dtiExpirationDate,
  strPassword1,numLastPasswordUsed)
SELECT strNTLogin_nm,strNTLogin_nm,DATEADD(MONTH,1,GETDATE()),strNTLogin_nm,1
FROM #lu_EmployeeSecurity

DROP TABLE #lu_EmployeeSecurity

--Make sure all SampleUnits have an intOrder Value
EXEC SP_DBM_ReorderSampleUnit


-- Determine if any Questions are both single and multiple response and set the nummarkcnt Value to the maximum Value for the question. (bd/ss 11/21/03)  
SELECT Study_id,QstnCore,MAX(numMarkCount) AS nmk       
INTO #temp       
FROM Questions q,ClientStudySurvey c       
WHERE q.Survey_id=c.Survey_id       
GROUP BY Study_id,QstnCore  
      
UPDATE q       
SET q.numMarkCount=t.nmk       
FROM #temp t,Questions q,ClientStudySurvey c       
WHERE t.Study_id=c.Study_id       
AND c.Survey_id=q.Survey_id       
AND t.QstnCore=q.QstnCore       
AND nmk<>numMarkCount

-- Update (t)Disposition ************************************************************************************************************

CREATE TABLE #Disposition (
Disposition_id INT,
strDispositionLabel VARCHAR(100),
Action_id INT,
HCAHPSValue VARCHAR(20),
strReportLabel VARCHAR(100),
HCAHPSHierarchy INT
)

SELECT @sql='INSERT INTO #Disposition (Disposition_id,strDispositionLabel,Action_id,
  HCAHPSValue,strReportLabel,HCAHPSHierarchy)
SELECT Disposition_id,strDispositionLabel,Action_id,HCAHPSValue,strReportLabel,HCAHPSHierarchy
FROM '+@Server+'QP_Prod.dbo.Disposition'
EXEC (@sql)

UPDATE d
SET strDispositionLabel=t.strDispositionLabel, Action_id=t.Action_id, HCAHPSValue=t.HCAHPSValue,
    strReportLabel=t.strReportLabel, HCAHPSHierarchy=t.HCAHPSHierarchy
FROM #Disposition t, Disposition d
WHERE t.Disposition_id=d.Disposition_id

DELETE t
FROM #Disposition t, Disposition d
WHERE t.Disposition_id=d.Disposition_id

INSERT INTO Disposition (Disposition_id,strDispositionLabel,Action_id,
  HCAHPSValue,strReportLabel,HCAHPSHierarchy)
SELECT Disposition_id,strDispositionLabel,Action_id,HCAHPSValue,strReportLabel,HCAHPSHierarchy
FROM #Disposition

DROP TABLE #Disposition

GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO

CREATE PROCEDURE DCL_SelectHCAHPSClientsStudiesSurveysAndUnitsByUser
@UserName VARCHAR(42)
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT css.Client_ID, css.strClient_NM
FROM ClientStudySurvey css, Employee_Access ea, SampleUnit su
WHERE ea.strNTLogin_nm=@UserName
AND ea.Study_id=css.Study_id
AND css.Survey_id=su.Survey_id
AND su.bitHCAHPS=1
AND su.bitSuppress=0
GROUP BY css.Client_ID, css.strClient_NM
ORDER BY strClient_NM

SELECT css.Client_ID, css.Study_ID, css.strStudy_NM --, css.AD
FROM ClientStudySurvey css, Employee_Access ea, SampleUnit su
WHERE ea.strNTLogin_nm=@UserName
AND ea.Study_id=css.Study_id
AND css.Survey_id=su.Survey_id
AND su.bitHCAHPS=1
AND su.bitSuppress=0
GROUP BY css.Client_ID, css.Study_ID, css.strStudy_NM --, css.AD
ORDER BY strStudy_NM

SELECT css.Client_ID, css.Study_ID, css.Survey_ID, css.strSurvey_NM, css.strQSurvey_NM, datHCAHPSReportable
FROM ClientStudySurvey css, Employee_Access ea, SampleUnit su
WHERE ea.strNTLogin_nm=@UserName
AND ea.Study_id=css.Study_id
AND css.Survey_id=su.Survey_id
AND su.bitHCAHPS=1
AND su.bitSuppress=0
GROUP BY css.Client_ID, css.Study_ID, css.Survey_ID, css.strSurvey_NM, css.strQSurvey_NM, datHCAHPSReportable
ORDER BY strQSurvey_NM

SELECT css.Client_ID, css.Study_ID, css.Survey_ID, css.strSurvey_NM, css.strQSurvey_NM, 
  SampleUnit_id, strSampleUnit_nm, ParentSampleUnit_id, MedicareNumber, bitHCAHPS
FROM ClientStudySurvey css, Employee_Access ea, SampleUnit su
WHERE ea.strNTLogin_nm=@UserName
AND ea.Study_id=css.Study_id
AND css.Survey_id=su.Survey_id
AND su.bitHCAHPS=1
AND su.bitSuppress=0
GROUP BY css.Client_ID, css.Study_ID, css.Survey_ID, css.strSurvey_NM, css.strQSurvey_NM,
  SampleUnit_id, strSampleUnit_nm, ParentSampleUnit_id, MedicareNumber, bitHCAHPS
ORDER BY strSampleUnit_nm

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO

--Modified 6/1/6 BGD No longer assign samplepops to exportsets.  
--   Added ExportSetTypeID
ALTER PROCEDURE DCL_ExportInsertExportSet
@Name VARCHAR(100),
@SurveyId INT,
@ExportSetTypeID INT,
@EncounterStartDate DATETIME,
@EncounterEndDate DATETIME,
@CreatedEmployeeName VARCHAR(50),
@SampleUnitID INT
AS

INSERT INTO ExportSet (ExportSetName, Survey_id, Study_id, EncounterStartDate, 
    EncounterEndDate, ReportDateField, UpdatedDate, CreatedEmployeeName, ExportSetTypeID,
    SampleUnit_id)
SELECT @Name, @SurveyId, Study_id, @EncounterStartDate, 
    @EncounterEndDate, strReportDateField, GETDATE(), @CreatedEmployeeName, @ExportSetTypeID,
    @SampleUnitID
FROM ClientStudySurvey css
WHERE css.Survey_id=@SurveyId

SELECT SCOPE_IDENTITY()

GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO

DROP PROCEDURE DCL_ExportAddSamplePopsToExportSet

GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO

ALTER PROCEDURE DCL_SelectExportSetsBySurveyId
@SurveyId INT,
@ExportSetTypeID INT,
@CreationFilterStartDate DATETIME,
@CreationFilterEndDate DATETIME
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT ExportSetId,ExportSetName,Survey_id,EncounterStartDate,EncounterEndDate,
       ReportDateField, UpdatedDate,CreatedEmployeeName,ExportSetTypeID,SampleUnit_id
FROM ExportSet
WHERE Survey_id=@SurveyId
AND DeletedDate IS NULL
AND UpdatedDate>=ISNULL(@CreationFilterStartDate, '1/1/1900')
AND UpdatedDate<=ISNULL(DATEADD(DAY,1,@CreationFilterEndDate),'1/1/3000')
AND ExportSetTypeID=@ExportSetTypeID
ORDER BY UpdatedDate DESC, ExportSetName

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO

ALTER PROCEDURE DCL_SelectExportSetsByStudyId
@StudyId INT,
@ExportSetTypeID INT,
@CreationFilterStartDate DATETIME,
@CreationFilterEndDate DATETIME
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT ExportSetId,ExportSetName,es.Survey_id,EncounterStartDate,EncounterEndDate,
       ReportDateField,UpdatedDate,CreatedEmployeeName,ExportSetTypeID,SampleUnit_id
FROM ExportSet es, ClientStudySurvey css
WHERE css.Study_id=@StudyId
AND css.Survey_id=es.Survey_id
AND DeletedDate IS NULL
AND UpdatedDate>=ISNULL(@CreationFilterStartDate, '1/1/1900')
AND UpdatedDate<=ISNULL(DATEADD(DAY,1,@CreationFilterEndDate),'1/1/3000')
AND ExportSetTypeID=@ExportSetTypeID
ORDER BY UpdatedDate DESC, ExportSetName

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO

ALTER PROCEDURE DCL_SelectExportSetsByClientId
@ClientId INT,
@ExportSetTypeID INT,
@CreationFilterStartDate DATETIME,
@CreationFilterEndDate DATETIME
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT ExportSetId,ExportSetName,es.Survey_id,EncounterStartDate,EncounterEndDate,
       ReportDateField,UpdatedDate,CreatedEmployeeName,ExportSetTypeID,SampleUnit_id
FROM ExportSet es, ClientStudySurvey css
WHERE css.Client_id=@ClientId
AND css.Survey_id=es.Survey_id
AND DeletedDate IS NULL
AND UpdatedDate>=ISNULL(@CreationFilterStartDate, '1/1/1900')
AND UpdatedDate<=ISNULL(DATEADD(DAY,1,@CreationFilterEndDate),'1/1/3000')
AND ExportSetTypeID=@ExportSetTypeID
ORDER BY UpdatedDate DESC, ExportSetName

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO

ALTER PROCEDURE DCL_SelectExportSet
@ExportSetId INT
AS

SELECT ExportSetId,ExportSetName,Survey_id,EncounterStartDate,EncounterEndDate,
       ReportDateField,UpdatedDate,CreatedEmployeeName,ExportSetTypeID,SampleUnit_id
FROM ExportSet
WHERE ExportSetId=@ExportSetId
AND DeletedDate IS NULL

GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO

ALTER PROCEDURE DCL_SelectExportSetsByExportFileId 
@exportFileId int
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT es.ExportSetId,ExportSetName,Survey_id,EncounterStartDate,EncounterEndDate,
       ReportDateField,UpdatedDate,CreatedEmployeeName,ExportSetTypeID,SampleUnit_id
FROM ExportFileExportSet efes, ExportSet es
WHERE exportFileId=@exportFileId
AND efes.exportSetId=es.ExportSetId

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO

CREATE PROCEDURE DCL_SelectExportSetsBySampleUnitId
@SampleUnitId INT,
@ExportSetTypeID INT,
@CreationFilterStartDate DATETIME,
@CreationFilterEndDate DATETIME
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT ExportSetId,ExportSetName,Survey_id,EncounterStartDate,EncounterEndDate,
       ReportDateField, UpdatedDate,CreatedEmployeeName,ExportSetTypeID,SampleUnit_id
FROM ExportSet
WHERE SampleUnit_id=@SampleUnitId
AND DeletedDate IS NULL
AND UpdatedDate>=ISNULL(@CreationFilterStartDate, '1/1/1900')
AND UpdatedDate<=ISNULL(DATEADD(DAY,1,@CreationFilterEndDate),'1/1/3000')
AND ExportSetTypeID=@ExportSetTypeID
ORDER BY UpdatedDate DESC, ExportSetName

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO

ALTER PROCEDURE dbo.DCL_InsertExportFile 
	@RecordCount INT,
	@Employee VARCHAR(50),
	@FilePath VARCHAR(256),
	@FilePartsCount INT,
	@FileType VARCHAR(12),
	@ExportFileGUID UNIQUEIDENTIFIER,
	@ReturnsOnly BIT,
	@DirectsOnly BIT,
	@ScheduledExport BIT,
	@Successful BIT,
	@ErrorMessage VARCHAR(200),
	@StackTrace VARCHAR(6000),
	@IsAwaitingNotification BIT
AS

INSERT INTO ExportFile (RecordCount,CreatedDate,CreatedEmployeeName,FilePath,
  FilePartsCount,FileType,ExportFileGUID,bitScheduledExport,bitSuccessful,
  ErrorMessage,StackTrace,ReturnsOnly,DirectsOnly, bitNeedsNotification)
SELECT @RecordCount,GETDATE(),@Employee,@FilePath,
  @FilePartsCount,@FileType,@ExportFileGUID,@ScheduledExport,@Successful,
  @ErrorMessage,@StackTrace,@ReturnsOnly,@DirectsOnly, @IsAwaitingNotification

SELECT SCOPE_IDENTITY()

GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO

CREATE PROCEDURE DCL_InsertScheduledExport 
@RunDate DATETIME,
@IncludeOnlyReturns BIT,
@IncludeOnlyDirects BIT,
@FileType INT,
@UserName VARCHAR(42)
AS

INSERT INTO ExportSchedule (RunDate,ReturnsOnly,DirectsOnly,FileType,ScheduledBy,ScheduledDate)
SELECT @RunDate,@IncludeOnlyReturns,@IncludeOnlyDirects,@FileType,@UserName,GETDATE()

SELECT SCOPE_IDENTITY()

GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO

CREATE PROCEDURE DCL_InsertScheduledExportSet
@ScheduledExportId INT,
@ExportSetId INT
AS

INSERT INTO ExportScheduleExportSet (ExportScheduleID,ExportSetID)
SELECT @ScheduledExportId, @ExportSetId

GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO

CREATE PROCEDURE DCL_DeleteScheduledExport
@ScheduledExportID INT
AS

BEGIN TRANSACTION

DELETE ExportScheduleExportSet
WHERE ExportScheduleID=@ScheduledExportID

IF @@ERROR<>0
BEGIN

  ROLLBACK TRANSACTION
  RAISERROR ('Problem deleting ExportScheduleExportSet.',18,1)
  RETURN

END

DELETE ExportSchedule
WHERE ExportScheduleID=@ScheduledExportID

IF @@ERROR<>0
BEGIN

  ROLLBACK TRANSACTION
  RAISERROR ('Problem deleting ExportSchedule.',18,1)
  RETURN

END

COMMIT TRANSACTION

GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO

CREATE PROCEDURE DCL_SelectNextScheduledExport 
AS


DECLARE @ExportScheduleID INT

SELECT TOP 1 @ExportScheduleID=ExportScheduleID
FROM ExportSchedule
WHERE StartedDate IS NULL
AND RunDate<GETDATE()
ORDER BY RunDate,ExportScheduleID

IF @@ROWCOUNT=0
BEGIN

  RETURN

END

BEGIN TRANSACTION

UPDATE ExportSchedule
SET StartedDate=GETDATE()
WHERE ExportScheduleID=@ExportScheduleID
AND StartedDate IS NULL

--If no records were updated, then get the next scheduled export
WHILE @@ROWCOUNT=0
BEGIN

  SELECT TOP 1 @ExportScheduleID=ExportScheduleID
  FROM ExportSchedule
  WHERE StartedDate IS NULL
  AND RunDate<GETDATE()
  ORDER BY RunDate,ExportScheduleID

  --If nothing more to work on, exit the proc
  IF @@ROWCOUNT=0
  BEGIN

    ROLLBACK TRANSACTION
    RETURN

  END

  UPDATE ExportSchedule
  SET StartedDate=GETDATE()
  WHERE ExportScheduleID=@ExportScheduleID
  AND StartedDate IS NULL

END

COMMIT TRANSACTION

SELECT ExportScheduleID,RunDate,ReturnsOnly,DirectsOnly,FileType,ScheduledBy,ScheduledDate,StartedDate
FROM ExportSchedule
WHERE ExportScheduleID=@ExportScheduleID

SELECT eses.ExportScheduleId,es.ExportSetID,es.ExportSetName,es.Survey_id,es.SampleUnit_id,
  es.EncounterStartDate,es.EncounterEndDate,es.ReportDateField,es.UpdatedDate,
  es.CreatedEmployeeName,es.ExportSetTypeID
FROM ExportScheduleExportSet eses, ExportSet es
WHERE eses.ExportScheduleID=@ExportScheduleID
AND eses.ExportSetID=es.ExportSetID

GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO

CREATE PROCEDURE DCL_SelectScheduledExport
@ScheduledExportId INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT ExportScheduleID,RunDate,ReturnsOnly,DirectsOnly,FileType,ScheduledBy,ScheduledDate,StartedDate
FROM ExportSchedule
WHERE ExportScheduleID=@ScheduledExportId

SELECT eses.ExportScheduleId,es.ExportSetID,es.ExportSetName,es.Survey_id,es.SampleUnit_id,
  es.EncounterStartDate,es.EncounterEndDate,es.ReportDateField,es.UpdatedDate,
  es.CreatedEmployeeName,es.ExportSetTypeID
FROM ExportScheduleExportSet eses, ExportSet es
WHERE eses.ExportScheduleID=@ScheduledExportId
AND eses.ExportSetID=es.ExportSetID

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO

CREATE PROCEDURE SP_Extract_DispositionLog
AS
DECLARE @Server VARCHAR(100), @sql VARCHAR(8000)

SELECT @Server=strParam_Value FROM DataMart_Params WHERE strParam_nm='QualPro Server'

CREATE TABLE #DispositionLog (
Study_id INT NOT NULL,
SamplePop_id INT NOT NULL,
Disposition_id INT NOT NULL,
ReceiptType_id INT NOT NULL,
datLogged DATETIME NOT NULL,
LoggedBy VARCHAR(42) NOT NULL,
DaysFromCurrent INT,
DaysFromFirst INT
)

SELECT @sql='INSERT INTO #DispositionLog (Study_id,SamplePop_id,Disposition_id,ReceiptType_id,
 datLogged,LoggedBy,DaysFromCurrent,DaysFromFirst)
SELECT Study_id,SamplePop_id,Disposition_id,ReceiptType_id,
 datLogged,LoggedBy,DaysFromCurrent,DaysFromFirst
FROM '+@Server+'QP_Prod.dbo.ETL_DispositionLog_View'
EXEC (@sql)

DELETE t
FROM #DispositionLog t, DispositionLog dl
WHERE t.Study_id=dl.Study_id
AND t.SamplePop_id=dl.SamplePop_id
AND t.Disposition_id=dl.Disposition_id
AND t.datLogged=dl.datLogged

INSERT INTO DispositionLog (Study_id,SamplePop_id,Disposition_id,ReceiptType_id,
 datLogged,LoggedBy,DaysFromCurrent,DaysFromFirst)
SELECT Study_id,SamplePop_id,Disposition_id,ReceiptType_id,
 datLogged,LoggedBy,DaysFromCurrent,DaysFromFirst
FROM #DispositionLog

DROP TABLE #DispositionLog

GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO

CREATE PROCEDURE DCL_SelectScheduledExports 
@StartDate DATETIME, 
@EndDate DATETIME
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT @EndDate=DATEADD(Minute,-1,@EndDate+1)

CREATE TABLE #ES (ExportScheduleID INT)

INSERT INTO #ES (ExportScheduleID)
SELECT ExportScheduleID
FROM ExportSchedule
WHERE StartedDate IS NULL
AND RunDate BETWEEN @StartDate and @EndDate

SELECT es.ExportScheduleID,es.RunDate,es.ReturnsOnly,es.DirectsOnly,
 es.FileType,es.ScheduledBy,es.ScheduledDate,es.StartedDate
FROM ExportSchedule es, #ES t
WHERE es.ExportScheduleID=t.ExportScheduleID

SELECT eses.ExportScheduleId,es.ExportSetID,es.ExportSetName,es.Survey_id,es.SampleUnit_id,
  es.EncounterStartDate,es.EncounterEndDate,es.ReportDateField,es.UpdatedDate,
  es.CreatedEmployeeName,es.ExportSetTypeID
FROM ExportScheduleExportSet eses, ExportSet es, #ES t
WHERE eses.ExportScheduleID=t.ExportScheduleID
AND eses.ExportSetID=es.ExportSetID

DROP TABLE #ES

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO

CREATE PROCEDURE DCL_SelectScheduledExportsByClient
@StartDate DATETIME, 
@EndDate DATETIME,
@ClientID INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT @EndDate=DATEADD(Minute,-1,@EndDate+1)

CREATE TABLE #ES (ExportScheduleID INT)

INSERT INTO #ES (ExportScheduleID)
SELECT es.ExportScheduleID
FROM ExportSchedule es, ExportScheduleExportSet eses, ExportSet e, ClientStudySurvey css
WHERE StartedDate IS NULL
AND RunDate BETWEEN @StartDate and @EndDate
AND es.ExportScheduleID=eses.ExportScheduleID
AND eses.ExportSetID=e.ExportSetID
AND e.Study_id=css.Study_id
AND css.Client_id=@ClientID
GROUP BY es.ExportScheduleID

SELECT es.ExportScheduleID,es.RunDate,es.ReturnsOnly,es.DirectsOnly,
 es.FileType,es.ScheduledBy,es.ScheduledDate,es.StartedDate
FROM ExportSchedule es, #ES t
WHERE es.ExportScheduleID=t.ExportScheduleID

SELECT eses.ExportScheduleId,es.ExportSetID,es.ExportSetName,es.Survey_id,es.SampleUnit_id,
  es.EncounterStartDate,es.EncounterEndDate,es.ReportDateField,es.UpdatedDate,
  es.CreatedEmployeeName,es.ExportSetTypeID
FROM ExportScheduleExportSet eses, ExportSet es, #ES t
WHERE eses.ExportScheduleID=t.ExportScheduleID
AND eses.ExportSetID=es.ExportSetID

DROP TABLE #ES

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO

CREATE PROCEDURE DCL_SelectScheduledExportsByStudy
@StartDate DATETIME, 
@EndDate DATETIME,
@StudyID INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT @EndDate=DATEADD(Minute,-1,@EndDate+1)

CREATE TABLE #ES (ExportScheduleID INT)

INSERT INTO #ES (ExportScheduleID)
SELECT es.ExportScheduleID
FROM ExportSchedule es, ExportScheduleExportSet eses, ExportSet e
WHERE StartedDate IS NULL
AND RunDate BETWEEN @StartDate and @EndDate
AND es.ExportScheduleID=eses.ExportScheduleID
AND eses.ExportSetID=e.ExportSetID
AND e.Study_id=@StudyID
GROUP BY es.ExportScheduleID

SELECT es.ExportScheduleID,es.RunDate,es.ReturnsOnly,es.DirectsOnly,
 es.FileType,es.ScheduledBy,es.ScheduledDate,es.StartedDate
FROM ExportSchedule es, #ES t
WHERE es.ExportScheduleID=t.ExportScheduleID

SELECT eses.ExportScheduleId,es.ExportSetID,es.ExportSetName,es.Survey_id,es.SampleUnit_id,
  es.EncounterStartDate,es.EncounterEndDate,es.ReportDateField,es.UpdatedDate,
  es.CreatedEmployeeName,es.ExportSetTypeID
FROM ExportScheduleExportSet eses, ExportSet es, #ES t
WHERE eses.ExportScheduleID=t.ExportScheduleID
AND eses.ExportSetID=es.ExportSetID

DROP TABLE #ES

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO

CREATE PROCEDURE [dbo].[DCL_SelectScheduledExportsBySurvey]
@StartDate DATETIME, 
@EndDate DATETIME,
@SurveyID INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT @EndDate=DATEADD(Minute,-1,@EndDate+1)

CREATE TABLE #ES (ExportScheduleID INT)

INSERT INTO #ES (ExportScheduleID)
SELECT es.ExportScheduleID
FROM ExportSchedule es, ExportScheduleExportSet eses, ExportSet e
WHERE StartedDate IS NULL
AND RunDate BETWEEN @StartDate and @EndDate
AND es.ExportScheduleID=eses.ExportScheduleID
AND eses.ExportSetID=e.ExportSetID
AND e.Survey_id=@SurveyID
GROUP BY es.ExportScheduleID

SELECT es.ExportScheduleID,es.RunDate,es.ReturnsOnly,es.DirectsOnly,
 es.FileType,es.ScheduledBy,es.ScheduledDate,es.StartedDate
FROM ExportSchedule es, #ES t
WHERE es.ExportScheduleID=t.ExportScheduleID

SELECT eses.ExportScheduleId,es.ExportSetID,es.ExportSetName,es.Survey_id,es.SampleUnit_id,
  es.EncounterStartDate,es.EncounterEndDate,es.ReportDateField,es.UpdatedDate,
  es.CreatedEmployeeName,es.ExportSetTypeID
FROM ExportScheduleExportSet eses, ExportSet es, #ES t
WHERE eses.ExportScheduleID=t.ExportScheduleID
AND eses.ExportSetID=es.ExportSetID

DROP TABLE #ES

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO

CREATE PROCEDURE DCL_UpdateScheduledExport
@ExportScheduleID INT,
@RunDate DATETIME
AS

UPDATE ExportSchedule
SET RunDate=@RunDate
WHERE ExportScheduleID=@ExportScheduleID

GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO
CREATE PROCEDURE DCL_SelectSampleUnit
@SampleUnitId INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT SampleUnit_id, strSampleUnit_nm, Survey_id, ParentSampleUnit_id, MedicareNumber, bitHCAHPS
FROM SampleUnit su
WHERE SampleUnit_id = @SampleUnitId

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF
GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO

CREATE PROCEDURE DCL_SelectSampleUnitsByMedicareNumber
@MedicareNumber VARCHAR(20)
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT SampleUnit_id, strSampleUnit_nm, Survey_id, ParentSampleUnit_id, MedicareNumber, bitHCAHPS
FROM SampleUnit su
WHERE MedicareNumber = @MedicareNumber

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO

/*
Business Purpose: 
This procedure is used to calculate the number of eligible discharges.  It
is used IN the header record of the CMS export

Created:  06/22/2006 by DC

Modified:

*/  
CREATE PROCEDURE [dbo].[DCL_ExportFileCMSAvailableCount]
	@exportsets VARCHAR(2000),
	@exportfileguid UNIQUEIDENTIFIER
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @Server VARCHAR(100), @sql VARCHAR(8000)

SELECT @Server=strParam_Value FROM DataMart_Params WHERE strParam_nm='QualPro Server'

DECLARE @sel VARCHAR(8000), @sampleunit_id INT, @startdate DATETIME, @enddate DATETIME, @reportdatefield varchar(100)
CREATE TABLE #exportsets (sampleunit_id INT, startdate DATETIME, enddate DATETIME, reportdatefield varchar(100))
CREATE TABLE #counts (n INT)

SET @sel='INSERT INTO #exportsets (sampleunit_id, startdate, enddate, reportdatefield)
SELECT DISTINCT sampleunit_id, encounterstartdate, encounterenddate, reportdatefield
FROM exportset
WHERE exportsetid IN ('+ @exportsets+')'

exec (@sel)

SELECT TOP 1 @sampleunit_id=sampleunit_Id, @startdate=startdate, @enddate=enddate,
			 @reportdatefield=reportdatefield
FROM #exportsets

WHILE @@rowcount>0
BEGIN

	SET @sel='INSERT INTO #counts (n)
			exec ' + @Server+'qp_prod.dbo.Export_SampleunitAvailableCount ' + 
			convert(varchar,@sampleunit_id) +',' +
			'''' + convert(varchar,@startdate) + '''' + ',' +
			'''' + convert(varchar,@enddate) + '''' + ',' +
			'''' + @reportdatefield + ''''

	--print (@sel)
	exec (@sel)

	DELETE FROM #exportsets WHERE sampleunit_id=@sampleunit_Id
		AND startdate=@startdate
		AND enddate=@enddate
		AND reportdatefield=@reportdatefield

	SELECT TOP 1 @sampleunit_id=sampleunit_Id, @startdate=startdate, @enddate=enddate,
			 @reportdatefield=reportdatefield
	FROM #exportsets
END

INSERT INTO ExportSetCMSAvailableCount (exportfileGUID, availablecount)
SELECT @exportfileguid, SUM(n)
FROM #Counts

DROP TABLE #Counts
DROP TABLE #exportsets

GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO

ALTER PROCEDURE DBO.DCL_SelectExportFilesByExportSetId  
@ExportSetId INT  
AS  

--Get the export files that have been created with the given export set ID
SELECT ExportFileId
INTO #Files
FROM ExportFileExportSet
WHERE ExportSetId = @ExportSetId

--Select back all the export files
SELECT ef.ExportFileId, RecordCount, CreatedDate, CreatedEmployeeName, FilePath, FilePartsCount, FileType, bitScheduledExport, ReturnsOnly, DirectsOnly, bitSuccessful, ErrorMessage, StackTrace, bitNeedsNotification
FROM ExportFile ef, #Files f
WHERE ef.ExportFileId=f.ExportFileId  

--Now get any export sets that were used in those files
SELECT efes.ExportFileId, efes.ExportSetId
INTO #ExportSets
FROM ExportFileExportSet efes, #Files f
WHERE efes.ExportFileId=f.ExportFileId

--Select back all the export sets used for the list of files retrieved
SELECT es2.ExportFileId,es.ExportSetID,es.ExportSetName,es.Survey_id, es.SampleUnit_id,  
  es.EncounterStartDate,es.EncounterEndDate,es.ReportDateField,es.UpdatedDate,  
  es.CreatedEmployeeName,es.ExportSetTypeID  
FROM ExportSet es, #ExportSets es2
WHERE es.ExportSetId=es2.ExportSetId

DROP TABLE #Files
DROP TABLE #ExportSets

GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO

CREATE PROCEDURE DCL_SelectExportFilesAwaitingNotification
AS

--Select all the files that need notfication
SELECT ExportFileId, RecordCount, CreatedDate, CreatedEmployeeName, FilePath, FilePartsCount, FileType, bitScheduledExport, ReturnsOnly, DirectsOnly, bitSuccessful, ErrorMessage, StackTrace, bitNeedsNotification
FROM ExportFile ef
WHERE bitNeedsNotification=1

--Select all the export sets used in files that need notification
SELECT ef.ExportFileId,es.ExportSetID,es.ExportSetName,es.Survey_id, es.SampleUnit_id,  
  es.EncounterStartDate,es.EncounterEndDate,es.ReportDateField,es.UpdatedDate,  
  es.CreatedEmployeeName,es.ExportSetTypeID  
FROM ExportFile ef, ExportFileExportSet efes, ExportSet es
WHERE ef.ExportFileId=efes.ExportFileId
AND efes.ExportSetId=es.ExportSetId
AND ef.bitNeedsNotification=1

GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO

CREATE PROCEDURE DCL_UpdateExportFile
@ExportFileId INT,
@IsAwaitingNotification BIT
AS

UPDATE ExportFile SET bitNeedsNotification = @IsAwaitingNotification
WHERE ExportFileId = @ExportFileId


GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO
ALTER PROCEDURE DBO.DCL_DeleteExportSet  
@ExportSetId INT,  
@DeletionEmployeeName VARCHAR(50)  
AS  

/*-----------------------------
Return Values to select back
1=Success
2=Could not delete because files are scheduled
------------------------------*/
DECLARE @Success INT
DECLARE @FilesScheduledError INT
SET @Success = 1
SET @FilesScheduledError = 2


IF EXISTS (SELECT * 
			FROM ExportSchedule es, ExportScheduleExportSet eses 
			WHERE es.ExportScheduleID=eses.ExportScheduleId 
			AND eses.ExportSetID=@ExportSetId)
BEGIN
	SELECT @FilesScheduledError
END
ELSE
BEGIN
	UPDATE ExportSet  
	SET DeletedDate=GETDATE(), DeletedEmployeeName=@DeletionEmployeeName  
	WHERE ExportSetId=@ExportSetId  

	SELECT @Success
END

GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO
ALTER PROCEDURE [dbo].[DCL_SelectSurvey] 
@SurveyId INT
AS
 
SELECT Survey_id, strSurvey_NM, Study_id, strQSurvey_NM, datHCAHPSReportable
FROM ClientStudySurvey
WHERE Survey_id=@SurveyId
GROUP BY Survey_id, strSurvey_NM, Study_id, strQSurvey_NM, datHCAHPSReportable
ORDER BY strQSurvey_NM

GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO
ALTER PROCEDURE [dbo].[DCL_SelectSurveysbyStudyID] 
@StudyId INT
AS
 
SELECT Survey_id, strSurvey_NM, Study_id, strQSurvey_NM, datHCAHPSReportable
FROM ClientStudySurvey
WHERE study_id=@StudyId
GROUP BY Survey_id, strSurvey_NM, Study_id, strQSurvey_NM, datHCAHPSReportable
ORDER BY strQSurvey_NM

GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO

ALTER PROCEDURE [dbo].[DCL_SelectClientsStudiesAndSurveysByUser] 
@UserName VARCHAR(42)
AS
 
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON
 
SELECT css.Client_ID, css.strClient_NM
FROM ClientStudySurvey css, Employee_Access ea
WHERE ea.strNTLogin_nm=@UserName
AND ea.Study_id=css.Study_id
GROUP BY css.Client_ID, css.strClient_NM
ORDER BY strClient_NM
 
SELECT css.Client_ID, css.Study_ID, css.strStudy_NM --, css.AD
FROM ClientStudySurvey css, Employee_Access ea
WHERE ea.strNTLogin_nm=@UserName
AND ea.Study_id=css.Study_id
GROUP BY css.Client_ID, css.Study_ID, css.strStudy_NM --, css.AD
ORDER BY strStudy_NM
 
SELECT css.Client_ID, css.Study_ID, css.Survey_ID, css.strSurvey_NM, css.strQSurvey_NM, datHCAHPSReportable
FROM ClientStudySurvey css, Employee_Access ea
WHERE ea.strNTLogin_nm=@UserName
AND ea.Study_id=css.Study_id
GROUP BY css.Client_ID, css.Study_ID, css.Survey_ID, css.strSurvey_NM, css.strQSurvey_NM, datHCAHPSReportable
ORDER BY strQSurvey_NM
 
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
SET NOCOUNT OFF

GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO

  
GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO

ALTER PROCEDURE DCL_ExportCreateFile  
@ExportSets VARCHAR(2000),  
@ReturnsOnly BIT,  
@DirectsOnly BIT,  
@ExportFileGUID UNIQUEIDENTIFIER  
AS   
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  
  
--Use the last 12 digits to ensure a unique table name for the temporary storage  
DECLARE @Unique VARCHAR(40)  
SELECT @Unique=RIGHT(CONVERT(VARCHAR(40),@ExportFileGUID),12)  
  
CREATE TABLE #ExportSets2 (  
   ExportSetID INT,  
   Study_id INT,  
   HeaderRecord BIT,  
   Pulled BIT NOT NULL DEFAULT(0)  
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
  
  
DECLARE @sql VARCHAR(8000), @ExportSetID INT, @Table_Schema VARCHAR(20), @Table_Name VARCHAR(200)  
DECLARE @Column_Name VARCHAR(100), @Column_id INT, @CreateHeader BIT, @MedicareName varchar(45)  
DECLARE @MedicareNumber VARCHAR(20), @DisYear INT, @DisMonth INT, @EligibleCount INT   
  
--Put the exportsets into a table  
SELECT @sql='INSERT INTO #ExportSets2 (ExportSetID, Study_id, HeaderRecord)  
SELECT ExportSetID, Study_id, HCAHPSHeaderRecord  
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
  
IF (SELECT COUNT(DISTINCT Client_id)   
     FROM #ExportSets2 t, ClientStudySurvey c  
     WHERE t.Study_id=c.Study_id)<>1  
BEGIN  
  
   RAISERROR ('ExportSets are not for the same client',18,1)  
   GOTO Cleanup  
  
END  
  
--Loop thru the exportsets to create the Export tables.  
SELECT TOP 1 @ExportSetID=ExportSetID  
FROM #ExportSets2  
WHERE Pulled=0  
ORDER BY 1  
  
WHILE @@ROWCOUNT>0  
BEGIN  
  
--   SELECT @sql='INSERT INTO #ExportTables (Table_Schema, Table_Name)   
--   EXEC DCL_ExportCreateFile_Sub '+LTRIM(STR(@ExportSetID))+','+LTRIM(STR(@ReturnsOnly))+','+LTRIM(STR(@DirectsOnly))  
--   INSERT INTO #ExportTables (Table_Schema, Table_Name)   
   EXEC DCL_ExportCreateFile_Sub @ExportSetID, @ReturnsOnly, @DirectsOnly, @ExportFileGUID, @CreateHeader  
     
   UPDATE #ExportSets2  
   SET Pulled=1  
   WHERE ExportSetID=@ExportSetID  
  
   SELECT TOP 1 @ExportSetID=ExportSetID  
   FROM #ExportSets2  
   WHERE Pulled=0  
   ORDER BY 1  
  
END  
  
IF (SELECT COUNT(*) FROM #ExportTables)=0  
BEGIN  
 RAISERROR ('No records exported.',18,1)  
 RETURN  
END  
  
--Log the samplepops  
SELECT @sql=''  
SELECT @sql=@sql+CASE WHEN @sql='' THEN '' ELSE ' UNION ' END+CHAR(10)+  
'SELECT DISTINCT '''+CONVERT(VARCHAR(40),@ExportFileGUID)+''',SampPop,CASE WHEN Rtrn_dt IS NULL THEN 0 ELSE 1 END  
FROM '+Table_Schema+'.'+Table_Name+CHAR(10)  
FROM #ExportTables  
  
SELECT @sql='INSERT INTO ExportFileMember (ExportFileGUID,SamplePop_id,bitIsReturned) '+@sql  
  
EXEC (@sql)  
  
IF @CreateHeader=1  
BEGIN  
  
 --This calls a procedure in Qualisys  
 EXEC DCL_ExportFileCMSAvailableCount @ExportSets, @ExportFileGUID  
  
 --Get the Header information  
 SELECT TOP 1 @MedicareName=MedicareName, @MedicareNumber=MedicareNumber,  
 @DisYear=YEAR(EncounterStartDate), @DisMonth=MONTH(EncounterStartDate)  
 FROM #ExportSets2 t, ExportSet es, SampleUnit su  
 WHERE t.ExportSetID=es.ExportSetID  
 AND es.SampleUnit_id=su.SampleUnit_id  
  
 SELECT @EligibleCount=AvailableCount   
 FROM ExportSetCMSAvailableCount   WHERE ExportFileGUID=@ExportFileGUID  
  
 --Return the header record  
 SELECT @MedicareName MedicareName, @MedicareNumber MedicareNumber,  
 @DisYear DisYear, @DisMonth DisMonth, @EligibleCount NumberEligible,  
 COUNT(*) SampleCount, 1 SampleType, CONVERT(INT,NULL) DSRPSurveyed,   
 CONVERT(INT,NULL) DSRPEligible    
 FROM ExportFileMember  
 WHERE ExportFileGUID=@ExportFileGUID  
  
END  
  
IF (SELECT COUNT(*) FROM #ExportTables)=1   
BEGIN  
 SELECT @sql='SELECT * FROM '+Table_Schema+'.'+Table_Name+' ' FROM #ExportTables  
 EXEC(@sql)  
 GOTO Cleanup  
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
  
   --Initialize the variable  
   SELECT @sql='SELECT'  
  
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
  
   --Add on the FROM clause  
   SELECT @sql=@sql+' FROM '+@Table_Schema+'.'+@Table_Name+' (NOLOCK) '  
  
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
EXEC (@sqldeclare)      
  
Cleanup:  
  
--Get rid of the permanent tables  
SELECT @sql=''  
SELECT @sql=@sql+'DROP TABLE '+Table_Schema+'.'+Table_Name+' ' FROM #ExportTables  
EXEC (@sql)  
  
--Now the temp tables  
DROP TABLE #ExportSets2  
DROP TABLE #ExportTables  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF  

GO
----------------------------------------------------------------------------------
CREATE PROCEDURE SP_Extract_DispositionBigTable  
AS      
       
 -- 8/9/2006 - SJS -      
 -- Created to update the HDisposition disposition column in the BigTable each night during the extract.      
 DECLARE @study VARCHAR(20), @SQL VARCHAR(1000), @rec INT, @BT VARCHAR(50), @study_id INT      

  -- Get distinct list of studies we will be working with      
  CREATE TABLE #AllSP (study_id INT, samplepop_id INT)
  CREATE INDEX ix_AllSP ON #AllSP (samplepop_id)      
  CREATE TABLE #DispoNew (study_id INT, samplepop_id INT)  
  CREATE INDEX ix_DispoNew ON #disponew (samplepop_id)      
  CREATE TABLE #DispoWork (study_id INT, samplepop_id INT, Disposition_id INT, DatLogged DATETIME, DaysFromCurrent INT, DaysFromFirst INT, bitEvaluated BIT)  
  CREATE INDEX ix_DispoWork ON #DispoWork (samplepop_id, disposition_id, datLogged)      
  CREATE TABLE #UpdateBT (rec INT IDENTITY(1,1), study_id INT, survey_id INT, samplepop_id INT, BT VARCHAR(100), bitEvaluated BIT DEFAULT 0)      
  CREATE TABLE #ULoop (BT VARCHAR(100))  
  CREATE TABLE #tblStudy (study_id INT, study VARCHAR(10))      
  CREATE TABLE #Del (study_id INT, samplepop_id INT)  
  CREATE TABLE #Dispo (Study_id INT, SamplePop_id INT, Disposition_id INT, HCAHPSHierarchy INT, HCAHPSValue CHAR(2))        
  CREATE TABLE #SampDispo (Study_id INT, SamplePop_id INT, HCAHPSValue CHAR(2), bitEvaluated BIT DEFAULT 0)        
     
 SET NOCOUNT ON      
 -- GATHER WORK      

INSERT INTO #AllSP (study_id, samplepop_id) SELECT study_id, samplepop_id FROM DispositionLog WHERE bitEvaluated = 0

IF @@ROWCOUNT > 0 
BEGIN
  -- First update DispositionLog for any dispositions that are NOT HCAHPS and have a bitEvaluated = 0 (SET=1)      
  UPDATE dl SET bitEvaluated = 1      
  FROM DispositionLog dl, Disposition d, #AllSP sp
  WHERE dl.disposition_id = d.disposition_id AND dl.samplepop_id = sp.samplepop_id
  and d.HCAHPSValue IS NULL AND dl.bitEvaluated = 0           
  
  -- Update the bitEvaluated flag and set it to 1 for all dispositionlog table having DaysFromFirst > 42 (Don't Fit the HCAHPS Specs)  
  UPDATE dl SET dl.bitEvaluated = 1 FROM DispositionLog dl, #AllSP sp
  WHERE dl.samplepop_id = sp.samplepop_id AND DaysFromFirst > 42 AND bitEvaluated = 0  
      
 -- PROCESS WORK      
 -- Now lets work to update the Big_Table for the work we have identified.      
 
  INSERT INTO #tblStudy (study_id, study) SELECT DISTINCT dl.study_id, 's' + CONVERT(VARCHAR,dl.study_id) AS study FROM dispositionlog dl, #AllSP sp
	WHERE dl.samplepop_id = sp.samplepop_id AND dl.bitEvaluated = 0  
  CREATE CLUSTERED INDEX cix_study ON #tblstudy(study_id)      

  SELECT DISTINCT table_schema + '.' + table_name studytbl, column_name   
  INTO #HAV_HDISPCOL  
  FROM INFORMATION_SCHEMA.COLUMNS c, #tblStudy s
  WHERE c.table_schema = s.study
  AND COLUMN_NAME = 'HDisposition' AND TABLE_NAME NOT LIKE '%VIEW%'  

  -- Find out what base tables are home for the samplepop we will be working with.      
  
  SELECT TOP 1 @study_id = study_id, @study = study FROM #tblStudy    
  WHILE @@ROWCOUNT > 0      
  BEGIN      
  
   -- GET samplepops that have HCAHPS dispositions that need to be evaluated (bitEvaluated = 0)      
   TRUNCATE TABLE #DispoNew  
   INSERT INTO #DispoNew (study_id, samplepop_id)  
   SELECT DISTINCT dl.study_id, dl.samplepop_id  
   FROM DispositionLog dl, #AllSP sp
   WHERE  dl.bitEvaluated = 0 and dl.study_id = @study_id  AND dl.samplepop_id = sp.samplepop_id
         
   -- Find all logged dispositions for samplepops identified in #DispoNew      
   TRUNCATE TABLE #DispoWork  
   INSERT INTO #DispoWork (study_id, samplepop_id, disposition_id, datLogged, DaysFromCurrent, DaysFromFirst, bitEvaluated)  
   SELECT dl.study_id, dl.samplepop_id, dl.disposition_id, dl.datLogged, dl.DaysFromCurrent, dl.DaysFromFirst, dl.bitEvaluated  
   FROM DispositionLog dl, #disponew dn       
   WHERE dl.study_id = dn.study_id and dl.samplepop_id = dn.samplepop_id      
  
    TRUNCATE TABLE #UpdateBT  
    SET @SQL = 'INSERT INTO #UpdateBT (study_id, survey_id, samplepop_id, BT) SELECT DISTINCT n.study_Id, b.survey_id, n.samplepop_id, ''' +   
  @study + '.'' + b.tablename AS BT FROM ' + @study + '.big_table_view b, #DispoNew n WHERE b.samplepop_id = n.samplepop_id'  
 --  print @sql      
    EXEC (@SQL)      
  
   
   -- Update dispostionlog set bitEvaluated = 1 WHERE samplepops belong to a Non-HCAHPS survey      
   TRUNCATE TABLE #DEL  
   
   INSERT INTO #del (study_id, samplepop_id) SELECT u.study_id, u.samplepop_id   
   FROM #updatebt u, clientstudysurvey c WHERE u.survey_id = c.survey_id and c.surveytype_id <> 2 AND u.study_id = @study_id     
   
   INSERT INTO #DEL (study_id, samplepop_id)   
   SELECT study_id, samplepop_id   
   FROM #updatebt u   
   LEFT JOIN #hav_hdispcol hc ON u.bt = hc.studytbl WHERE column_name IS NULL      
   
   -- Update dispostionLog set bitEvaluated = 1 for dispostions that belong to samplepops prior to I1 HCAHPS samplesets (12/1/2005) - They don't have a column to Update      
   UPDATE dl SET dl.bitEvaluated = 1 FROM DispositionLog dl, #del d WHERE dl.samplepop_id = d.samplepop_id AND dl.bitEvaluated = 0   
   
   -- Now delete the samplepops from #updateBT      
   DELETE u FROM #updatebt u, #del d WHERE u.samplepop_id = d.samplepop_id      
   
   
   --Calcuate the current the HCAHPSValue for the samplepop      
   TRUNCATE TABLE #Dispo  
   INSERT INTO #Dispo (Study_id, SamplePop_id, Disposition_id, HCAHPSHierarchy, HCAHPSVALUE)      
   SELECT dw.study_id, dw.SamplePop_id, d.Disposition_id, d.HCAHPSHierarchy, d.HCAHPSValue      
   FROM #dispowork dw, disposition d, #updateBT u        
   WHERE d.Disposition_id=dw.Disposition_id AND dw.samplepop_id = u.samplepop_id AND dw.DaysFromFirst<43        
         
   TRUNCATE TABLE #SampDispo        
   INSERT INTO #SampDispo (Study_id, SamplePop_id, HCAHPSValue)        
   SELECT t.Study_id, t.SamplePop_id, HCAHPSValue        
   FROM #Dispo t, (SELECT SamplePop_id, MIN(HCAHPSHierarchy) HCAHPSHierarchy FROM #Dispo GROUP BY SamplePop_id) a        
   WHERE t.SamplePop_id=a.SamplePop_id        
   AND t.HCAHPSHierarchy=a.HCAHPSHierarchy        
   GROUP BY t.Study_id, t.SamplePop_id, HCAHPSValue        
        
  -- UPDATE BIG_TABLE DISPOSTION      
   -- Loop through each study, and update the Big_Table HCAHPSValue field ONLY if the HCAHPSValue is NOT NULL (Meaning is has a previous value either a default or prior disposition value)      
   TRUNCATE TABLE #ULoop  
   INSERT INTO #ULoop (BT) SELECT DISTINCT BT FROM #UpdateBT WHERE study_id = @study_id  
   SELECT TOP 1 @BT= bt FROM #ULoop       
   WHILE @@ROWCOUNT > 0      
   BEGIN      
           
     -- Only update HCAHPS samplepops      
     SET @SQL = 'UPDATE bt SET bt.HDisposition = sd.HCAHPSValue FROM ' + @BT + ' bt, #SampDispo sd WHERE bt.samplepop_id = sd.samplepop_id AND bt.HDisposition IS NOT NULL'      
  --   PRINT @SQL      
     EXEC (@SQL)      
     UPDATE #sampdispo SET bitEvaluated = 1 FROM #UpdateBT bt, #SampDispo sd WHERE bt.samplepop_id = bt.samplepop_id AND bt.BT = @bt      
    
    
     DELETE FROM #ULoop WHERE @BT= bt   
     SELECT TOP 1 @BT= bt FROM #ULoop       
   END      
   
   -- Now we can update the bitEvaluated flag and set it to 1 for all dispositionlog table for which we have just updated Big_Table.      
   UPDATE dl SET dl.bitEvaluated = sd.bitEvaluated FROM DispositionLog dl, #SampDispo sd WHERE dl.study_id = sd.study_id AND dl.samplepop_id = sd.samplepop_id AND dl.bitEvaluated = 0  
   
   DELETE FROM #tblStudy WHERE study_id = @study_id  
   SELECT TOP 1 @study_id = study_id, @study = study FROM #tblStudy    
  END      
     
       
 -- CLEAN UP      
  DROP TABLE #UPDATEBT      
  DROP TABLE #DEL      
  DROP TABLE #ULOOP      
        
  DROP TABLE #DISPONEW      
  DROP TABLE #DISPOWORK      
        
  DROP TABLE #DISPO      
  DROP TABLE #SAMPDISPO      
  DROP TABLE #tblStudy  
  DROP TABLE #Hav_HDispCol  
  SET NOCOUNT OFF  
END 
  DROP TABLE #AllSP
RETURN  
----------------------------------------------------------------------------------
GO
----------------------------------------------------------------------------------
GO

/***********************************************************************************
								Job Creation							
***********************************************************************************/

DECLARE @jobID UNIQUEIDENTIFIER,@stepID INT, @failstepID INT, @cmd VARCHAR(250)
SET @cmd = '-- First get New Disposition from Qualysis' + CHAR(10) + '     EXEC dbo.SP_Extract_DispositionLog' + CHAR(10) + CHAR(10) + '-- Second lets update the BigTable with Newest Dispostion' + CHAR(10) + '     EXEC dbo.dbo.SP_Extract_DispositionBigTable'
SELECT @jobID = job_id FROM msdb.dbo.sysjobs WHERE NAME = 'EXTRACT'
SELECT @stepID = step_id + 1 FROM msdb.dbo.sysjobsteps where job_id = @jobID AND step_name = 'sp_extract_bubbledata'
SELECT @failstepID = step_id + 1 FROM msdb.dbo.sysjobsteps where job_id = @jobID AND step_name = 'Extract Failed Notification'


EXEC msdb.dbo.sp_add_jobstep 
	 @job_id = @jobID
	,@step_id = @stepID
	,@step_name = 'sp_Extract_DispositionPopulation'
	,@subsystem = 'TSQL'
	,@command = @cmd
	,@on_success_action = 3
	,@on_fail_action = 4
	,@on_fail_step_id = @failstepID
	,@database_name = 'QP_COMMENTS'
	,@output_file_name = 'D:\sql\mssql\LOG\EXTRACT_JobLog.txt'
	,@flags = 2

GO
----------------------------------------------------------------------------------
-- BEGIN TRANSACTION            
--   DECLARE @JobID BINARY(16)  
--   DECLARE @ReturnCode INT    
--   SELECT @ReturnCode = 0     
-- IF (SELECT COUNT(*) FROM msdb.dbo.syscategories WHERE name = N'[Uncategorized (Local)]') < 1 
--   EXECUTE msdb.dbo.sp_add_category @name = N'[Uncategorized (Local)]'
-- 
--   -- Delete the job with the same name (if it exists)
--   SELECT @JobID = job_id     
--   FROM   msdb.dbo.sysjobs    
--   WHERE (name = N'Disposition Population')       
--   IF (@JobID IS NOT NULL)    
--   BEGIN  
--   -- Check if the job is a multi-server job  
--   IF (EXISTS (SELECT  * 
--               FROM    msdb.dbo.sysjobservers 
--               WHERE   (job_id = @JobID) AND (server_id <> 0))) 
--   BEGIN 
--     -- There is, so abort the script 
--     RAISERROR (N'Unable to import job ''Disposition Population'' since there is already a multi-server job with this name.', 16, 1) 
--     GOTO QuitWithRollback  
--   END 
--   ELSE 
--     -- Delete the [local] job 
--     EXECUTE msdb.dbo.sp_delete_job @job_name = N'Disposition Population' 
--     SELECT @JobID = NULL
--   END 
-- 
-- BEGIN 
-- 
--   -- Add the job
--   EXECUTE @ReturnCode = msdb.dbo.sp_add_job @job_id = @JobID OUTPUT , @job_name = N'Disposition Population', @owner_login_name = N'sa', @description = N'No description available.', @category_name = N'[Uncategorized (Local)]', @enabled = 1, @notify_level_email = 0, @notify_level_page = 0, @notify_level_netsend = 0, @notify_level_eventlog = 2, @delete_level= 0
--   IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 
-- 
--   -- Add the job steps
--   EXECUTE @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'SP_Extract_DispositionLog', @command = N'EXEC SP_Extract_DispositionLog', @database_name = N'QP_Comments', @server = N'', @database_user_name = N'', @subsystem = N'TSQL', @cmdexec_success_code = 0, @flags = 0, @retry_attempts = 0, @retry_interval = 1, @output_file_name = N'', @on_success_step_id = 0, @on_success_action = 1, @on_fail_step_id = 0, @on_fail_action = 2
--   IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 
--   EXECUTE @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1 
-- 
--   IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 
-- 
--   -- Add the job schedules
--   EXECUTE @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'Nightly at 9:30pm', @enabled = 1, @freq_type = 4, @active_start_date = 20060614, @active_start_time = 213000, @freq_interval = 1, @freq_subday_type = 1, @freq_subday_interval = 0, @freq_relative_interval = 0, @freq_recurrence_factor = 0, @active_end_date = 99991231, @active_end_time = 235959
--   IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 
-- 
--   -- Add the Target Servers
--   EXECUTE @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'(local)' 
--   IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 
-- 
-- END
-- COMMIT TRANSACTION          
-- GOTO   EndSave              
-- QuitWithRollback:
--   IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION 
-- EndSave: 
-- 
-- GO

----------------------------------------------------------------------------------
GO
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[DCL_ExportCreateFile_Sub]   
@ExportSetID INT,   
@Returnsonly BIT,   
@DirectsOnly BIT,  
@ExportFileGUID UNIQUEIDENTIFIER,  
@CreateHeader INT  
AS    
    
SET NOCOUNT ON    
    
CREATE TABLE #sp(SamplePop_id INT)    
    
DECLARE @Study_id INT, @sql1 VARCHAR(8000), @sql2 VARCHAR(8000), @sql3 VARCHAR(8000), @sql4 VARCHAR(8000), @sql5 VARCHAR(8000)    
DECLARE @field VARCHAR(100), @short VARCHAR(8), @Start DATETIME, @End DATETIME, @Owner VARCHAR(20), @Survey_id INT, @tableExtension varchar(20)  
DECLARE @Unique VARCHAR(40), @ResetCores VARCHAR(8000), @SampleUnit_id INT  
  
SELECT @Unique=RIGHT(CONVERT(VARCHAR(40),@ExportFileGUID),12)  
  
--Populate some variables  
SELECT @Study_id=Study_id, @Survey_id=Survey_id, @Start=EncounterStartDate, @End=EncounterEndDate, @SampleUnit_id=SampleUnit_id  
FROM ExportSet WHERE ExportSetID=@ExportSetID  
  
SELECT @tableExtension ='view'  
IF dbo.YearQtr(@start)=dbo.YearQtr(@end) SET @tableExtension=dbo.YearQtr(@start)  
  
SELECT @Owner='S'+LTRIM(STR(@Study_id))    
    
SELECT @sql1=''    
    
SELECT @sql1=@sql1+' DROP TABLE '+Table_Schema+'.'+Table_Name    
FROM Information_Schema.Tables    
WHERE Table_Name LIKE 'Export_'+LTRIM(STR(@ExportSetID))+CONVERT(VARCHAR(40),@Unique)    
    
EXEC (@sql1)    
    
--Get a list of the SamplePops I need to work with.    
IF @ReturnsOnly=0    
BEGIN    
  
SELECT @sql1='INSERT INTO #sp SELECT DISTINCT SamplePop_id FROM s'+LTRIM(STR(@Study_id))+'.Big_Table_' + @tableExtension +' b, SampleUnit su    
 WHERE datReportDate BETWEEN '''+CONVERT(VARCHAR,@Start,120)+''' AND '''+CONVERT(VARCHAR,DATEADD(S,-1,DATEADD(D,1,@End)),120)+'''    
 AND b.SampleUnit_id=su.SampleUnit_id    
 AND su.Survey_id='+LTRIM(STR(@Survey_id))    
EXEC (@sql1)    
    
END    
    
--#CutOff is now populated from the study_results table/view  
--We will track the people in the export before we pass the results back to the app.  
CREATE TABLE #CutOff (SamplePop_id INT)  
  
SELECT @sql1='INSERT INTO #CutOff  
SELECT DISTINCT SamplePop_id FROM s'+LTRIM(STR(@Study_id))+'.Study_Results_' + @tableExtension +' b, SampleUnit su    
 WHERE datReportDate BETWEEN '''+CONVERT(VARCHAR,@Start,120)+''' AND '''+CONVERT(VARCHAR,DATEADD(S,-1,DATEADD(D,1,@End)),120)+'''    
 AND b.SampleUnit_id=su.SampleUnit_id    
 AND su.Survey_id='+LTRIM(STR(@Survey_id))    
EXEC (@sql1)  
    
--Create a temp table to track the columns I need in the final table.    
CREATE TABLE #col (col VARCHAR(42), selcol VARCHAR(100), short VARCHAR(10), Tbl TINYINT, intOrder INT)    
    
--Fields that are a part of the study, including computed fields only in the datamart (table 2)    
INSERT INTO #col    
SELECT DISTINCT strField_nm, CASE WHEN strFieldDataType='D' THEN 'CONVERT(VARCHAR(10),'+strField_nm+',101)' ELSE strField_nm END, ISNULL(strFieldShort_nm,LEFT(strField_nm,8)), 2 , NULL    
FROM MetaStructure ms, MetaField mf    
WHERE ms.Study_id=@Study_id    
AND ms.Field_id=mf.Field_id    
AND bitPostedField_FLG=1    
    
-- Add in system fields that MIGHT exist depending upon circumstances (We wll check for exisitence in Big_View Next......) 
INSERT INTO #col SELECT 'HDisposition','HDisposition', 'Dispostn' , 1 , NULL      
INSERT INTO #col SELECT 'MethodologyType','MethodologyType', 'Method' , 1 , NULL      

--Remove fields from #col that do not exist in Big_Table_View      
SELECT @SQL1='DELETE t       
FROM #col t LEFT OUTER JOIN (SELECT Column_Name FROM Information_Schema.Columns WHERE Table_Schema=''' + @Owner + ''' AND Table_Name=''Big_Table_' + @tableExtension +''') a      
ON t.Col=a.Column_Name      
WHERE a.Column_Name IS NULL'    
EXEC (@sql1)     
      
--Add in the system fields we want (table 1)      
INSERT INTO #col SELECT NULL,'CONVERT(VARCHAR(10),bv.datUndeliverable,101)', 'Undel_dt', 1 , NULL      
INSERT INTO #col SELECT NULL,'bv.SamplePop_id', 'SampPop', 1 , NULL      
INSERT INTO #col SELECT NULL,'bv.SampleUnit_id', 'SampUnit', 1 , NULL      
INSERT INTO #col SELECT NULL,'CONVERT(VARCHAR(42),NULL)', 'Unit_nm' , 1 , NULL      
INSERT INTO #col SELECT NULL,'CONVERT(VARCHAR(20),NULL)', 'Medicare' , 1 , NULL      
INSERT INTO #col SELECT NULL,'CONVERT(BIT,NULL)', 'HCAHPS' , 1 , NULL      
INSERT INTO #col SELECT NULL,'bv.SampleSet_id', 'SampSet', 1 , NULL      
INSERT INTO #col SELECT NULL,'CONVERT(VARCHAR(10),bv.datReportDate,101)', 'ReportDt', 1 , NULL      
INSERT INTO #col SELECT NULL,'bv.strUnitSelectType', 'SampType', 1 , NULL      
INSERT INTO #col SELECT NULL,'CONVERT(VARCHAR(10),bv.datSampleCreate_dt,101)', 'Samp_dt', 1 , NULL      
INSERT INTO #col SELECT NULL,'strLithoCode', 'LithoCd' , 1 , NULL      
INSERT INTO #col SELECT NULL,'bv.DaysFromFirstMailing', 'DyFrFrst' , 1 , NULL      
INSERT INTO #col SELECT NULL,'bv.DaysFromCurrentMailing', 'DyFrCur' , 1 , NULL      
INSERT INTO #col SELECT NULL,'CONVERT(VARCHAR(10),datReturned,101)', 'Rtrn_dt' , 1 , NULL      
  
SET @sql1='INSERT INTO #col SELECT NULL,''CONVERT(INT,sr.bitComplete)'',''Complete'',1,NULL  
FROM Information_Schema.Columns  
WHERE Table_Schema=''S''+LTRIM(STR(' + convert(varchar,@Study_id) + '))  
AND Table_Name=''Study_Results_' + @tableExtension +'''  
AND Column_Name=''bitComplete'''  
EXEC(@sql1)  
    
--Get a list of the cores that pertain to this survey.      
--Typically there are several surveys in a study that each use different sets    
-- of questions.      
SELECT DISTINCT QstnCore, Section_id * 100000 + subSection * 100 + Item intOrder     
INTO #cores     
FROM questions     
WHERE Survey_id=@Survey_id    
--Removed 2/3/5 BD per Phil's instructions  
-- AND bitIDEASSuppress=0  
  
--INSERT the actual column names for the questions INTO the temp table(table 3)    
SELECT @sql1='INSERT INTO #col    
SELECT NULL,sc.name, NULL, 3, intOrder    
FROM sysColumns sc, sysObjects so, sysUsers su, #cores t    
WHERE su.name=''s''+LTRIM(STR(' + convert(varchar,@Study_id) + '))    
AND su.uid=so.uid    
AND so.name=''Study_Results_' + @tableExtension +'''    
AND so.id=sc.id    
AND SUBSTRING(sc.name,2,6)=RIGHT(''00000''+CONVERT(VARCHAR,QstnCore),6)'  
EXEC (@sql1)  
  
--Now to build the table  
SELECT @sql1=''  
SELECT @sql2=''  
SELECT @sql3=''  
SELECT @ResetCores=''  
  
--We first deal with the system fields (table 1)    
SELECT TOP 1 @field=selcol FROM #col WHERE tbl=1    
  
WHILE @@ROWCOUNT > 0    
 BEGIN    
     
  SELECT @short=short FROM #col WHERE selcol=@field    
      
  IF @sql1=''    
   BEGIN    
        
    IF @short <> @field    
    SELECT @sql1=@sql1+@field+' '+@short    
    ELSE    
    SELECT @sql1=@sql1+@field    
   END     
  ELSE    
   BEGIN    
    IF @short <> @field    
    SELECT @sql1=@sql1+','+@field+' '+@short    
    ELSE    
    SELECT @sql1=@sql1+','+@field    
   END    
      
  DELETE #col WHERE selcol=@field    
      
  SELECT TOP 1 @field=selcol FROM #col WHERE tbl=1    
     
 END    
    
--We next deal with the big_table fields (table 2)    
SELECT TOP 1 @field=selcol FROM #col WHERE tbl=2    
    
WHILE @@ROWCOUNT > 0    
 BEGIN    
     
  SELECT @short=short FROM #col WHERE selcol=@field    
      
  IF @sql2=''    
   BEGIN    
        
    IF @short <> @field    
    SELECT @sql2=@sql2+@field+' '+@short    
    ELSE    
    SELECT @sql2=@sql2+@field    
   END    
  ELSE    
   BEGIN    
    IF @short <> @field    
    SELECT @sql2=@sql2+','+@field+' '+@short    
    ELSE    
    SELECT @sql2=@sql2+','+@field    
   END    
      
  DELETE #col WHERE selcol=@field    
      
  SELECT TOP 1 @field=selcol FROM #col WHERE tbl=2    
     
 END    
    
--We finally deal with the study_results fields (table 3)    
SELECT TOP 1 @field=selcol FROM #col WHERE tbl=3 order by intOrder    
    
WHILE @@ROWCOUNT > 0    
 BEGIN    
     
  SELECT @short=short FROM #col WHERE selcol=@field    
      
  IF @sql3=''    
   BEGIN      
    SELECT @sql3=@sql3+@field    
    SELECT @ResetCores=@ResetCores+@Field+'=NULL'  
   END    
  ELSE    
   BEGIN    
    SELECT @sql3=@sql3+','+@field    
    SELECT @ResetCores=@ResetCores+','+@Field+'=NULL'  
   END    
      
  DELETE #col WHERE selcol=@field    
      
  SELECT TOP 1 @field=selcol FROM #col WHERE tbl=3 order by intOrder    
     
 END    
    
--print @sql1    
--print @sql2    
--print @sql3    
    
IF @ReturnsOnly=1    
BEGIN    
 SELECT @sql4=' s'+LTRIM(STR(@Study_id))+'.Export_'+LTRIM(STR(@ExportSetID))+CONVERT(VARCHAR(40),@Unique)+' FROM s'+LTRIM(STR(@Study_id))+'.Big_Table_' + @tableExtension +' bv (NOLOCK) JOIN     
 s'+LTRIM(STR(@Study_id))+'.Study_Results_' + @tableExtension +' sr (NOLOCK) ON bv.SamplePop_id=sr.SamplePop_id    
 AND bv.SampleUnit_id=sr.SampleUnit_id,     
 #CutOff t    
  WHERE t.SamplePop_id=bv.SamplePop_id'+CASE WHEN @SampleUnit_id IS NULL THEN '' ELSE ' AND bv.SampleUnit_id='+LTRIM(STR(@SampleUnit_id)) END    
END    
ELSE    
BEGIN    
SELECT @sql4=' s'+LTRIM(STR(@Study_id))+'.Export_'+LTRIM(STR(@ExportSetID))+CONVERT(VARCHAR(40),@Unique)+' FROM s'+LTRIM(STR(@Study_id))+'.Big_Table_' + @tableExtension +' bv (NOLOCK) LEFT OUTER JOIN     
(SELECT s.* FROM s'+LTRIM(STR(@Study_id))+'.Study_Results_' + @tableExtension +' s(NOLOCK), #CutOff t WHERE t.SamplePop_id=s.SamplePop_id) sr ON bv.SamplePop_id=sr.SamplePop_id    
AND bv.SampleUnit_id=sr.SampleUnit_id,     
#sp t    
 WHERE t.SamplePop_id=bv.SamplePop_id'+CASE WHEN @SampleUnit_id IS NULL THEN '' ELSE ' AND bv.SampleUnit_id='+LTRIM(STR(@SampleUnit_id)) END  
END     
    
SELECT @sql5='IF EXISTS (SELECT * FROM SysObjects WHERE id=OBJECT_ID(N''S'+LTRIM(STR(@Study_id))+'.Export_'+LTRIM(STR(@ExportSetID))+CONVERT(VARCHAR(40),@Unique)+''') AND OBJECTPROPERTY(id, N''IsUserTable'')=1)    
  BEGIN DROP TABLE S'+LTRIM(STR(@Study_id))+'.Export_'+LTRIM(STR(@ExportSetID))+CONVERT(VARCHAR(40),@Unique)+' END '    
   
-- PRINT @sql1    
-- PRINT @sql2    
-- PRINT @sql3    
-- PRINT @sql5+' SELECT '+@sql1+','+@sql2+','+@sql3+' INTO '+@sql4+' AND bv.strUnitSelectType=''D'''    
   
IF @sql3<>''  
BEGIN  
 IF @DirectsOnly=1    
  EXEC (@sql5+' SELECT '+@sql1+','+@sql2+','+@sql3+' INTO '+@sql4+'    
   AND bv.strUnitSelectType=''D''')   
 ELSE   
  EXEC (@sql5+' SELECT '+@sql1+','+@sql2+','+@sql3+' INTO '+@sql4)    
    
 IF @@ROWCOUNT>0  
 BEGIN  
  SELECT @sql1='UPDATE e SET e.Unit_nm=strSampleUnit_nm, e.Medicare=su.MedicareNumber, e.HCAHPS=ISNULL(bitHCAHPS,0)  
   FROM S'+LTRIM(STR(@Study_id))+'.Export_'+LTRIM(STR(@ExportSetID))+CONVERT(VARCHAR(40),@Unique)+' e, SampleUnit su    
   WHERE su.SampleUnit_id=e.SampUnit'    
  EXEC (@sql1)    
  
  IF @CreateHeader=1 -- Delete the non HCAHPS records  
  BEGIN  
    SELECT @sql1='DELETE S'+LTRIM(STR(@Study_id))+'.Export_'+LTRIM(STR(@ExportSetID))+CONVERT(VARCHAR(40),@Unique)+'   
     WHERE HCAHPS=0'  
    EXEC (@sql1)  

--   --Update the Dispostn column  
--   CREATE TABLE #Dispo (SamplePop_id INT, Disposition_id INT, HCAHPSHierarchy INT, HCAHPSValue CHAR(2))  
--   CREATE TABLE #SampDispo (SamplePop_id INT, HCAHPSValue CHAR(2))  
  
--   SELECT @sql1='INSERT INTO #Dispo (SamplePop_id, Disposition_id, HCAHPSHierarchy, HCAHPSVALUE)  
--    SELECT e.SampPop, d.Disposition_id, HCAHPSHierarchy, HCAHPSValue  
--    FROM S'+LTRIM(STR(@Study_id))+'.Export_'+LTRIM(STR(@ExportSetID))+CONVERT(VARCHAR(40),@Unique)+' e, dispositionlog dl, disposition d  
--    WHERE e.SampPop=dl.SamplePop_id  
--    AND dl.DaysFromFirst<43  
--    AND d.Disposition_id=dl.Disposition_id'  
--   EXEC (@sql1)  
  
--   INSERT INTO #SampDispo (SamplePop_id, HCAHPSValue)  
--   SELECT t.SamplePop_id, HCAHPSValue  
--   FROM #Dispo t, (SELECT SamplePop_id, MIN(HCAHPSHierarchy) HCAHPSHierarchy FROM #Dispo GROUP BY SamplePop_id) a  
--   WHERE t.SamplePop_id=a.SamplePop_id  
--   AND t.HCAHPSHierarchy=a.HCAHPSHierarchy  
--   GROUP BY t.SamplePop_id, HCAHPSValue  
  
--   SELECT @sql1='UPDATE e  
--    SET Dispostn=HCAHPSValue  
--    FROM S'+LTRIM(STR(@Study_id))+'.Export_'+LTRIM(STR(@ExportSetID))+CONVERT(VARCHAR(40),@Unique)+' e, #SampDispo t  
--    WHERE e.SampPop=t.SamplePop_id'  
--   EXEC (@sql1)  
  
  --Reset the question results for returns more than 42 days from first or for ineligible dispositions  
   SELECT @sql1='UPDATE S'+LTRIM(STR(@Study_id))+'.Export_'+LTRIM(STR(@ExportSetID))+CONVERT(VARCHAR(40),@Unique)+'   
    SET '+@ResetCores+'  
    WHERE DyFrFrst>42 or Dispostn in (''02'',''03'',''04'',''05'')'  
   EXEC (@sql1)  
	
	--Reset the return date to null for returns more than 42 days from first or for ineligible dispositions
   SELECT @sql1='UPDATE S'+LTRIM(STR(@Study_id))+'.Export_'+LTRIM(STR(@ExportSetID))+CONVERT(VARCHAR(40),@Unique)+'   
    SET rtrn_dt=null  
    WHERE DyFrFrst>42 or Dispostn in (''02'',''03'',''04'',''05'')'  
   EXEC (@sql1)  

	--Reset the languageId to null for non-returns, returns more than 42 days from first, or for ineligible dispositions
   SELECT @sql1='UPDATE S'+LTRIM(STR(@Study_id))+'.Export_'+LTRIM(STR(@ExportSetID))+CONVERT(VARCHAR(40),@Unique)+'   
    SET langId=null  
    WHERE rtrn_dt is null or DyFrFrst>42 or Dispostn in (''02'',''03'',''04'',''05'')'  
   EXEC (@sql1)  
  END  
  
   INSERT INTO #ExportTables (Table_Schema, Table_Name)  
   SELECT CONVERT(VARCHAR(10),'S'+LTRIM(STR(@Study_id))),CONVERT(VARCHAR(100),'Export_'+LTRIM(STR(@ExportSetID))+CONVERT(VARCHAR(40),@Unique))  
 END  
END  

GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO
/***********************************************************
This SP is called from sampling by the qp_prod SP 
************************************************************/
CREATE procedure QCL_SelectRespRateInfoBySurveyId 
	@survey_id int
as
select sampleset_id, sampleunit_id, intreturned, intsampled, intUD
from RespRateCount 
where survey_id=@survey_id and
	sampleunit_id <>0
	
GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO
/***********************************************************
This SP is called from sampling by the qp_prod SP 
************************************************************/
CREATE procedure QCL_SelectHCAHPSRespRateByDaysInfoBySurveyId 
	@survey_id int
as
select sampleset_id, sampleunit_id, 
	sum(intreturned) as intreturned
from RR_ReturnCountByDays 
where survey_id=@survey_id
  AND DaysFromFirstMailing<43
group by sampleset_id, sampleunit_id

GO
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
GO

/*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/

/***********************************************************************************
								BackPopulation							
***********************************************************************************/
-----------------------------------------------------------------------------------------------
GO
-- ALTER BIG_TABLE AND ADD METHODOLOGYTYPE, HDisposition COLUMNs - THEN POPULATE THE COLUMNS WITH DATA

-- Get HCAHPS surveys from Qualysis
CREATE TABLE #HCAHPS_svy (survey_id int, methodolgy_id int, methodologytype varchar(30), sampleset_id int, datsamplecreate_dt datetime)

/**********************/
DECLARE @Server VARCHAR(20),@sql varchar(1000)
select @server = strParam_Value from datamart_params where strparam_nm = 'QualPro Server'
set @sql = 'insert into #hcahps_svy (survey_id, methodolgy_id, methodologytype, sampleset_id, datsamplecreate_dt)' + char(10) +
'SELECT DISTINCT sd.survey_id, sc.methodology_id, stdm.methodologytype, ss.sampleset_id, ss.datsamplecreate_dt ' + char(10) + 
'FROM ' + @server + 'qp_prod.dbo.survey_def sd  ' + char(10) + 
'INNER JOIN ' + @server + 'qp_prod.dbo.sampleset ss ON sd.survey_id = ss.survey_id AND sd.surveytype_id = 2 AND ss.datsamplecreate_dt >= ''12/1/2005''  ' + char(10) + 
'INNER JOIN ' + @server + 'qp_prod.dbo.samplepop sp ON ss.sampleset_id = sp.sampleset_id ' + char(10) + 
'INNER JOIN ' + @server + 'qp_prod.dbo.scheduledmailing sc ON sc.samplepop_id = sp.samplepop_id ' + char(10) + 
'INNER JOIN ' + @server + 'qp_prod.dbo.mailingmethodology mm ON sc.methodology_id = mm.methodology_id ' + char(10) + 
'INNER JOIN ' + @server + 'qp_prod.dbo.standardmethodology stdm ON mm.standardmethodologyID = stdm.standardmethodologyID'
--	 print @sql
exec (@sql)

/**********************/

CREATE CLUSTERED INDEX cix_hcahps ON dbo.#hcahps_svy (sampleset_id)
/**********************/

SELECT DISTINCT study_id INTO #study FROM clientstudysurvey c, #hcahps_svy s WHERE c.survey_id = s.survey_id
/****************/
-- Find out what tables we will need to Alter/Update

-- Get the associate study
SELECT c.study_id, h.* 
INTO #x 
FROM #hcahps_svy h, clientstudysurvey c, information_schema.tables i where h.survey_id = c.survey_id and 's' + convert(varchar,c.study_id) = i.table_schema and i.table_name = 'big_table_view'

/**********************/

-- Create some tables
CREATE TABLE #tblWork (rec INT IDENTITY(1,1), study_id int, tbl varchar(50), bitAlter BIT, bitUpdate BIT)
CREATE TABLE #SQL (REC INT IDENTITY(1,1), SQL VARCHAR(1000))
/**********************/

-- Create the statements that will be executed against various study.big_table_view
DECLARE @study_id INT, @sql VARCHAR(8000) 
select top 1 @study_id = study_id FROM #x
WHILE @@ROWCOUNT > 0
BEGIN 
	
	INSERT INTO #SQL SELECT DISTINCT 'INSERT INTO #tblWork (study_id, tbl, bitAlter, bitUpdate) select DISTINCT ' + convert(varchar,x.study_id) + ', ''s' +convert(varchar,x.study_id) + '.'' + b.tablename AS tbl, 0, 0 from #x x, s' +convert(varchar,x.study_id) + '.big_table_view b where x.sampleset_id = b.sampleset_id' from #x x WHERE study_id = @study_id
	
	DELETE FROM #X WHERE study_id = @study_id
	select top 1 @study_id = study_id from #x
END

/****************/
-- Repopulate our #x table for the next step
INSERT INTO #x
SELECT c.study_id, h.* FROM #hcahps_svy h, clientstudysurvey c, information_schema.tables i 
WHERE h.survey_id = c.survey_id and 's' + convert(varchar,c.study_id) = i.table_schema and i.table_name = 'big_table_view'

/****************/
-- Execute the statements built in the previous step to populate the #tblWork table, that will contain the tables we need to Alter and Update for Each Study.
DECLARE @REC INT, @SQL VARCHAR(8000)
SELECT TOP 1 @REC = REC, @SQL = SQL FROM #sql

WHILE @@ROWCOUNT >0
BEGIN

	EXEC (@SQL)	

	DELETE FROM #SQL WHERE @REC = REC
	SELECT TOP 1 @REC = REC, @SQL = SQL FROM #sql
END
UPDATE #tblWork SET rtbl = REPLACE(tbl,'.Big_Table','.Study_Results')

/****************/
-- Alter existing HCAHPS studies by adding MethodologyType field to BigTable for 2005_3 to current

DECLARE @rec int, @tbl VARCHAR(50), @SQL VARCHAR(1000)
SELECT TOP 1  @rec = rec, @tbl = tbl from #tblwork WHERE bitAlter = 0
WHILE (SELECT COUNT(*) FROM #tblwork WHERE bitAlter = 0) > 0
BEGIN

	SET @sql = 'ALTER TABLE ' + @tbl + ' ADD MethodologyType VARCHAR(30), HDisposition VARCHAR(20)'
	EXEC (@SQL)
--	PRINT @SQL

	UPDATE #tblwork SET bitAlter = 1 where rec = @rec
	SELECT TOP 1  @rec = rec, @tbl = tbl from #tblwork WHERE bitAlter = 0

END

/******************/
-- Now Lets Rebuild the Big Table views
--PRINT @RBV
DECLARE @SQL VARCHAR(8000)

SELECT DISTINCT ' EXEC dbo.sp_dbm_MakeView ''s' + CONVERT(VARCHAR,STUDY_ID) + ''', ''Big_Table''' AS sql INTO #rbv from #tblwork where bitAlter = 1
WHILE @@ROWCOUNT >0
BEGIN
	SELECT TOP 1 @SQL = SQL FROM #RBV 
	EXEC (@SQL)
	DELETE FROM #RBV WHERE SQL = @SQL
	SELECT TOP 1 @SQL = SQL FROM #RBV 
END

/******************/
-------------------------------------------
-------------------------------------------
-- Now its time to backpopulate the tables that we added the column to.
/* -- Moving backpopulation of Dispositions complete/notcomplete to Qualysis dispositionlog tbl
CREATE TABLE DSLOG_BCWORK (study_id INT, samplepop_id INT, disposition_id INT, receipttype_id INT, datLogged DATETIME, loggedby VARCHAR(42), DaysFromCurrent INT, DaysFromFirst INT )
CREATE INDEX ix_dslog_bcwork ON dslog_bcwork (study_id, samplepop_id, disposition_id, datlogged)
*/
SET NOCOUNT ON 
DECLARE @rec int, @tbl VARCHAR(50), @rtbl VARCHAR(50), @SQL VARCHAR(1000), @study_id INT, @complete int, @notcomplete int

-- Need ID value for breakoff and complete dispositions (06) and (01) respectively.
SELECT @notcomplete = disposition_id FROM DISPOSITION WHERE HCAHPSValue = '06'
SELECT @complete = disposition_Id FROM DISPOSITION WHERE HCAHPSValue = '01'

SELECT TOP 1  @rec = rec, @tbl = tbl, @rtbl = rtbl, @study_id = study_id from #tblwork WHERE bitUpdate = 0
WHILE (SELECT COUNT(*) FROM #tblwork WHERE bitUpdate = 0) > 0
BEGIN

	-- Update the MethodologyType applicable to the sampleset for the HCAHPS survey,  Update the HCAHPS disposition value to a default of "08" (we will apply actual current disposition during Extract Analysis.
--	SET @sql = 'UPDATE b SET b.MethodologyType = u.MethodologyType, b.HDisposition = ''08'' FROM ' + @tbl + ' b INNER JOIN #HCAHPS_svy u ON b.sampleset_id = u.sampleset_id'
	SET @sql = 'UPDATE b SET b.MethodologyType = u.MethodologyType, b.HDisposition = ''08'', CASE WHEN b.HServiceType = ''Other'' THEN ''X'' ELSE b.HServiceType END FROM ' + @tbl + ' b INNER JOIN #HCAHPS_svy u ON b.sampleset_id = u.sampleset_id'

	EXEC (@SQL)
--	PRINT @SQL
/*-- Moving backpopulation of Dispositions complete/notcomplete to Qualysis dispositionlog tbl
	-- Look to see if the samplepop has a bitComplete Flag -- Then add a completed dispostion to the DispositionLog for this Samplepop
	SET @SQL = 'INSERT INTO DSLOG_BCWORK (study_id, samplepop_id, disposition_id, receipttype_id, datLogged, loggedby, DaysFromCurrent, DaysFromFirst ) ' + CHAR(10) +
		   'SELECT DISTINCT ' + LTRIM(STR(@study_id)) + ', b.samplepop_id, CASE b.bitComplete WHEN 1 THEN ' + CONVERT(varchar,@complete) + ' WHEN 0 THEN ' + convert(varchar,@notcomplete) 
		+ ' ELSE NULL END AS disposition_id, 0 AS receipttype_id, r.datReturned, ''#nrcsql'' AS Loggedby, b.DaysFromCurrentMailing AS DaysFromCurrent, b.DaysFromFirstMailing  AS DaysFromFirst' + CHAR(10) + 
		   'FROM ' + @tbl + ' b INNER JOIN #HCAHPS_svy u ON b.sampleset_id = u.sampleset_id ' + CHAR(10) + 
		   'INNER JOIN ' + @rtbl + ' r ON r.samplepop_id = b.samplepop_id and r.sampleunit_id =b.sampleunit_id WHERE b.bitComplete IN (1,0)'

	EXEC (@SQL)
--	PRINT @SQL
*/
	UPDATE #tblwork SET bitUpdate = 1 where rec = @rec
	SELECT TOP 1  @rec = rec, @tbl = tbl, @rtbl = rtbl, @study_id = study_id from #tblwork WHERE bitUpdate = 0

END
SET NOCOUNT OFF
/*-- Moving backpopulation of Dispositions complete/notcomplete to Qualysis dispositionlog tbl
INSERT INTO DispositionLog (study_id, samplepop_id, disposition_id, receipttype_id, datLogged, LoggedBy, DaysFromCurrent, DaysFromFirst)
 	SELECT study_id, samplepop_id, disposition_id, receipttype_id, datLogged, loggedby, DaysFromCurrent, DaysFromFirst FROM DSLOG_BCWORK W
		WHERE  NOT EXISTS (SELECT * FROM DispositionLog D WHERE d.study_id = w.study_id and d.samplepop_id = w.samplepop_id AND d.disposition_id = w.disposition_id AND d.datLogged = w.datLogged)

DELETE W FROM dslog_bcwork w WHERE EXISTS (SELECT * FROM dispositionlog d WHERE d.study_id = w.study_id and d.samplepop_id = w.samplepop_id AND d.disposition_id = w.disposition_id AND d.datLogged = w.datLogged)
*/
-------------------------------------------

DROP TABLE #hcahps_svy
DROP TABLE #study
DROP TABLE #tblwork
DROP TABLE #rbv
DROP TABLE #x
DROP TABLE #sql
--  DROP TABLE dslog_bcwork

----------------------------------------------------------------------------------------------
GO

