ALTER PROCEDURE dbo.SP_Extract_ApplicationTables  
AS  

SET ARITHABORT ON
-- Modified 5/24/05 SS -- Changed scales refresh to reorder #scales then update scales rather than update then reorder.    
-- Modified 10/19/206 SS - Added strSampleEncounterDateField to ClientStudySurvey update section
  
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
Client_ID INT,Study_id INT,Survey_ID INT,AD VARCHAR(42),strReportDateField VARCHAR(42), strSampleEncounterDateField VARCHAR(42), datHCAHPSReportable DATETIME, SurveyType_id INT)    
 
SELECT @sql='INSERT INTO #ClientStudySurvey (strClient_nm,strStudy_nm,strQSurvey_nm,strSurvey_nm,Client_id,Study_id,Survey_id,ad,    
 strReportDateField, strSampleEncounterDateField, datHCAHPSReportable, SurveyType_id)    
SELECT DISTINCT RTRIM(LTRIM(strClient_nm)),RTRIM(LTRIM(strStudy_nm)),RTRIM(LTRIM(strQSurvey_nm)),RTRIM(LTRIM(strSurvey_nm)),Client_id,Study_id,Survey_id,strntlogin_nm,    
 strReportDateField, strSampleEncounterDateField, datHCAHPSReportable, SurveyType_id FROM '+@Server+'QP_Prod.dbo.WEB_ClientStudySurvey_View'    
EXEC (@sql)    									    

UPDATE c    
SET c.strClient_nm=t.strClient_nm,c.strStudy_nm=t.strStudy_nm,c.strQSurvey_nm=t.strQSurvey_nm,c.strSurvey_nm=t.strSurvey_nm,c.ad=t.ad,    
 c.strReportDateField=t.strReportDateField, c.strSampleEncounterDateField=t.strSampleEncounterDateField, c.Client_id=t.Client_id,
 c.Study_id=t.Study_id, c.datHCAHPSReportable = t.datHCAHPSReportable, c.SurveyType_id = t.SurveyType_id   
FROM #ClientStudySurvey t,ClientStudySurvey c    
WHERE t.Survey_id=c.Survey_id           
    
DELETE t    
FROM #ClientStudySurvey t,ClientStudySurvey c    
WHERE t.Survey_id=c.Survey_id    
    
INSERT INTO ClientStudySurvey (strClient_nm,strStudy_nm,strQSurvey_nm,strSurvey_nm,Client_id,Study_id,Survey_id,ad,    
 strReportDateField, strSampleEncounterDateField, datHCAHPSReportable, SurveyType_id, bitHasResults)    
SELECT DISTINCT strClient_nm,strStudy_nm,strQSurvey_nm,strSurvey_nm,Client_id,Study_id,Survey_id,ad,    
 strReportDateField,strSampleEncounterDateField,datHCAHPSReportable, SurveyType_id, 0
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
 bitHCAHPS BIT, MedicareNumber VARCHAR(20), MedicareName VARCHAR(45),   
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




