CREATE PROCEDURE WebPref_PopulateValues    
AS    
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    
    
DECLARE @sql VARCHAR(8000), @Study VARCHAR(10), @HasEncounter BIT, @MethodName VARCHAR(42), @ViewName VARCHAR(60)    
    
--What needs to be done?    
SELECT Study_id, q.Survey_id, Litho, BarCode    
INTO #Work    
FROM WebSurveyQueue q, Survey_def sd    
WHERE bitPopulatedValues=0    
AND q.Survey_id=sd.Survey_id    
    
CREATE INDEX tmpIndex ON #Work (Study_id, Litho)    
    
CREATE TABLE #RootUnits (SampleUnit_id INT, Survey_id INT)    
    
INSERT INTO #RootUnits    
SELECT MIN(SampleUnit_id), w.Survey_id    
FROM (SELECT DISTINCT Survey_id FROM #Work) w, SamplePlan sp, SampleUnit su    
WHERE w.Survey_id=sp.Survey_id    
AND sp.SamplePlan_id=su.SamplePlan_id    
GROUP BY w.Survey_id    
    
--Loop at a study level    
SELECT TOP 1 @Study=LTRIM(STR(Study_id)) FROM #Work    
    
WHILE @@ROWCOUNT>0    
BEGIN    
     
 IF EXISTS (SELECT * FROM MetaTable WHERE Study_id=@Study AND strTable_nm='Encounter')    
  SELECT @HasEncounter=1    
 ELSE     
  SELECT @HasEncounter=0    
     
 CREATE TABLE #Values (Survey_id INT, Litho VARCHAR(20), BarCode VARCHAR(20), Pop_id INT, Enc_id INT, SampleSet_id INT)    
     
 IF @HasEncounter=0    
 BEGIN    
  INSERT INTO #Values (Survey_id, Litho, BarCode, Pop_id, SampleSet_id)    
  SELECT w.Survey_id, w.Litho, w.BarCode, sp.Pop_id, sp.SampleSet_id    
  FROM #Work w, SentMailing sm, ScheduledMailing schm, SamplePop sp    
  WHERE w.Study_id=@Study    
  AND w.Litho=sm.strLithoCode    
  AND sm.SentMail_id=schm.SentMail_id    
  AND schm.SamplePop_id=sp.SamplePop_id    
 END    
 ELSE    
 BEGIN    
  INSERT INTO #Values (Survey_id, Litho, BarCode, Pop_id, Enc_id, SampleSet_id)    
  SELECT w.Survey_id, w.Litho, w.BarCode, sp.Pop_id, ss.Enc_id, sp.SampleSet_id    
  FROM #Work w, SentMailing sm, ScheduledMailing schm, SamplePop sp, SelectedSample ss, #RootUnits t    
  WHERE w.Study_id=@Study    
  AND w.Litho=sm.strLithoCode    
  AND sm.SentMail_id=schm.SentMail_id    
  AND schm.SamplePop_id=sp.SamplePop_id    
  AND sp.SampleSet_id=ss.SampleSet_id    
  AND sp.Pop_id=ss.Pop_id    
  AND ss.SampleUnit_id=t.SampleUnit_id    
 END    
     
 --Now to add the needed fields to the #Values table    
 --Get the distinct fields needed    
 SELECT DISTINCT wsf.strField_nm, strFieldDataType, wsf.strTable_nm+wsf.strField_nm ViewField, MethodName    
 INTO #Fields    
 FROM WebSurveyFields wsf, MetaData_View mf, Survey_def sd    
 WHERE mf.Study_id=@Study    
 AND wsf.Field_id=mf.Field_id    
 AND sd.Study_id=mf.Study_id    
 AND sd.Survey_id=wsf.Survey_id    


--mwb 5/6/08  Added if check to keep from empty #fields table from causing dyanmic sql error.
if (select count(*) from #Fields) > 0
begin
     
	 SELECT @sql='ALTER TABLE #Values ADD '    
	 SELECT @sql=@sql+ViewField+' VARCHAR(100),' FROM #Fields    
	 SELECT @sql=LEFT(@sql,LEN(@sql)-1)    
	 --PRINT @sql     
	 EXEC (@sql)   

     
	 --Now to populate the personalization in #values table    
	 SELECT @sql=''    
	 SELECT @sql=@sql+',v.'+ViewField+'='+CASE WHEN strFieldDataType='D' THEN 'DATENAME(MONTH,b.'+ViewField+')+'' ''+LTRIM(STR(DATEPART(DAY,b.'+ViewField+')))+'', ''+LTRIM(STR(YEAR(b.'+ViewField+')))'    
	  ELSE 'b.'+ViewField END    
	  FROM #Fields    
	 SELECT @sql='UPDATE v SET v.Pop_id=v.Pop_id'+@sql+    
	  ' FROM #Values v, S'+@Study+'.Big_View b    
	  WHERE '+CASE WHEN @HasEncounter=0 THEN 'v.Pop_id=b.PopulationPop_id' ELSE 'v.Enc_id=b.EncounterEnc_id' END    
	--  PRINT @sql     
	 EXEC (@sql)    

end  
    
 INSERT INTO #Fields (strField_nm, strFieldDataType, ViewField, MethodName)    
 SELECT 'Litho', 'S', 'Litho', 'Litho'    
 UNION    
 SELECT 'BarCode', 'S', 'BarCode', 'PIN'    
 UNION    
 SELECT 'SampleSet_id', 'I', 'SampleSet_id', 'SampleSet_id'    
     
 --Now to transfer the values from #Values to WebSurveyValues    
 SELECT TOP 1 @ViewName=ViewField, @MethodName=MethodName FROM #Fields ORDER BY MethodName    
 WHILE @@ROWCOUNT>0    
 BEGIN    
      
  SELECT @sql='INSERT INTO WebSurveyValues (Survey_id, BarCode, MethodName, MethodValue)    
   SELECT Survey_id, BarCode, '''+@MethodName+''','+@ViewName+'    
   FROM #Values'    
-- PRINT @sql     
  EXEC (@sql)    
      
  DELETE #Fields WHERE ViewField=@ViewName AND MethodName=@MethodName    
     
  SELECT TOP 1 @ViewName=ViewField, @MethodName=MethodName FROM #Fields ORDER BY MethodName    
     
 END    
     
 DROP TABLE #Values    
 DROP TABLE #Fields    
     
 UPDATE q    
 SET bitPopulatedValues=1    
 FROM #Work w, WebSurveyQueue q    
 WHERE bitPopulatedValues=0    
 AND q.Survey_id=w.Survey_id    
 AND q.Litho=w.Litho    
     
 DELETE #Work WHERE Study_id=@Study    
     
 SELECT TOP 1 @Study=LTRIM(STR(Study_id)) FROM #Work    
    
END    
    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
SET NOCOUNT OFF


