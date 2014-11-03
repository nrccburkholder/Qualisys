
ALTER PROCEDURE SP_Phase4_Big_View_Web @sampleset INT, @Cleansed BIT=0    
AS      

--  Created 1/27/3 BD Creates a view based on sampleset_id passed from NRC47.QP_COMMENTS.dbo.sp_extract_big_table stored procedure.      
--  Used during the extract to the datamart.      
--  Modified 7/20/2005 BD Added @Cleansed to handle PII information from Canada.      
--  Modified 5/19/2006 BD Added MethodologyType for HCAHPS reporting.      
--  Modified 10/12/2006 SS Added datSampleEncounterDate for Reporting/Sampling Flexibility

DECLARE @sql VARCHAR(1000), @ReportDate VARCHAR(50), @strsql VARCHAR(8000), @survey INT, @study INT, @fld VARCHAR(70), @short VARCHAR(70),      
@sel VARCHAR(8000), @cutofftype CHAR(1), @MethodologyType VARCHAR(50)  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  
  
IF (SELECT numParam_Value FROM QualPro_Params WHERE strParam_nm='Country')=2  
SELECT @Cleansed=1  
ELSE  
SELECT @Cleansed=0  
      
--Get the survey and study ids and MethodologyType      
SELECT @survey=survey_id FROM sampleset WHERE sampleset_id=@sampleset      
SELECT @study=study_id FROM survey_def WHERE survey_id=@survey      
SELECT TOP 1 @MethodologyType=MethodologyType   
 FROM SamplePop sp, ScheduledMailing schm, MailingMethodology mm, StandardMethodology sm  
 WHERE sp.SampleSet_id=@SampleSet  
 AND sp.SamplePop_id=schm.SamplePop_id  
 AND schm.Methodology_id=mm.Methodology_id  
 AND mm.StandardMethodologyID=sm.StandardMethodologyID  
  
--if the view already exists, drop it      
SET @strsql = 'IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N''[S' + CONVERT(VARCHAR,@study)+'].[BIG_VIEW_WEB]'') ' +      
 ' AND OBJECTPROPERTY(id, N''IsView'') = 1) DROP VIEW [S' + CONVERT(VARCHAR,@study) + '].[BIG_VIEW_WEB]'      
EXEC(@strsql)      
      
--determine if the study has an encounter table.  This determines part of the join criteria      
SELECT table_id FROM metatable WHERE study_id = @study AND strtable_nm = 'ENCOUNTER'      
IF @@ROWCOUNT = 0      
  BEGIN      
 SELECT @sql = 'AND ss.pop_id = bv.populationpop_id '      
  END      
ELSE      
 SELECT @sql = 'AND ss.enc_id = bv.encounterenc_id '      
      
--Find the reporting date field      
SELECT @cutofftype = strCutoffResponse_Cd      
FROM survey_def       
WHERE survey_id = @survey      
      
IF @CutOffType = 0      
SET @ReportDate = 'datSampleCreate_dt'       
      
IF @CutOffType = 1      
SET @ReportDate = 'CONVERT(DATETIME,NULL)'      
      
IF @CutOffType = 2      
BEGIN    
 IF @Cleansed=1     
  SET @ReportDate = (SELECT 'dbo.FirstDayOfMonth('+strTable_nm + strField_nm+')' FROM survey_def sd, metadata_view md WHERE sd.survey_id = @survey       
     AND cutofftable_id = md.Table_id AND cutofffield_id = md.Field_id)      
 ELSE      
  SET @ReportDate = (SELECT strTable_nm + strField_nm FROM survey_def sd, metadata_view md WHERE sd.survey_id = @survey       
     AND cutofftable_id = md.Table_id AND cutofffield_id = md.Field_id)      
END    
    
