/*      
Business Purpose:       
This procedure is used to get all individuals who are eligible for an       
HCAHPS unit.      
      
Created:  07/6/2006 by DC      
      
Modified:      
Modified 8/21/07 - SJS - Removed application of Criteria AND DQ rules against #BVUK    
Modified 10/5/07 - MWB - Modification on 8/21/07 - SJS above should not have commented out "+ @strDateWhere" piece.        
Modified 1/18/08 - DJK - Added MSDRG to fields pulled
*/        
CREATE PROCEDURE [dbo].[QP_REP_HCAHPSAllEligibleRecords]  
    @Survey_ID INT,      
    @encounterStart DATETIME,       
    @encounterEnd DATETIME      
as
    
-- declare     
--  @Survey_ID INT,      
--     @encounterStart DATETIME,       
--     @encounterEnd DATETIME      
-- set @survey_Id = 6    
-- set @encounterstart = '2005-01-01'    
-- set @encounterstart = '2007-08-21'    
--       
      
SET NOCOUNT ON      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
      
      
DECLARE @Study_id INT, @sampleunit_id INT, @shortName varchar(50),@FieldName varchar(50),      
  @Sel VARCHAR(8000), @SampleUnit INT, @strDateWHERE VARCHAR(150),      
  @Where1 VARCHAR(8000), @Where2 VARCHAR(8000), @Where3 VARCHAR(8000),      
  @Where4 VARCHAR(8000), @Where5 VARCHAR(8000), @Where6 VARCHAR(8000),      
  @Where7 VARCHAR(8000), @Where8 VARCHAR(8000), @Where9 VARCHAR(8000),      
  @Where10 VARCHAR(8000),@fields varchar(5000), @DQCriter varchar(8000),      
  @TotalCount int, @EncounterExists bit      
      
SELECT  @Where1='', @Where2='', @Where3='',      
  @Where4='', @Where5='', @Where6='',      
  @Where7='', @Where8='', @Where9='',      
  @Where10='', @EncounterExists=0      
      
select @study_id=study_id      
from survey_def      
where survey_id=@survey_id      
      
DECLARE @FROMDate VARCHAR(10), @ToDate VARCHAR(10)      
      
SET @FROMDate=CONVERT(VARCHAR,@encounterStart,101)      
SET @toDate=CONVERT(VARCHAR,@encounterEnd,101)      
      
SELECT @strDateWhere=' AND (reportdate BETWEEN '''+@FROMDate+''' AND '''+CONVERT(VARCHAR,@ToDate)+' 23:59:59'')'      
      
--get the list of Fields needed for evaluating DQ rules      
DECLARE @tbl TABLE (Fieldname VARCHAR(50), DataType VARCHAR(20), Length INT, Field_id INT, OrderName varchar(51))      
DECLARE @HCAHPStbl TABLE (Fieldname VARCHAR(50), shortName varchar(51))      
      
INSERT INTO @tbl       
SELECT DISTINCT strTable_nm+strField_nm, STRFIELDDATATYPE, INTFIELDLENGTH, Field_id,       
 case      
   when strfield_nm in ('DRG','MSDRG','hadmissionsource','hservicetype','hvisittype','hdischargestatus', --djk01182007 added MSDRG     
         'hadmitage','hcatage','sex', 'DOB', 'AdmitDate') then ' ' + right('000000000' + convert(varchar,field_id),8)      
   else right('000000000' + convert(varchar,field_id),9)      
 end as OrderName      
FROM MetaData_View       
WHERE Study_id=@Study_id    

IF EXISTS(Select strTable_nm From MetaData_View WHERE Study_id=@Study_id and strTable_nm='Encounter') SET @EncounterExists=1      
      
