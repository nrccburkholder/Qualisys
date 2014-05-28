CREATE PROCEDURE dbo.qp_rep_people_sampled3    
  @Associate VARCHAR(50),      
  @Client VARCHAR(50),      
  @Study VARCHAR(50),      
  @Survey VARCHAR(50),      
  @FirstSampleSet DATETIME,      
  @LastSampleSet DATETIME,    
  @IncludeUnits VARCHAR(20)    
 AS      
     
 -- Modified 5/6/05 SJS 	: Added @ordername to fix DSQL because previous code failed when the study did not have a FName and LName column (ie. DrFirstName, DrLastName....)      
 -- Modified 6/16/05 SJS	: Added param to allow sampleunit name to be returned,  Including sampleunit will duplicate names.
 -- Modified 6/30/05 SJS	: Added _ALL survey selection, Added choice of NO Units, Direct Units, or AllUnits
     
 /******************/      
 /* Test Variables */    
-- DECLARE @Associate VARCHAR(50), @Client VARCHAR(50), @Study VARCHAR(50), @Survey VARCHAR(50), @FirstSampleSet DATETIME, @LastSampleSet DATETIME, @IncludeUnits VARCHAR(20)    
-- -- Study w/ Encounter table    
-- SELECT    
--  @Associate = 'sspicka',    
--  @Client = 'Adventist Health System',     
--  @Study = 'IP/OP/ER',    
-- --@Survey = '6806SON',    
-- @Survey = '_ALL',    
--  @FirstSampleSet = '2/18/2004 3:32:03 PM',     
--  @LastSampleSet = '2/18/2004 3:32:03 PM',    
--  @IncludeUnits = 'NoUnits'     
 /******************/    
  
 --EXEC master.dbo.xp_sendmail @recipients='bdohmen', @subject='qp_rep_people_sampled', @message=@Associate      
       
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
DECLARE @Study_id INT, @Survey_id INT, @sql VARCHAR(900), @ordername VARCHAR(30)      

IF @survey = '_ALL'
	SELECT TOP 1 @Study_id=Study_id, @Ordername = '' FROM ClientStudySurvey_view WHERE strClient_nm=@Client AND strStudy_nm=@Study
ELSE
	SELECT TOP 1 @Survey_id=Survey_id, @Study_id=Study_id, @Ordername = '' FROM ClientStudySurvey_view WHERE strClient_nm=@Client AND strStudy_nm=@Study AND strSurvey_nm=@Survey      
  
CREATE TABLE #sampleset (sampleset_id INT, [Date Sampled] VARCHAR(19))  
       
