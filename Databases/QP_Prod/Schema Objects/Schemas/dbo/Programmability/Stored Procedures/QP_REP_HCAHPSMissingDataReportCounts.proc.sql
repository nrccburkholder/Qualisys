/*  
Business Purpose:   
This procedure is used to calculate the number of missing values in  
HCAHPS standard fields.  
  
Created:  07/6/2006 by DC  
  
Modified   8/21/07 - SJS - Modification of HServiceType case statement to include "X"  
Modified   1/18/2008 - DJK - Included MSDRG in fields to be pulled
  
*/    
CREATE PROCEDURE [dbo].[QP_REP_HCAHPSMissingDataReportCounts] 
 @Associate varchar(50),  
 @Client varchar(50),  
 @Study varchar(50),  
 @Survey varchar(50),  
    @encounterStart DATETIME,   
    @encounterEnd DATETIME  
AS 
 
SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
    
DECLARE @Survey_id int, @Study_id INT, @shortName varchar(50),@FieldName varchar(50),  
  @Sel VARCHAR(8000),  
  @fields varchar(5000),   
  @TotalCount int  
  
select @study_id=s.study_id, @Survey_id=sd.survey_id   
from survey_def sd, study s, client c  
where c.strclient_nm=@Client  
  and s.strstudy_nm=@Study  
  and sd.strsurvey_nm=@survey  
  and c.client_id=s.client_id  
  and s.study_id=sd.study_id  
  
--get the list of Fields needed for evaluating DQ rules  
DECLARE @tbl TABLE (Fieldname VARCHAR(50), DataType VARCHAR(20), Length INT, Field_id INT, OrderName varchar(51))  
  
INSERT INTO @tbl   
SELECT DISTINCT strTable_nm+strField_nm, STRFIELDDATATYPE, INTFIELDLENGTH, Field_id,   
 case  
   when strfield_nm in ('DRG','MSDRG','hadmissionsource','hservicetype','hvisittype','hdischargestatus',  
         'hadmitage','hcatage','sex', 'DOB', 'AdmitDate') then ' ' + right('000000000' + convert(varchar,field_id),8)  
   else right('000000000' + convert(varchar,field_id),9)  
 end as OrderName  
FROM MetaData_View   
WHERE Study_id=@Study_id  
  
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
  
INSERT INTO #BVUK  
EXEC DBO.QP_REP_HCAHPSAllEligibleRecords @Survey_ID, @encounterStart, @encounterEnd  
  
  
--Get Missing Counts  
DECLARE @HCAHPStbl TABLE (Fieldname VARCHAR(50), shortName varchar(51))  
  
INSERT INTO @HCAHPStbl (shortName) VALUES('DRG')  
INSERT INTO @HCAHPStbl (shortName) VALUES('MSDRG')  
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
  
CREATE TABLE #Results (FieldName varchar(50), MissingCount varchar(25), Percentage decimal(6,2))  
  
SELECT @TotalCount=count(*)  
FROM #BVUK  
  
SELECT TOP 1 @shortName=ShortName, @FieldName=FieldName  
FROM @HCAHPStbl  
ORDER BY shortName  
  
WHILE @@rowcount>0  
BEGIN  
  
 SET @sel='CREATE TABLE #Temp (FieldName varchar(50), MissingCount int)  
    INSERT INTO #Temp  
    SELECT DISTINCT ''' + @shortName + ''','  
  
 IF @FieldName is null SET @sel=@sel + '-99'  
 ELSE IF @shortName in ('DOB','AdmitDate')  
  SET @sel=@sel + 'sum(case when '+ @FieldName +' is null or '+ @FieldName +'>getdate() or datediff(yy,'+ @FieldName +',getdate())>120 or year('+ @FieldName +')=0 then 1 else 0 end)'  
 ELSE IF @shortName in ('hdischargestatus','hcatage')  
  SET @sel=@sel + 'sum(case when '+ @FieldName +' is null or  '+ @FieldName +'=''M'' then 1 else 0 end)'  
 ELSE IF @shortName = 'hvisittype'  
  SET @sel=@sel + 'sum(case when '+ @FieldName +' is null then 1 else 0 end)'  
 ELSE IF @shortName ='hservicetype'  
  SET @sel=@sel + 'sum(case when '+ @FieldName +' is null or  '+ @FieldName +' IN (''9'',''X'') then 1 else 0 end)'  
 ELSE IF @shortName ='DRG'    SET @sel=@sel + 'sum(case when  '+ @FieldName +'  is null or  '+ @FieldName +' =''0'' or  '+ @FieldName +' =''000'' then 1 else 0 end)'  
ELSE IF @shortName ='MSDRG'    SET @sel=@sel + 'sum(case when  '+ @FieldName +'  is null or  '+ @FieldName +' =''0'' or  '+ @FieldName +' =''000'' then 1 else 0 end)'  
 ELSE IF @shortName ='sex'  
  SET @sel=@sel + 'sum(case when  '+ @FieldName +'  is null or  '+ @FieldName +' not in (''M'',''F'') then 1 else 0 end)'  
 ELSE IF @shortName ='hadmissionsource'  
  SET @sel=@sel + 'sum(case when  '+ @FieldName +'  is null or  '+ @FieldName +' =''9'' then 1 else 0 end)'  
 ELSE IF @shortName ='hadmitage'  
  SET @sel=@sel + 'sum(case when  '+ @FieldName +'  is null or  '+ @FieldName +' in (0,-1,9999) then 1 else 0 end)'  
  
 SET @sel=@sel +  '  
 FROM #BVUK  
  
 INSERT INTO #Results (FieldName, MissingCount, Percentage)  
 SELECT FieldName,  
   case MissingCount  
    when -99 then ''Field Does Not Exist''  
    else convert(varchar,MissingCount)  
   end,  
   case MissingCount  
    when -99 then null  
    else convert(decimal(6,2),MissingCount*100.0/'+convert(varchar,@totalCount) +')  
   end  
 FROM #Temp'  
  
 exec(@sel)  
  
 DELETE   
 FROM @HCAHPStbl  
 WHERE @shortName=ShortName  
  
 SELECT TOP 1 @shortName=ShortName, @FieldName=FieldName  
 FROM @HCAHPStbl  
 ORDER BY shortName  
END  
  
INSERT INTO #Results VALUES('','',null)  
  
INSERT INTO #Results VALUES('Total Record Count=' + convert(varchar,@totalcount),'',null)  
  
SELECT *  
FROM #Results  
  
DROP TABLE #BVUK  
DROP TABLE #Results


