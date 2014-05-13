IF (ObjectProperty(Object_Id('dbo.DCL_ExportCreateFile_Sub'),
                   'IsProcedure') IS NOT NULL)
    DROP PROCEDURE dbo.DCL_ExportCreateFile_Sub
GO

/*  
Business Purpose:   
  
This procedure is used to export study data set. It is called by SP "DCL_ExportCreateFile".
  
Created:  01/31/2006 by Brian Dohmen  
Modified:    
09/26/2006 by Brian Mao - For CMS export, change the cutoff date field from datReportDate to datSampleEncounterDate
*/      

CREATE PROCEDURE [dbo].[DCL_ExportCreateFile_Sub]   
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
DECLARE @CutoffDateField sysname, @CutoffDateFieldAbbr varchar(8)

-- For CMS export, use 'datSampleEncounterDate' as cutoff date;
-- for other export, use 'datReportDate' as cutoff date
IF (@CreateHeader = 1) BEGIN
    SET @CutoffDateField = 'datSampleEncounterDate'
    SET @CutoffDateFieldAbbr = 'SmpEncDt'
END
ELSE BEGIN
    SET @CutoffDateField = 'datReportDate'
    SET @CutoffDateFieldAbbr = 'ReportDt'
END

SELECT @Unique=RIGHT(CONVERT(VARCHAR(40),@ExportFileGUID),12)  
  
--Populate some variables  
SELECT @Study_id=Study_id, @Survey_id=Survey_id, @Start=EncounterStartDate, @End=EncounterEndDate, @SampleUnit_id=SampleUnit_id  
FROM ExportSet WHERE ExportSetID=@ExportSetID  

-- decide to use study data table or view.
-- CMS export always uses study data view.
-- Other export uses study data table if start and end date are in the same quarter;
-- otherwise uses study data view
SELECT @tableExtension ='view'  
IF (@CreateHeader = 0 AND 
    dbo.YearQtr(@start)=dbo.YearQtr(@end))
    SET @tableExtension=dbo.YearQtr(@start)  
  
SELECT @Owner='S'+LTRIM(STR(@Study_id))    
    
SELECT @sql1=''    
    
SELECT @sql1=@sql1+' DROP TABLE '+Table_Schema+'.'+Table_Name    
FROM Information_Schema.Tables    
WHERE Table_Name LIKE 'Export_'+LTRIM(STR(@ExportSetID))+CONVERT(VARCHAR(40),@Unique)    
    
EXEC (@sql1)    
    
--Get a list of the SamplePops I need to work with.    
IF @ReturnsOnly=0    
BEGIN    
  
SET @sql1='
     INSERT INTO #sp
     SELECT DISTINCT SamplePop_id
       FROM s' + LTRIM(STR(@Study_id)) + '.Big_Table_' + @tableExtension + ' b,
            SampleUnit su    
      WHERE b.' + @CutoffDateField + ' BETWEEN '''+CONVERT(VARCHAR,@Start,120)+'''
                                           AND '''+CONVERT(VARCHAR,DATEADD(S,-1,DATEADD(D,1,@End)),120)+'''    
        AND b.SampleUnit_id = su.SampleUnit_id    
        AND su.Survey_id = ' + LTRIM(STR(@Survey_id))
        
EXEC (@sql1)    
    
END    
    
--#CutOff is now populated from the study_results table/view  
--We will track the people in the export before we pass the results back to the app.  
CREATE TABLE #CutOff (SamplePop_id INT)  

SELECT SampleUnit_ID
  INTO dbo.#SampleUnit
  FROM SampleUnit
 WHERE Survey_id= @Survey_id

IF (@CreateHeader = 1) BEGIN
 SELECT @sql1='
        INSERT INTO #CutOff  
        SELECT DISTINCT s.SamplePop_id
          FROM #SampleUnit su,
               s' + LTRIM(STR(@Study_id)) + '.Big_Table_' + @tableExtension +' b,
               s' + LTRIM(STR(@Study_id)) + '.Study_Results_' + @tableExtension +' s
         WHERE b.' + @CutoffDateField + ' BETWEEN '''+ CONVERT(VARCHAR,@Start,120)+'''
                                              AND '''+ CONVERT(VARCHAR,DATEADD(S,-1,DATEADD(D,1,@End)),120)+'''    
           AND b.SampleUnit_id=su.SampleUnit_id    
           AND s.SamplePop_ID = b.SamplePop_ID
           AND s.SampleUnit_id = b.SampleUnit_id
           AND s.SampleUnit_id=su.SampleUnit_id    
        '
END
ELSE BEGIN  
 -- Note: Because the nature that the data type of datReportDate are not consistent among the studies,
 --       (some are datetime, some are smalldatetime), we have to convert the field into datetime before
 --       querying the data
 SELECT @sql1='
        INSERT INTO #CutOff  
        SELECT DISTINCT SamplePop_id
          FROM s' + LTRIM(STR(@Study_id)) + '.Study_Results_' + @tableExtension +' b,
               #SampleUnit su    
         WHERE CONVERT(datetime, b.' + @CutoffDateField + ') BETWEEN '''+ CONVERT(VARCHAR,@Start,120)+'''
                                                                 AND '''+ CONVERT(VARCHAR,DATEADD(S,-1,DATEADD(D,1,@End)),120)+'''    
           AND b.SampleUnit_id=su.SampleUnit_id
        '
END
           
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
INSERT INTO #col SELECT NULL,'CONVERT(VARCHAR(10),bv.' + @CutoffDateField + ',101)', @CutoffDateFieldAbbr, 1 , NULL      
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
