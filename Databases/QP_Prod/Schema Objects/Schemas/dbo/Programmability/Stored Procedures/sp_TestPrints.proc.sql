CREATE PROCEDURE sp_TestPrints    
@Survey_id INT, @Sexes CHAR(2)='DC', @Ages CHAR(2)='DC',  -- DC=Don't Care    
@bitSchedule BIT=0, @bitMockup BIT=1, @Languages VARCHAR(20)='1', @Covers VARCHAR(20)='',    
@Employee_id INT=0, @eMail VARCHAR(50)=''    
AS    

/*
--create table drm_tmp_tp (Survey_id INT, Sexes CHAR(2), Ages CHAR(2), 
--bitSchedule BIT, bitMockup BIT, Languages VARCHAR(20), Covers VARCHAR(20),
--Employee_id INT, eMail VARCHAR(50))

insert into drm_tmp_tp select @Survey_id , @Sexes , @Ages , 
@bitSchedule , @bitMockup , @Languages , @Covers ,
@Employee_id , @eMail 
*/


DECLARE @SampleSet_id INT, @Study_id INT, @sql VARCHAR(8000), @Valid BIT    
    
SELECT @Study_id=Study_id, @Valid=bitValidated_flg    
FROM Survey_def    
WHERE Survey_id=@Survey_id    
    
IF @Valid=0    
 RETURN 1    
    
IF NOT EXISTS (SELECT *     
 FROM sysobjects     
 WHERE id=object_id(N'[s'+CONVERT(VARCHAR,@Study_id)+'].[Population]')     
 AND OBJECTPROPERTY(id, N'IsTable')=1)    
 RETURN 2    
    
CREATE TABLE #SampleSet (SampleSet_id INT, intcount INT)    
    
SELECT @SampleSet_id=MAX(ss.SampleSet_id)    
FROM SampleSet ss INNER JOIN SamplePop sp ON sp.SampleSet_id=ss.SampleSet_id    
WHERE Survey_id=@Survey_id    
    
IF @SampleSet_id IS NULL -- i.e. no samples have been pulled for the Survey yet    
BEGIN    
 RETURN 3    
END    
 ELSE     
