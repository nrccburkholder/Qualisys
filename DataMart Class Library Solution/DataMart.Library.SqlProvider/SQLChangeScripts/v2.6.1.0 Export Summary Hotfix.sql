set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
/*************************************************************************************************
9-15-2006 DC Modified code that inserts into ExportFileMember to prevent duplicates that cause 
			 primary key errors.
**************************************************************************************************/

ALTER PROCEDURE [dbo].[DCL_ExportCreateFile]  
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
DECLARE @Column_Name VARCHAR(100), @Column_id INT, @CreateHeader BIT, @MedicareName VARCHAR(45)  
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
'SELECT '''+CONVERT(VARCHAR(40),@ExportFileGUID)+''',SampPop,Max(CASE WHEN Rtrn_dt IS NULL THEN 0 ELSE 1 END)  
FROM '+Table_Schema+'.'+Table_Name+CHAR(10) +
' GROUP BY SampPop' 
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



--------------------
GO
--------------------

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
/**********************************************************************************************************
	9-14-2006 DC Added code to convert datreportdate to datetime when evaluating dates.  This was done to correct a problem
				where datreportdate was smalldatetime and SQL would automatically convert the End datetime 
				value to a smalldate.  This would end up converting the end date to midnight of the following 
				day.
************************************************************************************************************/
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
 WHERE convert(datetime,datReportDate) BETWEEN '''+CONVERT(VARCHAR,@Start,120)+''' AND '''+CONVERT(VARCHAR,DATEADD(S,-1,DATEADD(D,1,@End)),120)+'''      
 AND b.SampleUnit_id=su.SampleUnit_id      
 AND su.Survey_id='+LTRIM(STR(@Survey_id))      
EXEC (@sql1)      
      
END      
      
--#CutOff is now populated from the study_results table/view    
--We will track the people in the export before we pass the results back to the app.    
CREATE TABLE #CutOff (SamplePop_id INT)    
    
SELECT @sql1='INSERT INTO #CutOff    
SELECT DISTINCT SamplePop_id FROM s'+LTRIM(STR(@Study_id))+'.Study_Results_' + @tableExtension +' b, SampleUnit su      
 WHERE convert(datetime,datReportDate) BETWEEN '''+CONVERT(VARCHAR,@Start,120)+''' AND '''+CONVERT(VARCHAR,DATEADD(S,-1,DATEADD(D,1,@End)),120)+'''      
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
--INSERT INTO #col SELECT NULL,'bv.HDisposition', 'Dispostn' , 1 , NULL      
--INSERT INTO #col SELECT NULL,'CONVERT(CHAR(2),NULL)', 'Dispostn' , 1 , NULL      
INSERT INTO #col SELECT NULL,'bv.SampleSet_id', 'SampSet', 1 , NULL      
INSERT INTO #col SELECT NULL,'CONVERT(VARCHAR(10),bv.datReportDate,101)', 'ReportDt', 1 , NULL      
INSERT INTO #col SELECT NULL,'bv.strUnitSelectType', 'SampType', 1 , NULL      
INSERT INTO #col SELECT NULL,'CONVERT(VARCHAR(10),bv.datSampleCreate_dt,101)', 'Samp_dt', 1 , NULL      
INSERT INTO #col SELECT NULL,'strLithoCode', 'LithoCd' , 1 , NULL      
INSERT INTO #col SELECT NULL,'bv.DaysFromFirstMailing', 'DyFrFrst' , 1 , NULL      
INSERT INTO #col SELECT NULL,'bv.DaysFromCurrentMailing', 'DyFrCur' , 1 , NULL      
--INSERT INTO #col SELECT NULL,'bv.MethodologyType', 'Method' , 1 , NULL      
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
  