INSERT INTO @HCAHPStbl (shortName) VALUES('DRG')      
INSERT INTO @HCAHPStbl (shortName) VALUES('MSDRG')  --djk01182007 added MSDRG
INSERT INTO @HCAHPStbl (shortName) VALUES('HAdmissionSource')      
INSERT INTO @HCAHPStbl (shortName) VALUES('HServiceType')      
INSERT INTO @HCAHPStbl (shortName) VALUES('HVisitType')      
INSERT INTO @HCAHPStbl (shortName) VALUES('HDischargeStatus')      
INSERT INTO @HCAHPStbl (shortName) VALUES('HAdmitAge')      
INSERT INTO @HCAHPStbl (shortName) VALUES('HCatAge')      
INSERT INTO @HCAHPStbl (shortName) VALUES('Sex')      
INSERT INTO @HCAHPStbl (shortName) VALUES('DOB')      
INSERT INTO @HCAHPStbl (shortName) VALUES('AdmitDate')      
     
UPDATE @HCAHPStbl       
SET Fieldname=strTable_nm+strField_nm      
FROM @HCAHPStbl H, MetaData_View m      
WHERE Study_id=@Study_id      
 AND H.shortName=m.strField_nm      

CREATE TABLE #BVUK (DummyField INT)      
      
SET @sel='ALTER TABLE #BVUK ADD ,'      
      
SELECT @sel=@sel+      
 ','+      
 FieldName+' '+      
 CASE DataType WHEN 'I' THEN 'INT ' WHEN 'D' THEN 'DATETIME ' ELSE 'VARCHAR('+CONVERT(VARCHAR,Length)+')' END      
FROM @tbl      
ORDER BY OrderName      
      
Set @sel=replace(@sel,',,','')    

EXEC (@Sel)      
      
ALTER TABLE #BVUK       
 DROP COLUMN DummyField      
      
--build the SELECT list for later use      
SET @fields=''      
      
SELECT @fields=@fields+','+Fieldname      
FROM @tbl      
ORDER BY OrderName  

SET @fields=substring(@fields,2,len(@fields)-1)      
      
CREATE TABLE  #Criters (Survey_id INT, Sampleunit_id INT, CriteriaStmt_id INT, strCriteriaStmt VARCHAR(7900), BusRule_cd VARCHAR(20), bitKeep bit default 0)              
CREATE TABLE  #UnitCriters (Survey_id INT, Sampleunit_id INT, CriteriaStmt_id INT, strCriteriaStmt VARCHAR(7900), BusRule_cd VARCHAR(20), bitKeep bit default 0)              
CREATE TABLE  #DQCriters (Survey_id INT, Sampleunit_id INT, CriteriaStmt_id INT, strCriteriaStmt VARCHAR(7900), BusRule_cd VARCHAR(20), bitKeep bit default 0)              
      
INSERT INTO #Criters (Survey_id, Sampleunit_id, CriteriaStmt_id, strCriteriaStmt, BusRule_cd)       
    
SELECT Survey_id, su.Sampleunit_id, c.CriteriaStmt_id, strCriteriaString, 'C'      
FROM CriteriaStmt c, SampleUnit su, Sampleplan sp      
WHERE c.CriteriaStmt_id=su.CriteriaStmt_id      
AND c.Study_id=@Study_id      
AND su.Sampleplan_id=sp.Sampleplan_id      
AND Survey_id=@Survey_id      
      
INSERT INTO #Criters (Survey_id, CriteriaStmt_id, strCriteriaStmt, BusRule_cd)       
SELECT Survey_id, c.CriteriaStmt_id, strCriteriaString, BusRule_cd      
FROM CriteriaStmt c, BusinessRule b      
WHERE c.CriteriaStmt_id=b.CriteriaStmt_id      
AND c.Study_id=@Study_id      
AND BusRule_cd='Q'      
AND Survey_id=@Survey_id      
      
DECLARE @Tables TABLE (Tablename VARCHAR(40))      
      
INSERT INTO @Tables      
SELECT DISTINCT strtable_nm      
FROM MetaTABLE       
WHERE Study_id=@Study_id      
      
SELECT TOP 1 @sel=Tablename FROM @Tables      
WHILE @@ROWCOUNT>0      
BEGIN      
      
 DELETE @Tables WHERE Tablename=@sel      
      
 SET @sel='UPDATE #Criters SET strCriteriaStmt=REPLACE(strCriteriaStmt,'''+@sel+'.'','''+@sel+''')'      
 EXEC (@Sel)      
      
 SELECT TOP 1 @sel=Tablename FROM @Tables      
      
END      
      
UPDATE #Criters SET strCriteriaStmt=REPLACE(strCriteriaStmt,'"','''')      
      