--Get a list of distinct fields for the select statement      
SELECT DISTINCT strfield_nm AS short, CONVERT(VARCHAR(70),'') AS fldnm       
INTO #selclause      
FROM metatable mt, metastructure ms, metafield mf      
WHERE mt.table_id = ms.table_id      
AND ms.field_id = mf.field_id      
AND mt.study_id = @study      
AND ms.bitpostedfield_flg = 1      
      
IF @Cleansed=0    
 UPDATE #selclause      
 SET fldnm = mt.strtable_nm + mf.strfield_nm     
 FROM metatable mt, metastructure ms, metafield mf      
 WHERE mt.table_id = ms.table_id      
 AND ms.field_id = mf.field_id      
 AND mt.study_id = @study      
 AND #selclause.short = mf.strfield_nm      
 AND ms.bitpostedfield_flg = 1      
ELSE    
  
  BEGIN  
  
     UPDATE #selclause      
     SET fldnm=CASE WHEN mf.strField_nm='AGE' THEN 'CASE WHEN POPULATIONAge>90 THEN 90 ELSE POPULATIONAge END'  
      WHEN mf.strField_nm='Postal_Code' THEN 'LEFT(POPULATIONPostal_Code,3)'  
      WHEN mf.strFieldDataType='D' THEN 'dbo.FirstDayOfMonth('+mt.strtable_nm + mf.strfield_nm+')'     
         ELSE mt.strTable_nm+mf.strField_nm  
          END      
     FROM metatable mt, metastructure ms, metafield mf      
     WHERE mt.table_id = ms.table_id      
     AND ms.field_id = mf.field_id      
     AND mt.study_id = @study      
     AND #selclause.short = mf.strfield_nm      
     AND ms.bitpostedfield_flg = 1      
     AND ms.bitAllowUS=1  
  
     UPDATE #selclause      
     SET fldnm='0'     
     FROM metatable mt, metastructure ms, metafield mf      
     WHERE mt.table_id = ms.table_id      
     AND ms.field_id = mf.field_id     
     AND mt.study_id = @study      
     AND #selclause.short = mf.strfield_nm      
     AND ms.bitpostedfield_flg = 1      
     AND ms.bitAllowUS=0  
  
  END  
    
SET @sel = ''      
      
--build the select statement field list      
DECLARE curins CURSOR FOR       
 SELECT short, fldnm FROM #selclause ORDER BY short      
OPEN curins      
FETCH NEXT FROM curins INTO @short,@fld      
WHILE @@FETCH_STATUS = 0      
BEGIN      
 SELECT @sel = @sel + ' ,' + @fld + ' ' + @short       
 FETCH NEXT FROM curins INTO @short,@fld      
END      
CLOSE curins      
DEALLOCATE curins      
      
--put the statement together and then create the new view      
SET @strsql = 'CREATE VIEW S' + CONVERT(VARCHAR,@study) + '.BIG_VIEW_WEB AS ' +      
  ' SELECT null AS questionform_id, CONVERT(DATETIME,NULL) AS datUndeliverable, sp.samplepop_id, sp.sampleset_id, ss.sampleunit_id, ' +      
  @ReportDate + ' datReportDate, SampleEncounterDate AS datSampleEncounterDate, strUnitSelectType, 1.0 numWeight, ss.study_id, survey_id, datSampleCreate_dt, '+  
  'CONVERT(VARCHAR(30),'''+@MethodologyType+''') MethodologyType'+ @sel +    
  ' FROM selectedsample ss(NOLOCK), s' + CONVERT(VARCHAR,@study) + '.big_view bv(NOLOCK), samplepop sp(NOLOCK), sampleset s(NOLOCK) ' +       
  ' WHERE ss.sampleset_id in ( ' +CONVERT(VARCHAR,@sampleset)+') '+      
  ' AND ss.sampleset_id = s.sampleset_id ' +      
  ' AND ss.sampleset_id = sp.sampleset_id ' +      
  ' AND ss.pop_id = sp.pop_id ' + @sql       
      
EXEC(@STRSQL)      
      
DROP TABLE #selclause    
  