IF @survey = '_ALL'  
  BEGIN  
   INSERT INTO #sampleset  
   SELECT SampleSet_id, CONVERT(VARCHAR(19),datSampleCreate_dt,120) AS 'Date Sampled'      
   FROM sampleset ss, survey_def sd WHERE ss.survey_id = sd.survey_id AND sd.study_id = @study_id  
   AND CONVERT(VARCHAR,datSampleCreate_dt,120) BETWEEN CONVERT(VARCHAR,@FirstSampleSet,120) AND CONVERT(VARCHAR,@LastSampleSet,120)      
  END  
 ELSE  
  BEGIN  
   INSERT INTO #sampleset  
   SELECT SampleSet_id, CONVERT(VARCHAR(19),datSampleCreate_dt,120) AS 'Date Sampled'      
   FROM SampleSet      
   WHERE Survey_id=@Survey_id      
   AND CONVERT(VARCHAR,datSampleCreate_dt,120) BETWEEN CONVERT(VARCHAR,@FirstSampleSet,120) AND CONVERT(VARCHAR,@LastSampleSet,120)      
  END  
       
 SELECT sp.SamplePop_id, ISNULL(MIN(strLithoCode),'NotPrinted') Litho, [Date Sampled]      
 INTO #SamplePop       
 FROM #SampleSet ss, SamplePop sp LEFT OUTER JOIN ScheduledMailing schm ON sp.SamplePop_id=schm.SamplePop_id      
  LEFT OUTER JOIN SentMailing sm ON schm.SentMail_id=sm.SentMail_id      
 WHERE ss.SampleSet_id=sp.SampleSet_id      
 GROUP BY sp.SamplePop_id, [Date Sampled]      
     
 IF EXISTS (SELECT * FROM METADATA_VIEW WHERE STUDY_iD = @study_id AND strField_Nm IN ('FName','LName'))      
  SET @ordername = ' , FName, LName'      

 IF @IncludeUnits = 'NoUnits'    
  IF EXISTS(SELECT strTable_nm FROM MetaTable WHERE Study_id=@Study_id AND strTable_nm='Encounter')      
  SET @SQL='SELECT DISTINCT ss.survey_id AS Survey, sp.SampleSet_id AS ''Sample Set'', Litho, CASE WHEN ISNUMERIC(Litho)=1 THEN dbo.LithoToBarCode(Litho,1) ELSE Litho END BarCode,'+CHAR(10)+      
  '[Date Sampled], p.*, e.*'+CHAR(10)+      
  'FROM S'+CONVERT(VARCHAR,@Study_id)+'.Population p, SamplePop sp, #SamplePop t, SelectedSample sel, Sampleset ss, S'+CONVERT(VARCHAR,@Study_id)+'.Encounter e'+CHAR(10)+      
  'WHERE t.SamplePop_id=sp.SamplePop_id'+CHAR(10)+      
  'AND sp.Pop_id=p.Pop_id'+CHAR(10)+      
  'AND sp.Pop_id=sel.Pop_id'+CHAR(10)+      
  'AND sp.SampleSet_id=sel.SampleSet_id'+CHAR(10)+      
  'AND sp.SampleSet_id=ss.SampleSet_id'+CHAR(10)+      
  'AND sel.Enc_id=e.Enc_id'+CHAR(10)+     
  'ORDER BY sp.SampleSet_id, [Date Sampled]' + @Ordername      
  ELSE      
  SET @sql='SELECT DISTINCT ss.survey_id AS Survey, sp.SampleSet_id AS ''Sample Set'', Litho, CASE WHEN ISNUMERIC(Litho)=1 THEN dbo.LithoToBarCode(Litho,1) ELSE Litho END BarCode,'+CHAR(10)+      
  '[Date Sampled], p.*'+CHAR(10)+      
  'FROM S'+CONVERT(VARCHAR,@Study_id)+'.Population p, SamplePop sp, Sampleset ss, #SamplePop t'+CHAR(10)+      
  'WHERE t.SamplePop_id=sp.SamplePop_id'+CHAR(10)+      
  'AND sp.Pop_id=p.Pop_id'+CHAR(10)+      
  'AND sp.SampleSet_id=ss.SampleSet_id'+CHAR(10)+      
  'ORDER BY sp.SampleSet_id, [Date Sampled]' + @Ordername      
   
 IF @IncludeUnits = 'DirectUnits'    
  IF EXISTS(SELECT strTable_nm FROM MetaTable WHERE Study_id=@Study_id AND strTable_nm='Encounter')      
  SET @SQL='SELECT DISTINCT ss.survey_id AS Survey, sp.SampleSet_id AS ''Sample Set'', su.Sampleunit_id AS SampleUnit, /*su.strSampleUnit_nm AS ''SampleUnit'',*/ sel.strUnitSelectType AS UnitSelectType, Litho, ' + CHAR(10) + 
  'CASE WHEN ISNUMERIC(Litho)=1 THEN dbo.LithoToBarCode(Litho,1) ELSE Litho END BarCode,'+CHAR(10)+      
  '[Date Sampled], p.*, e.*'+CHAR(10)+      
  'FROM S'+CONVERT(VARCHAR,@Study_id)+'.Population p, SamplePop sp, Sampleset ss, #SamplePop t, SelectedSample sel, S'+CONVERT(VARCHAR,@Study_id)+'.Encounter e, sampleunit su'+CHAR(10)+      
  'WHERE t.SamplePop_id=sp.SamplePop_id'+CHAR(10)+      
  'AND sp.Pop_id=p.Pop_id'+CHAR(10)+      
  'AND sp.Pop_id=sel.Pop_id'+CHAR(10)+      
  'AND sp.SampleSet_id=sel.SampleSet_id'+CHAR(10)+      
  'AND sp.SampleSet_id=ss.SampleSet_id'+CHAR(10)+      
  'AND sel.Enc_id=e.Enc_id'+CHAR(10)+     
  'AND sel.sampleunit_id=su.sampleunit_id'+CHAR(10)+     
  'AND sel.strUnitSelectType = ''D''' + CHAR(10) +   
  'ORDER BY sp.SampleSet_id, [Date Sampled]' + @Ordername      
  ELSE      
  SET @sql='SELECT DISTINCT ss.survey_id AS Survey, sp.SampleSet_id AS ''Sample Set'', su.Sampleunit_id AS SampleUnit, /*su.strSampleUnit_nm AS ''SampleUnit'',*/ sel.strUnitSelectType AS UnitSelectType, Litho, ' + CHAR(10) + 
  'CASE WHEN ISNUMERIC(Litho)=1 THEN dbo.LithoToBarCode(Litho,1) ELSE Litho END BarCode,'+CHAR(10)+      
  '[Date Sampled], p.*'+CHAR(10)+      
  'FROM S'+CONVERT(VARCHAR,@Study_id)+'.Population p, SamplePop sp, Sampleset ss, #SamplePop t, SelectedSample sel, SampleUnit su'+CHAR(10)+      
  'WHERE t.SamplePop_id=sp.SamplePop_id'+CHAR(10)+      
  'AND sp.Pop_id=p.Pop_id'+CHAR(10)+      
  'AND sp.Pop_id=sel.Pop_id'+CHAR(10)+      
  'AND sp.sampleset_id=sel.sampleset_id'+CHAR(10)+      
  'AND sp.SampleSet_id=ss.SampleSet_id'+CHAR(10)+      
  'AND sel.sampleunit_id=su.sampleunit_id'+CHAR(10)+      
  'AND sel.strUnitSelectType = ''D''' + CHAR(10) +   
  'ORDER BY sp.SampleSet_id, [Date Sampled]' + @Ordername      
   
 IF @IncludeUnits = 'AllUnits'    
  IF EXISTS(SELECT strTable_nm FROM MetaTable WHERE Study_id=@Study_id AND strTable_nm='Encounter')      
  SET @SQL='SELECT DISTINCT ss.survey_id AS Survey, sp.SampleSet_id AS ''Sample Set'', su.Sampleunit_id AS SampleUnit, /*su.strSampleUnit_nm AS ''SampleUnit'',*/ sel.strUnitSelectType AS UnitSelectType, Litho, ' + CHAR(10) + 
  'CASE WHEN ISNUMERIC(Litho)=1 THEN dbo.LithoToBarCode(Litho,1) ELSE Litho END BarCode,'+CHAR(10)+      
  '[Date Sampled], p.*, e.*'+CHAR(10)+      
  'FROM S'+CONVERT(VARCHAR,@Study_id)+'.Population p, SamplePop sp, Sampleset ss, #SamplePop t, SelectedSample sel, S'+CONVERT(VARCHAR,@Study_id)+'.Encounter e, sampleunit su'+CHAR(10)+      
  'WHERE t.SamplePop_id=sp.SamplePop_id'+CHAR(10)+      
  'AND sp.Pop_id=p.Pop_id'+CHAR(10)+      
  'AND sp.Pop_id=sel.Pop_id'+CHAR(10)+      
  'AND sp.SampleSet_id=sel.SampleSet_id'+CHAR(10)+      
  'AND sp.SampleSet_id=ss.SampleSet_id'+CHAR(10)+      
  'AND sel.Enc_id=e.Enc_id'+CHAR(10)+     
  'AND sel.sampleunit_id=su.sampleunit_id'+CHAR(10)+     
  'ORDER BY sp.SampleSet_id, [Date Sampled]' + @Ordername      
  ELSE      
  SET @sql='SELECT DISTINCT ss.survey_id AS Survey, sp.SampleSet_id AS ''Sample Set'', su.Sampleunit_id AS SampleUnit, /*su.strSampleUnit_nm AS ''SampleUnit'',*/ sel.strUnitSelectType AS UnitSelectType, Litho, ' + CHAR(10) + 
  'CASE WHEN ISNUMERIC(Litho)=1 THEN dbo.LithoToBarCode(Litho,1) ELSE Litho END BarCode,'+CHAR(10)+      
  '[Date Sampled], p.*'+CHAR(10)+      
  'FROM S'+CONVERT(VARCHAR,@Study_id)+'.Population p, SamplePop sp, Sampleset ss, #SamplePop t, SelectedSample sel, SampleUnit su'+CHAR(10)+      
  'WHERE t.SamplePop_id=sp.SamplePop_id'+CHAR(10)+      
  'AND sp.Pop_id=p.Pop_id'+CHAR(10)+    
  'AND sp.Pop_id=sel.Pop_id'+CHAR(10)+      
  'AND sp.sampleset_id=sel.sampleset_id'+CHAR(10)+      
  'AND sp.SampleSet_id=ss.SampleSet_id'+CHAR(10)+      
  'AND sel.sampleunit_id=su.sampleunit_id'+CHAR(10)+      
  'ORDER BY sp.SampleSet_id, [Date Sampled]' + @Ordername      
   
 --SELECT @sql      
 EXEC (@sql)      
       
 DROP TABLE #SAMPLESET      
 DROP TABLE #SAMPLEPOP  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