DECLARE @Criteria VARCHAR(7900)      
      
      
/***************************************************************************************      
Loop through each sampleunit starting here      
****************************************************************************************/      
SELECT sampleunit_id      
INTO #units      
FROM sampleunit su, sampleplan sp      
WHERE su.sampleplan_id=sp.sampleplan_id       
 AND sp.survey_id=@survey_id       
 AND su.bitHCAHPS=1      
      
SELECT TOP 1 @sampleunit_id=sampleunit_id      
FROM #units      
      
WHILE @@ROWCOUNT >0      
BEGIN      
      
 SET @Criteria=''      
      
 --loop the actual Criteria Stmts      
 SELECT @SampleUnit=@SampleUnit_id      
      
 WHILE @@ROWCOUNT>0      
 BEGIN      
      
  UPDATE #Criters      
  SET bitKeep=1      
  WHERE SampleUnit_id=@SampleUnit      
      
  SELECT @SampleUnit=parentsampleunit_id      
  FROM SampleUnit      
  WHERE sampleunit_id=@SampleUnit      
 END      
      
 INSERT INTO #UnitCriters      
 SELECT *      
 FROM #CRITERS      
 WHERE bitKeep=1      
  AND BusRule_cd='C'      
      
 INSERT INTO #DQCriters      
 SELECT *      
 FROM #CRITERS      
 WHERE BusRule_cd='Q'      
      
 --Concatenating criterias could produce a string over 8000 chars, so we must place each IN       
 --its own variable.  We assume that 10 variables will be enough      
     