BEGIN    
 WHILE @SampleSet_id IS NOT NULL     
 BEGIN    
  INSERT INTO #SampleSet    
  SELECT SampleSet_id, COUNT(*)    
  FROM SamplePop    
  WHERE SampleSet_id=@SampleSet_id    
  GROUP BY SampleSet_id    
     
  IF (SELECT SUM(intCount) FROM #SampleSet)<1000    
  BEGIN    
   SELECT @SampleSet_id=MAX(ss.SampleSet_id)    
   FROM SampleSet ss INNER JOIN SamplePop sp ON sp.SampleSet_id=ss.SampleSet_id    
   WHERE Survey_id=@Survey_id    
   AND ss.SampleSet_id NOT IN (SELECT SampleSet_id FROM #SampleSet)    
   AND datSampleCreate_dt>(SELECT MAX(datChanged)     
        FROM auditlog     
        WHERE Survey_id=@Survey_id    
        AND module_nm='SampleEditor'    
        AND audittype_id=1)    
  END ELSE     
   SET @SampleSet_id=NULL    
 END    
END    
    
CREATE TABLE #UniqueSections (Pop_id INT, SampleSet_id INT, Sections VARCHAR(1000), intFlag INT)    
    
INSERT INTO #UniqueSections    
     SELECT DISTINCT Pop_id, ss.SampleSet_id, '', 0    
     FROM SelectedSample ss, #SampleSet s    
     WHERE ss.SampleSet_id=s.SampleSet_id    
    
SELECT DISTINCT SelQstnsSection, 0 intFlag    
INTO #Sections    
FROM SampleUnitSection sus, Sel_Qstns sq    
WHERE sus.SelQstnsSurvey_ID=@Survey_id     
AND sus.SelQstnsSection>-1    
AND sus.SelQstnsSurvey_id=sq.Survey_id    
AND sus.SelQstnsSection=sq.Section_id    
ORDER BY 1    
    
WHILE @@ROWCOUNT>0    
BEGIN    
 SET @SQL=''    
    
 SET ROWCOUNT 20    
 UPDATE #Sections SET intFlag=1    
 SET ROWCOUNT 0    
    
 SELECT @sql=@sql+'    
 UPDATE us    
 SET Sections=Sections + '''+RIGHT(CONVERT(CHAR(3),100+SelQstnsSection),2)+' ''    
 FROM #UniqueSections us, SampleUnitSection sus, SelectedSample ss, #SampleSet s    
 WHERE us.Pop_id=ss.Pop_id    
        AND us.SampleSet_id=ss.SampleSet_id    
 AND sus.SampleUnit_id=ss.SampleUnit_id     
 AND ss.SampleSet_id=s.SampleSet_id    
 AND sus.SelQstnsSection='+CONVERT(VARCHAR,SelQstnsSection)    
 FROM #Sections    
 WHERE intFlag=1    
    
 DELETE FROM #Sections WHERE intFlag=1    
 IF @@ROWCOUNT>0 EXEC (@SQL)    
    
END    
    
DROP TABLE #Sections    
    
SET @sql='SELECT MAX(us.Pop_id) Pop_id    
FROM #UniqueSections us, s'+CONVERT(VARCHAR,@Study_id)+'.Population p    
WHERE us.Pop_id=p.Pop_id '    
    
IF @Sexes <> 'DC'     
SET @SQL=@SQL + 'AND Sex IN ('''+LEFT(@Sexes,1)+''','''+RIGHT(@Sexes,1)+''') '    
IF @Ages <> 'DC'    
SET @SQL=@SQL + 'AND CASE WHEN Age<18 THEN ''M'' ELSE ''A'' END IN ('''+LEFT(@Ages,1)+''','''+RIGHT(@Ages,1)+''') '    
    
SET @SQL=@SQL + 'GROUP BY Sections'    
    
IF @Sexes<>'DC' SET @SQL=@SQL+', Sex'    
IF @Ages<>'DC' SET @SQL=@SQL+', CASE WHEN Age<18 THEN ''M'' ELSE ''A'' END'    
    
SET @SQL='UPDATE #UniqueSections SET intFlag=1 WHERE Pop_id IN ('+@sql+')'    
EXEC (@SQL)    
    
-- dedup to a Unique Pop_id, SampleSet, Sections combination    
SELECT Pop_id, Sections, MAX(SampleSet_id) SampleSet_id    
INTO #dedup    
FROM #UniqueSections    
WHERE intFlag=1    
GROUP BY Pop_id, Sections    
    
UPDATE us    
SET intFlag=0    
FROM #dedup d, #UniqueSections us    
WHERE d.Pop_id=us.Pop_id    
AND d.Sections=us.Sections    
AND d.SampleSet_id<>us.SampleSet_id    
    
DROP TABLE #dedup    
    
IF @bitSchedule=0    
BEGIN    
 SET @SQL=''''''    
    
 -- grab whatever Fields are associated with name Codes FROM the address label    
 SELECT @SQL=@SQL+'+cast(ISNULL('+strField_nm+','''') as varchar)+'' '''    
 FROM CodeQstns cq, Sel_Qstns sq, Codes c, CodesText ct, CodeTextTag ctt, Tag t,    
 TagField tf, MetaField mf    
 WHERE cq.SelQstns_id=sq.SelQstns_id    
 AND cq.Survey_id=sq.Survey_id    
 AND cq.Survey_id=@Survey_id    
 AND cq.Language=sq.Language    
 AND sq.Section_id=-1    
 AND sq.Language=1    
 AND sq.subtype=6    
 AND cq.Code=c.Code    
 AND c.description LIKE '%name%'    
 AND c.Code=ct.Code    
 AND ct.CodeText_id=ctt.CodeText_id    
 AND ctt.Tag_id=tf.Tag_id    
 AND tf.Study_id=@Study_id    
 AND tf.Field_id=mf.Field_id    
 GROUP BY mf.strField_nm    
 ORDER BY MIN(ctt.intStartpos)    
    
 -- grab whatever literals are associated with name Codes FROM the address label    
 SELECT @SQL=@SQL + '+'''+strReplaceLiteral + ' '''    
 FROM CodeQstns cq, Sel_Qstns sq, Codes c, CodesText ct, CodeTextTag ctt,     
 Tag t, TagField tf    
 WHERE cq.SelQstns_id=sq.SelQstns_id    
 AND cq.Survey_id=sq.Survey_id    
 AND cq.Survey_id=@Survey_id    
 AND cq.Language=sq.Language    
 AND sq.Section_id=-1    
 AND sq.Language=1    
 AND sq.label='Address information'    
 AND cq.Code=c.Code    
 AND c.description LIKE '%name%'    
 AND c.Code=ct.Code    
 AND ct.CodeText_id=ctt.CodeText_id    
 AND ctt.Tag_id=tf.Tag_id    
 AND tf.Study_id=@Study_id    
 AND tf.Field_id IS NULL    
 GROUP BY strReplaceLiteral    
 ORDER BY MIN(ctt.intStartpos)    
    
 SET @SQL='SELECT '+CONVERT(VARCHAR,@Survey_id)+' Survey_id, sp.Study_id,    
 p.Pop_id, sp.SamplePop_id,     
 '+@SQL+' name, Age, Sex, Sections    
 FROM #UniqueSections us, s'+CONVERT(VARCHAR,@Study_id)+'.Population p,     
 SamplePop sp, #SampleSet s    
 WHERE us.Pop_id=p.Pop_id    
        AND us.SampleSet_id=sp.SampleSet_id    
 AND us.intFlag=1    
 AND p.Pop_id=sp.Pop_id    
 AND sp.Study_id='+CONVERT(VARCHAR,@Study_id)+'    
 AND sp.SampleSet_id=s.SampleSet_id'    
    
 EXEC (@SQL)    
END    
 ELSE -- @bitSchedule=1    
BEGIN    
 CREATE TABLE #Language (LangID INT, Language VARCHAR(20))     
 SET @SQL='INSERT INTO #Language     
  SELECT l.LangID, l.Language     
  FROM Languages l, SurveyLanguage sl     
  WHERE sl.Survey_id='+CONVERT(VARCHAR,@Survey_id)+'     
  AND l.Langid=sl.Langid     
  AND l.Langid IN ('+@Languages+')'    
 EXEC (@SQL)    
 IF @@ROWCOUNT=0    
  RETURN 4    
    
 CREATE TABLE #Cover (Cover_id INT, MailingStep_id INT)    
 set @SQL='insert into #Cover     
 SELECT SelCover_id, MIN(MailingStep_id)     
 FROM MailingStep WHERE Survey_id='+CONVERT(VARCHAR,@Survey_id)+'     
 AND selCover_id IN ('+@Covers+') GROUP BY selCover_id'    
 EXEC (@SQL)    
 IF @@ROWCOUNT=0    
  RETURN 5    
    
 IF NOT EXISTS (SELECT * FROM Employee WHERE Employee_id=@Employee_id)    
  RETURN 6    
    
 IF NOT EXISTS (SELECT * FROM Employee WHERE streMail=@eMail)    
  RETURN 7    
    
 BEGIN TRANSACTION    
 INSERT INTO Scheduled_TP (Study_id, Survey_id, SampleSet_id, Pop_id,    
 methodology_id, MailingStep_id, OverRideItem_id, [Language], bitMockup,    
 strSections, streMail, Employee_id, bitDone, datScheduled)    
 SELECT @Study_id, @Survey_id, s.SampleSet_id, sp.Pop_id, methodology_id,    
 c.MailingStep_id, NULL, l.Langid, @bitMockup, Sections, @eMail, @Employee_id,     
 0, GETDATE()    
 FROM #UniqueSections us, SamplePop sp, #SampleSet s, #Cover c, #Language l,    
 MailingMethodology mm    
 WHERE us.intFlag=1    
 AND us.Pop_id=sp.Pop_id    
        AND us.SampleSet_id=sp.SampleSet_id    
 AND sp.Study_id=@Study_id    
 AND sp.SampleSet_id=s.SampleSet_id    
 AND mm.Survey_id=@Survey_id    
 AND mm.bitActiveMethodology=1    
 IF @@ROWCOUNT=0    
 BEGIN    
  ROLLBACK TRAN    
  RAISERROR ('Unable to schedule test prints.  Please verify that an active mailing methodology exists.',15,1)    
  RETURN 8    
 END    
 WAITFOR DELAY '00:00:00.01'    
    
 COMMIT TRANSACTION    
 DROP TABLE #Cover    
 DROP TABLE #Language    
END    
    
DROP TABLE #UniqueSections    
DROP TABLE #SampleSet    
    
RETURN 0