IF EXISTS (SELECT TOP 1 1 FROM #UnitCriters)      
 BEGIN      
  SELECT @Where1=strCriteriaStmt      
  FROM #UnitCriters       
      
  DELETE FROM #UnitCriters WHERE strCriteriaStmt=@Where1      
 END      
      
 IF EXISTS (SELECT TOP 1 1 FROM #UnitCriters)      
 BEGIN      
  SELECT @Where2=' AND ' + strCriteriaStmt      
  FROM #UnitCriters       
      
  DELETE FROM #UnitCriters WHERE ' AND ' + strCriteriaStmt=@Where2      
 END      
      
 IF EXISTS (SELECT TOP 1 1 FROM #UnitCriters)      
 BEGIN      
  SELECT @Where3=' AND ' + strCriteriaStmt      
  FROM #UnitCriters       
      
  DELETE FROM #UnitCriters WHERE ' AND ' + strCriteriaStmt=@Where3      
 END      
      
 IF EXISTS (SELECT TOP 1 1 FROM #UnitCriters)      
 BEGIN      
  SELECT @Where4=' AND ' + strCriteriaStmt      
  FROM #UnitCriters       
      
  DELETE FROM #UnitCriters WHERE ' AND ' + strCriteriaStmt=@Where4      
 END      
      
 IF EXISTS (SELECT TOP 1 1 FROM #UnitCriters)      
 BEGIN      
  SELECT @Where5=' AND ' + strCriteriaStmt      
  FROM #UnitCriters       
      
  DELETE FROM #UnitCriters WHERE ' AND ' + strCriteriaStmt=@Where5      
 END      
      
 IF EXISTS (SELECT TOP 1 1 FROM #UnitCriters)      
 BEGIN      
  SELECT @Where6=' AND ' + strCriteriaStmt      
  FROM #UnitCriters       
      
  DELETE FROM #UnitCriters WHERE ' AND ' + strCriteriaStmt=@Where6      
 END      
      
 IF EXISTS (SELECT TOP 1 1 FROM #UnitCriters)      
 BEGIN      
  SELECT @Where7=' AND ' + strCriteriaStmt      
  FROM #UnitCriters       
      
  DELETE FROM #UnitCriters WHERE ' AND ' + strCriteriaStmt=@Where7      
 END      
      
 IF EXISTS (SELECT TOP 1 1 FROM #UnitCriters)      
 BEGIN      
  SELECT @Where8=' AND ' + strCriteriaStmt      
  FROM #UnitCriters       
      
  DELETE FROM #UnitCriters WHERE ' AND ' + strCriteriaStmt=@Where8      
 END      
      
 IF EXISTS (SELECT TOP 1 1 FROM #UnitCriters)      
 BEGIN      
  SELECT @Where9=' AND ' + strCriteriaStmt      
  FROM #UnitCriters       
      
  DELETE FROM #UnitCriters WHERE ' AND ' + strCriteriaStmt=@Where9      
 END      
      
 IF EXISTS (SELECT TOP 1 1 FROM #UnitCriters)      
 BEGIN      
  SELECT @Where10=' AND ' + strCriteriaStmt      
  FROM #UnitCriters       
      
  DELETE FROM #UnitCriters WHERE ' AND ' + strCriteriaStmt=@Where10      
 END     

 SET @sel='INSERT INTO #BVUK('+@fields+')      
  SELECT '+@fields+'      
  FROM s'+CONVERT(VARCHAR,@Study_id)+'.Big_View bv (NOLOCK), SelectedSample ss,      
   (SELECT sampleunit_id      
    FROM sampleunit su, sampleplan sp      
    WHERE su.sampleplan_id=sp.sampleplan_id       
     AND sp.survey_id=' + convert(varchar,@survey_id) +        
     ' AND su.bitHCAHPS=1) su      
  WHERE ss.sampleunit_id=su.sampleunit_id       
   AND (ss.study_id='+CONVERT(VARCHAR,@Study_id) +       
   ' AND bv.PopulationPop_id=ss.pop_id'       
      
 IF @EncounterExists=1 SET @sel=@sel+ ' AND bv.EncounterEnc_id=ss.enc_id'      
      
 --QUERY BIG VIEW      
-- PRINT (@sel +') AND ('+@Where1+@Where2+@Where3+@Where4+@Where5+@Where6+@Where7+@Where8+@Where9+@Where10+')' + @strDateWhere)      
    
-- print @sel    
-- print @where1    
-- print @where2    
-- print @where3    
-- print @where4    
-- print @where5    
-- print @where6    
-- print @where7    
-- print @where8    
-- print @where9    
-- print @where10    
-- print @strdatewhere    
    
-- Modified 8/21/07 - SJS - Removed the criteria evaluation since we already know who has been sampled via the selectedsample table.    
-- EXEC (@sel +')') --AND ('+@Where1+@Where2+@Where3+@Where4+@Where5+@Where6+@Where7+@Where8+@Where9+@Where10+')' + @strDateWhere )     
  
-- Modified 10/5/07 - MWB - Modification on 8/21/07 - SJS above should not have commented out "+ @strDateWhere" piece.    
--So I added this apart back  
EXEC (@sel +')' + @strDateWhere )     
  
      
 --Loop through DQ Rules      
--    SELECT TOP 1 @DQCriter=strCriteriaStmt      
--  FROM #DQCriters      
--       
--  WHILE @@rowcount>0      
--  BEGIN      
--   SET @SEL='DELETE FROM #BVUK      
--       WHERE ' + @DQCriter       
--       
--   --PRINT @SEL      
--   EXEC (@SEL)      
--       
--   DELETE      
--   FROM #DQCriters      
--   WHERE strCriteriaStmt=@DQCriter      
--       
--   SELECT TOP 1 @DQCriter=strCriteriaStmt      
--   FROM #DQCriters      
--  END      
      
 UPDATE #Criters      
 SET bitKeep=0      
      
 DELETE       
 FROM #UNITS      
 WHERE sampleunit_id=@sampleunit_id      
      
 SELECT TOP 1 @sampleunit_id=sampleunit_id      
 FROM #units      
END      
      
/***************************************************************************************      
End Loop through each sampleunit starting here      
****************************************************************************************/      
      
--Make sure we don't return any records twice if the record was eligible for more than 1 unit by using 'Distinct'      
SELECT DISTINCT *  FROM #BVUK      
    
--drop table #bvuk      
--drop table #criters      
--drop table #unitcriters    
--drop table #dqcriters    
--drop table #units


