/*
S18 US19 T1 Refactor PatInFile Counts.sql

21	Refactor PatInFile Counts	

As a CAHPS Developer, I need to reaname the HHCAHPS_PatInFile Count table to CHAPS_PatInFileCount so that it can handle both HH and Hospice CAHPS. 	

4) DCL_ExportCreateFile_Sub on Medusa (for HH-CAHPS)

*/

--EXEC sp_helptext 'dbo.DCL_ExportCreateFile_Sub'

USE [QP_Comments]
GO


ALTER PROCEDURE [dbo].[DCL_ExportCreateFile_Sub]                                       
    @ExportSetID    INT,                                       
    @Returnsonly    BIT,                                       
    @DirectsOnly    BIT,                                      
    @ExportFileGUID UNIQUEIDENTIFIER,                                      
    @CreateHeader   INT,                                
    @Method         varchar(100) OUTPUT,                  
    @InDebug        tinyint = 0                                  
AS  

/*************************************************************************************************                                    
  
Business Purpose:  
    This procedure is used to export study data set.  
  
Called By:  
    DCL_ExportCreateFile  
      
Created:  01/31/2006 by Brian Dohmen                                      
  
Modified: 09/26/2006 by Brian Mao                                       
    For CMS export, change the cutoff date field from datReportDate to datSampleEncounterDate                                    
Modified: 12/11/2007 by Steve Spicka  
    Changed logic populating the #sp table to work around a "Internal SQL Error"                            
Modified: 04/16/08 by Michael Beltz                                
    Added @Method as an Output Param.  Per CMS requirement this needs to be a part of the header info now.                                
Modified: 06/26/09 by Michael Beltz                          
    Added isnull(method,'NULLVALUE') code to trap for nulls.                          
    It is used in the calling proc (DCL_ExportCreateFile) to determine if a recordset is empty or has null values                          
Modified: 08/03/09 by Michael Beltz                        
    Added HDOSL logic to select distinct list of HDOSL fields into #HDOSL table (created in DCL_ExportCreateFile)                        
Modified: 02/10/10 by Michael Beltz                  
    Added @blnHHInFileExists and logic to return Patients in File                  
Modified: 04/08/10 by Michael Beltz                  
    Modified HHCHAPS PatInfile logic to check in new Qualisys table (HHCAHPS_PatInFileCounts).  If records in                
    in there (IE sample created before this code was released into prod) we will check the old way.                 
Modified: 07/07/2010 by Michael Beltz          
    Had to add PKCnt to #col table b/c 3 different fields had the same selcol value and it was deleting          
    records 2 and 3 before processing them in the loop (IE 3 records deleted when only should have deleted the first)                   
Modified: 10/11/2010 by Don Mayhew      
    Added a check for the existence of a study results table before trying to populate the #Cutoff table.  
Modified: 06/23/2011 by Jeffrey J. Fleming  
    Added LagTime column to the select statement.  
Modified: 12/11/2011 by Keith Charron  
    Added HNumAttempts column to the select statement. 
Modified: 6/19/2013 by Josh Willey and Richard Valdivieso. 
	Comment LangId=Null  if @StudyResultsExists = 1  
Modified: 9/26/2013 by Chris Burkholder
	Added numCAHPSSupplemental to the select statement.
**************************************************************************************************/                                    
  

--print @exportsetid
--print @Returnsonly
--print @DirectsOnly
--print @ExportFileGUID
--print @CreateHeader
--print @Method
--print @InDebug

  
SET NOCOUNT ON      
  
CREATE TABLE #sp(SamplePop_id INT)                                        
  
if @InDebug = 1 print 'Start DCL_ExportCreateFile_Sub'                        
                                        
DECLARE @Study_id INT, @sql1 VARCHAR(8000), @sql2 VARCHAR(8000), @sql3 VARCHAR(8000), @sql4 VARCHAR(8000), @sql5 VARCHAR(8000), @Methodsql VARCHAR(8000), @HDOSLsql Varchar(8000)     
DECLARE @intfield int, @field VARCHAR(100), @short VARCHAR(8), @Start DATETIME, @End DATETIME, @Owner VARCHAR(20), @Survey_id INT, @tableExtension varchar(20)                                      
DECLARE @Unique VARCHAR(40), @ResetCores VARCHAR(8000), @SampleUnit_id INT                                    
DECLARE @CutoffDateField sysname, @CutoffDateFieldAbbr varchar(8)                                    
declare @blnMethodExists bit, @blnHDOSLExists bit, @blnHHInFilePatServExists bit                  
declare @blnHHInFileExists bit, @ExportSetTypeID int                                   
declare @DispTable varchar(25), @dispColName varchar(25), @surveyType_ID int                  
declare @StudyResultsExists bit  
                  
select @ExportSetTypeID = ExportSetTypeID from exportset where ExportSetID = @ExportSetID                  
if @indebug = 1 print '@ExportSetTypeID=' + cast(@ExportSetTypeID as varchar(10))                  
  
-- For CMS export, use 'datSampleEncounterDate' as cutoff date;                                    
-- for other export, use 'datReportDate' as cutoff date                                    
IF (@CreateHeader = 1)   
BEGIN                                    
    SET @CutoffDateField = 'datSampleEncounterDate'                                    
    SET @CutoffDateFieldAbbr = 'SmpEncDt'                                    
END                                    
ELSE BEGIN                                    
    SET @CutoffDateField = 'datReportDate'                                    
    SET @CutoffDateFieldAbbr = 'ReportDt'                                    
END                                    
  
SELECT @Unique = RIGHT(CONVERT(VARCHAR(40), @ExportFileGUID), 12)                                      
  
--Populate some variables                                      
SELECT @Study_id = Study_id, @Survey_id = Survey_id, @Start = EncounterStartDate, @End = EncounterEndDate, @SampleUnit_id = SampleUnit_id                                      
FROM ExportSet WHERE ExportSetID=@ExportSetID  
  
-- decide to use study data table or view.                                    
-- CMS export always uses study data view.                                    
-- Other export uses study data table if start and end date are in the same quarter;                                    
-- otherwise uses study data view                                    
SELECT @tableExtension = 'view'                                      
IF (@CreateHeader = 0 AND dbo.YearQtr(@start) = dbo.YearQtr(@end))                                    
    SET @tableExtension=dbo.YearQtr(@start)                          
                                      
SELECT @Owner = 'S' + LTRIM(STR(@Study_id))                                        
                                        
SELECT @sql1 = ''                              
                                        
SELECT @sql1 = @sql1 + ' DROP TABLE ' + Table_Schema + '.' + Table_Name                                        
FROM Information_Schema.Tables                                        
WHERE Table_Name LIKE 'Export_' + LTRIM(STR(@ExportSetID)) + CONVERT(VARCHAR(40), @Unique)                                        
  
EXEC (@sql1)                                        
  
--See if study results table/view exists.  
if exists (select 1 from information_schema.tables where table_name = 'study_results_' + @tableextension and table_schema = @Owner)      
    set @StudyResultsExists = 1  
else  
    set @StudyResultsExists = 0  
   
if @InDebug = 1 print '@StudyResultsExists:' + cast(@StudyResultsExists as varchar)  
                                        
--Get a list of the SamplePops I need to work with.                                        
IF @ReturnsOnly = 0                                        
BEGIN                                        
    SET @sql1 = 'INSERT INTO #sp                              
                SELECT SamplePop_id                              
                 FROM s' + LTRIM(STR(@Study_id)) + '.Big_Table_' + @tableExtension + ' b, SampleUnit su                                  
                 WHERE b.' + @CutoffDateField + ' BETWEEN ''' + CONVERT(VARCHAR, @Start, 120) + ''' AND ''' + CONVERT(VARCHAR, DATEADD(S, -1, DATEADD(D, 1, @End)), 120) + '''                                  
                   AND b.SampleUnit_id = su.SampleUnit_id  
                   AND b.Survey_id = ' + LTRIM(STR(@Survey_id)) + ' AND su.ParentSampleunit_id IS NULL'           
      
    if @InDebug = 1 print @sql1               
      
    EXEC (@sql1)                                        
  
    if @InDebug = 1 select '#sp' as [#sp], * from #sp  
END                                        
                                        
--#CutOff is now populated from the study_results table/view                                      
--We will track the people in the export before we pass the results back to the app.                                      
CREATE TABLE #CutOff (SamplePop_id INT)                                      
                                    
SELECT SampleUnit_ID                                    
INTO dbo.#SampleUnit                  
FROM SampleUnit                                    
WHERE Survey_id = @Survey_id                                    

IF (@CreateHeader = 1)   
BEGIN                                    
    SELECT @sql1 = 'INSERT INTO #CutOff                                      
                    SELECT DISTINCT s.SamplePop_id                                    
                    FROM #SampleUnit su,                                    
                         s' + LTRIM(STR(@Study_id)) + '.Big_Table_' + @tableExtension + ' b,                                    
                         s' + LTRIM(STR(@Study_id)) + '.Study_Results_' + @tableExtension + ' s                                    
                    WHERE b.' + @CutoffDateField + ' BETWEEN ''' + CONVERT(VARCHAR, @Start, 120) + ''' AND ''' + CONVERT(VARCHAR, DATEADD(S, -1, DATEADD(D, 1, @End)), 120) + '''                                        
                      AND b.SampleUnit_id=su.SampleUnit_id  
                      AND s.SamplePop_ID = b.SamplePop_ID                              
                      AND s.SampleUnit_id = b.SampleUnit_id                                    
                      AND s.SampleUnit_id=su.SampleUnit_id'                                    
END  
ELSE   
BEGIN                                      
    -- Note: Because the nature that the data type of datReportDate are not consistent among the studies,                                    
    --       (some are datetime, some are smalldatetime), we have to convert the field into datetime before                                    
    --       querying the data                                    
    SELECT @sql1 = 'INSERT INTO #CutOff                                      
                    SELECT DISTINCT SamplePop_id                                    
                    FROM s' + LTRIM(STR(@Study_id)) + '.Study_Results_' + @tableExtension +' b, #SampleUnit su                                        
                    WHERE CONVERT(datetime, b.' + @CutoffDateField + ') BETWEEN ''' + CONVERT(VARCHAR, @Start, 120) + ''' AND ''' + CONVERT(VARCHAR, DATEADD(S, -1, DATEADD(D, 1, @End)), 120) + '''                                        
                      AND b.SampleUnit_id=su.SampleUnit_id'                                    
END  
  
--Only run if study results table/view exists.  
if (@StudyResultsExists = 1)      
begin  
    if @InDebug = 1 print @sql1  
    EXEC (@sql1)                                      
end  

if @InDebug = 1 select '#CutOff' as [#CutOff], * from #CutOff                                       
                                        
--Create a temp table to track the columns I need in the final table.                                        
CREATE TABLE #col (PKCnt int identity(1,1), col VARCHAR(42), selcol VARCHAR(100), short VARCHAR(10), Tbl TINYINT, intOrder INT)                                        
                                        
--Fields that are a part of the study, including computed fields only in the datamart (table 2)                                        
INSERT INTO #col                                        
SELECT DISTINCT strField_nm, CASE WHEN strFieldDataType='D' THEN 'CONVERT(VARCHAR(10),'+strField_nm+',101)' ELSE strField_nm END, ISNULL(strFieldShort_nm,LEFT(strField_nm,8)), 2 , NULL                            
FROM MetaStructure ms, MetaField mf                                        
WHERE ms.Study_id = @Study_id                                        
  AND ms.Field_id = mf.Field_id                                        
  AND bitPostedField_FLG = 1                                        

-- Add in system fields that MIGHT exist depending upon circumstances (We wll check for exisitence in Big_View Next......)                                     
INSERT INTO #col SELECT 'HDisposition', 'HDisposition', 'Dispostn', 1, NULL                                          
INSERT INTO #col SELECT 'HHDisposition', 'HHDisposition', 'HHDispo', 1, NULL                  
INSERT INTO #col SELECT 'MNCMDisposition', 'MNCMDisposition', 'MNCMDisp', 1, NULL                
INSERT INTO #col SELECT 'MethodologyType', 'MethodologyType', 'Method', 1, NULL                                          
INSERT INTO #col SELECT 'LagTime', 'LagTime', 'LagTime', 1, NULL                                          
INSERT INTO #col SELECT 'HNumAttempts', 'HNumAttempts', 'HNumAtts', 1, NULL                                          
INSERT INTO #col SELECT 'numCAHPSSupplemental','numCAHPSSupplemental','NumSuppl', 1, NULL

  
--Remove fields from #col that do not exist in Big_Table_View                                    
SELECT @SQL1 = 'DELETE t                                           
                FROM #col t LEFT OUTER JOIN (SELECT Column_Name FROM Information_Schema.Columns WHERE Table_Schema = ''' + @Owner + ''' AND Table_Name = ''Big_Table_' + @tableExtension + ''') a                                          
                                         ON t.Col = a.Column_Name  
                WHERE a.Column_Name IS NULL'  
EXEC (@sql1)  
  
--Add in the system fields we want (table 1)                                          
INSERT INTO #col SELECT NULL, 'CONVERT(VARCHAR(10), bv.datUndeliverable, 101)', 'Undel_dt', 1, NULL  
INSERT INTO #col SELECT NULL, 'bv.SamplePop_id', 'SampPop', 1, NULL  
INSERT INTO #col SELECT NULL, 'bv.SampleUnit_id', 'SampUnit', 1, NULL  
INSERT INTO #col SELECT NULL, 'CONVERT(VARCHAR(42),NULL)', 'Unit_nm', 1, NULL               
INSERT INTO #col SELECT NULL, 'CONVERT(VARCHAR(20),NULL)', 'Medicare', 1, NULL                                          
INSERT INTO #col SELECT NULL, 'CONVERT(BIT,NULL)', 'HCAHPS', 1, NULL                                          
INSERT INTO #col SELECT NULL, 'CONVERT(BIT,NULL)', 'HHCAHPS', 1, NULL              
INSERT INTO #col SELECT NULL, 'CONVERT(BIT,NULL)', 'MNCM', 1, NULL              
INSERT INTO #col SELECT NULL, 'bv.SampleSet_id', 'SampSet', 1, NULL                                          
INSERT INTO #col SELECT NULL, 'CONVERT(VARCHAR(10), bv.' + @CutoffDateField + ', 101)', @CutoffDateFieldAbbr, 1, NULL                                          
INSERT INTO #col SELECT NULL, 'bv.strUnitSelectType', 'SampType', 1, NULL                                          
INSERT INTO #col SELECT NULL, 'CONVERT(VARCHAR(10), bv.datSampleCreate_dt, 101)', 'Samp_dt', 1, NULL                                          
INSERT INTO #col SELECT NULL, 'bv.DaysFromFirstMailing', 'DyFrFrst', 1, NULL                                          
INSERT INTO #col SELECT NULL, 'bv.DaysFromCurrentMailing', 'DyFrCur', 1, NULL                                          

  
if @StudyResultsExists = 1  
begin  
    INSERT INTO #col SELECT NULL,'strLithoCode', 'LithoCd' , 1 , NULL                                          
    INSERT INTO #col SELECT NULL,'CONVERT(VARCHAR(10),datReturned,101)', 'Rtrn_dt', 1 , NULL                                          
end  
else  
    INSERT INTO #col SELECT NULL,'NULL', 'Rtrn_dt' , 1 , NULL                                          
                                      
SET @sql1 = 'INSERT INTO #col   
             SELECT NULL, ''CONVERT(INT, sr.bitComplete)'', ''Complete'', 1, NULL                                      
             FROM Information_Schema.Columns                                      
             WHERE Table_Schema = ''S'' + LTRIM(STR(' + convert(varchar, @Study_id) + '))                                      
               AND Table_Name = ''Study_Results_' + @tableExtension + '''                                      
               AND Column_Name = ''bitComplete'''                                      
EXEC(@sql1)  
  
SET @sql1 = 'IF NOT EXISTS(select 1 from #col where short = ''Complete'')
			 INSERT INTO #col
			 SELECT NULL, ''CONVERT(INT, 0)'', ''Complete'', 1, NULL'
EXEC(@sql1)  

--Get a list of the cores that pertain to this survey.                       
--Typically there are several surveys in a study that each use different sets                                        
-- of questions.                                          
SELECT DISTINCT QstnCore, Section_id * 100000 + subSection * 100 + Item intOrder  
INTO #cores  
FROM questions                                         
WHERE Survey_id = @Survey_id                                        
--Removed 2/3/5 BD per Phil's instructions                                      
--  AND bitIDEASSuppress = 0                                      
                                      
--INSERT the actual column names for the questions INTO the temp table(table 3)                                        
              INSERT INTO #col                                   
              SELECT NULL, sc.name, NULL, 3, intOrder                                        
              FROM dbo.sql2kcolumns sc, dbo.sql2kobjects so, dbo.sql2kusers su, #cores t                              
              WHERE su.name = 's' + LTRIM(STR( convert(varchar, @Study_id) ))                                        
                AND su.uid = so.uid  
                AND so.name = 'Study_Results_' + @tableExtension 
                AND so.id = sc.id  
                AND SUBSTRING(sc.name, 2, 6) = RIGHT('00000' + CONVERT(VARCHAR, QstnCore), 6) 
--EXEC (@sql1)  
                                      
--Now to build the table                                      
SELECT @sql1=''                                      
SELECT @sql2=''                                      
SELECT @sql3=''                                      
SELECT @ResetCores=''                                      
                        
if @indebug = 1 select '#col - Whole' as [#col Whole], * from #col                        
                                
--need to make sure Methodology field exists in DB before we run logic below (to return output param)                                
--so we check here before b/c dynamic sql deletes from this table as it creates select SQL                                      
set @blnMethodExists = 0                                
if exists (select 'x' from #col where short = 'Method')                                 
    set @blnMethodExists = 1                                
else                                
    set @blnMethodExists = 0                                
                                
--need to make sure HDOSL Field exists                               
--so we check here before b/c dynamic sql runs below                        
set @blnHDOSLExists = 0                                
if exists (select 'x' from #col where short = 'HDOSL')                                 
    set @blnHDOSLExists = 1                                
else                                
    set @blnHDOSLExists = 0                                
                  
--need to make sure PatInFile Field exists                               
--so we check here before b/c dynamic sql runs below                        
set @blnHHInFileExists = 0                                
if exists (select 'x' from #col where short = 'HHInFile')                                 
    set @blnHHInFileExists = 1                                
else                                
    set @blnHHInFileExists = 0                   
                  
--need to make sure HHServ Field exists                               
--so we check here before b/c dynamic sql runs below                   
set @blnHHInFilePatServExists = 0                                
if exists (select 'x' from #col where short = 'HHServ')            
    set @blnHHInFilePatServExists = 1                           
else                                
    set @blnHHInFilePatServExists = 0                   
                  
                  
                        
if @InDebug = 1 print '@blnMethodExists = ' + cast(@blnMethodExists as varchar(5))                                
if @InDebug = 1 print '@blnHDOSLExists = ' + cast(@blnHDOSLExists as varchar(5))                        
if @InDebug = 1 print '@blnHHInFileExists = ' + cast(@blnHHInFileExists as varchar(5))                   
          
if @indebug = 1 select '#col tbl=1' as [#col tbl=1], * from #col where tbl = 1          
                                
--We first deal with the system fields (table 1)                                        
SELECT TOP 1 @intfield = PKCnt, @field = selcol FROM #col WHERE tbl = 1                                        
                         
WHILE @@ROWCOUNT > 0                    
BEGIN  
    if @indebug = 1 print '@field = ' + @field                                   
    SELECT @short = short FROM #col WHERE PKCnt = @intfield                                        
          
    if @indebug = 1 print 'In #Col Tbl=1 @Short = ' + @short          
                                          
    IF @sql1 = ''                                        
    BEGIN                                        
        IF @short <> @field                                        
            SELECT @sql1 = @sql1 + @field + ' ' + @short                 
        ELSE                                        
            SELECT @sql1 = @sql1 + @field                                        
    END  
    ELSE                                        
    BEGIN                                        
        IF @short <> @field                                        
            SELECT @sql1 = @sql1 + ',' + @field + ' ' + @short                                        
        ELSE  
            SELECT @sql1 = @sql1 + ',' + @field                                        
    END  
                        
    DELETE #col WHERE PKCnt = @intfield                                     
            
    if @indebug = 1 print 'In #Col Tbl=1 after concat @sql1 = ' + @sql1          
                                          
    SELECT TOP 1 @intfield = PKCnt, @field = selcol FROM #col WHERE tbl = 1                                        
END                                        
  
--We next deal with the big_table fields (table 2)                                        
if @indebug = 1 select '#col tbl=2' as [#col tbl=2], * from #col where tbl=2          
          
SELECT TOP 1 @intfield = PKCnt, @field = selcol FROM #col WHERE tbl = 2                                        
                                        
WHILE @@ROWCOUNT > 0  
BEGIN  
    SELECT @short = short FROM #col WHERE PKCnt = @intfield                                      
  
    IF @sql2 = ''                                        
    BEGIN                                        
        IF @short <> @field                                        
            SELECT @sql2 = @sql2 + @field + ' ' + @short                                
        ELSE                                        
            SELECT @sql2 = @sql2 + @field                                        
    END                                        
    ELSE                                       
    BEGIN                                        
        IF @short <> @field                                        
            SELECT @sql2 = @sql2 + ',' + @field + ' ' + @short                                        
        ELSE                                     
            SELECT @sql2 = @sql2 + ',' + @field                                        
    END                                        
                                          
    DELETE #col WHERE PKCnt = @intfield                                      
     
    SELECT TOP 1 @intfield = PKCnt, @field = selcol FROM #col WHERE tbl = 2      
END                                        
                    
--We finally deal with the study_results fields (table 3)                   
if @indebug = 1 select '#col tbl=3' as [#col tbl=3], * from #col where tbl = 3  
  
SELECT TOP 1 @intfield = PKCnt, @field = selcol FROM #col WHERE tbl = 3 order by intOrder                                        
  
WHILE @@ROWCOUNT > 0                                 
BEGIN                                        
    SELECT @short = short FROM #col WHERE PKCnt = @intfield                                       
  
    IF @sql3 = ''                                        
    BEGIN                                          
        SELECT @sql3 = @sql3 + @field                                        
        SELECT @ResetCores = @ResetCores + @Field + ' = NULL'                                      
    END                                        
    ELSE                                        
    BEGIN                                        
        SELECT @sql3 = @sql3 + ',' + @field                                        
        SELECT @ResetCores = @ResetCores + ',' + @Field + ' = NULL'                                      
    END                            
                                          
    DELETE #col WHERE PKCnt=@intfield                                        
                                          
    SELECT TOP 1 @intfield=PKCnt, @field=selcol FROM #col WHERE tbl=3 order by intOrder                                        
END                   
  
--Exclude study results table/view if it doesn't exist.  
IF @StudyResultsExists = 1  
    IF @ReturnsOnly = 1                                        
    BEGIN                                        
        SELECT @sql4 = ' s' + LTRIM(STR(@Study_id)) + '.Export_' + LTRIM(STR(@ExportSetID)) + CONVERT(VARCHAR(40), @Unique) + '   
                         FROM s' + LTRIM(STR(@Study_id)) + '.Big_Table_' + @tableExtension + ' bv (NOLOCK)   
                              JOIN s' + LTRIM(STR(@Study_id)) + '.Study_Results_' + @tableExtension + ' sr (NOLOCK)   
                                ON bv.SamplePop_id = sr.SamplePop_id AND bv.SampleUnit_id = sr.SampleUnit_id,   
                              #CutOff t                                        
                         WHERE t.SamplePop_id = bv.SamplePop_id' + CASE WHEN @SampleUnit_id IS NULL THEN '' ELSE ' AND bv.SampleUnit_id = ' + LTRIM(STR(@SampleUnit_id)) END                                        
    END  
    ELSE                                        
    BEGIN                                        
        SELECT @sql4 = ' s' + LTRIM(STR(@Study_id)) + '.Export_' + LTRIM(STR(@ExportSetID)) + CONVERT(VARCHAR(40), @Unique) + '   
                         FROM s' + LTRIM(STR(@Study_id)) + '.Big_Table_' + @tableExtension + ' bv (NOLOCK)   
                              LEFT OUTER JOIN (SELECT s.* FROM s' + LTRIM(STR(@Study_id)) + '.Study_Results_' + @tableExtension + ' s (NOLOCK), #CutOff t   
                                               WHERE t.SamplePop_id = s.SamplePop_id) sr   
                                           ON bv.SamplePop_id = sr.SamplePop_id AND bv.SampleUnit_id = sr.SampleUnit_id,                                         
                              #sp t                                       
                         WHERE t.SamplePop_id=bv.SamplePop_id'+CASE WHEN @SampleUnit_id IS NULL THEN '' ELSE ' AND bv.SampleUnit_id='+LTRIM(STR(@SampleUnit_id)) END                                      
    END  
else  
    SELECT @sql4 = ' s' + LTRIM(STR(@Study_id)) + '.Export_' + LTRIM(STR(@ExportSetID)) + CONVERT(VARCHAR(40), @Unique) + '   
                     FROM s' + LTRIM(STR(@Study_id)) + '.Big_Table_' + @tableExtension + ' bv (NOLOCK) , #sp t  
                     WHERE t.SamplePop_id=bv.SamplePop_id'+CASE WHEN @SampleUnit_id IS NULL THEN '' ELSE ' AND bv.SampleUnit_id='+LTRIM(STR(@SampleUnit_id)) END  
  
  
IF EXISTS (SELECT * FROM dbo.sql2ktables
    WHERE id = OBJECT_ID(N'S' + LTRIM(STR(@Study_id)) + '.Export_' + LTRIM(STR(@ExportSetID)) + CONVERT(VARCHAR(40), @Unique))   
                             ) --AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
SELECT @sql5 = 'BEGIN   
                    DROP TABLE S' + LTRIM(STR(@Study_id)) + '.Export_' + LTRIM(STR(@ExportSetID)) + CONVERT(VARCHAR(40), @Unique) + '   
                END'
else set @SQL5=''  
if @InDebug = 1                         
begin                         
    print '@sql1:' + @sql1                                        
    print '@sql2:' + @sql2                                        
    print '@sql3:' + @sql3                                        
    print '@sql4:' + @sql4                        
    print '@sql5:' + @sql5                        
    print 'all together now'  
    IF @StudyResultsExists = 1                         
        PRINT @sql5+' SELECT '+@sql1+','+@sql2+','+@sql3+' INTO '+@sql4+' AND bv.strUnitSelectType=''D'''                                        
    else  
        PRINT @sql5+' SELECT '+@sql1+','+@sql2+' INTO '+@sql4+' AND bv.strUnitSelectType=''D'''                                        
end  
  
IF @StudyResultsExists = 1                                   
    IF @DirectsOnly = 1                           
        EXEC (@sql5 + ' SELECT ' + @sql1 + ',' + @sql2 + ',' + @sql3 + ' INTO ' + @sql4 + ' AND bv.strUnitSelectType = ''D''')                                       
    ELSE  
        EXEC (@sql5 + ' SELECT ' + @sql1 + ',' + @sql2 + ',' + @sql3 + ' INTO ' + @sql4)                                        
ELSE  
    IF @DirectsOnly = 1                           
        EXEC (@sql5 + ' SELECT ' + @sql1 + ',' + @sql2 + ' INTO ' + @sql4 + ' AND bv.strUnitSelectType = ''D''')                                       
    ELSE                                       
        EXEC (@sql5 + ' SELECT ' + @sql1 + ',' + @sql2 + ' INTO ' + @sql4)                                        
  
  
IF @@ROWCOUNT>0                                      
BEGIN                                      
    SELECT @sql1 = 'UPDATE e   
                    SET e.Unit_nm = strSampleUnit_nm,   
                        e.Medicare = su.MedicareNumber,               
                        e.HCAHPS = ISNULL(bitHCAHPS, 0),   
                        e.HHCAHPS = ISNULL(bitHHCAHPS, 0),   
                        e.MNCM = ISNULL(bitMNCM, 0)                                      
                    FROM S' + LTRIM(STR(@Study_id)) + '.Export_' + LTRIM(STR(@ExportSetID)) + CONVERT(VARCHAR(40), @Unique) + ' e, SampleUnit su                                        
                    WHERE su.SampleUnit_id=e.SampUnit'  
    EXEC (@sql1)  
  
    ------------Cleanup for HCAHPS--------------------------------------------------------                                    
    IF @CreateHeader = 1                                     
    BEGIN                   
        if @ExportSetTypeID = 1                  
            set @surveyType_ID = 1                  
          
        if @ExportSetTypeID = 2 or @ExportSetTypeID = 3                   
        begin                  
            set @surveyType_ID = 2                  
            set @DispTable = 'HCAHPSDispositions'                  
            set @dispColName = 'HCAHPSValue'                  
        end                  
          
        if @ExportSetTypeID = 4                  
        begin                  
            set @surveyType_ID = 3                  
            set @DispTable = 'HHCAHPSDispositions'                  
            set @dispColName = 'HHCAHPSValue'                  
        end                  
              
        if @ExportSetTypeID = 5                  
        begin                  
            set @surveyType_ID = 4                  
            set @DispTable = 'MNCMDispositions'                  
            set @dispColName = 'MNCMValue'                  
        end                   
                  
if @surveyType_ID = 2                  
        begin                                       
            -- Delete the non HCAHPS records                                     
            SELECT @sql1 = 'DELETE S' + LTRIM(STR(@Study_id)) + '.Export_' + LTRIM(STR(@ExportSetID)) + CONVERT(VARCHAR(40), @Unique) + '                                       
                            WHERE HCAHPS=0'                          
          
            if @InDebug = 1 print @sql1                                    
            EXEC (@sql1)                                     
        end                  
                           
        -- Delete records that are from a non-compliant sampleset                                    
        SELECT @sql1 = 'DELETE e                                    
                        FROM S' + LTRIM(STR(@Study_id)) + '.Export_' + LTRIM(STR(@ExportSetID)) + CONVERT(VARCHAR(40), @Unique) + ' e, sampleset ss                                    
                        WHERE e.sampset = ss.sampleset_id   
                          AND ss.surveytype_id <> ' + cast(@surveyType_ID as varchar(3))  
                                      
        if @InDebug = 1 print @sql1  
        EXEC (@sql1)                                        
                 
        INSERT INTO #DeletedHCAHPSRecords (deletedCount)                                     
        SELECT @@rowcount                          
                           
        --Reset the question results for returns more than 42 days from first or for ineligible dispositions                                      
        --Reset the return date to null for returns more than 42 days from first or for ineligible dispositions                                    
        --Reset the languageId to null for non-returns, returns more than 42 days from first, or for ineligible dispositions                                   
        --Remove the languageId to null per CMS spefications for non-returns, returns more than 42 days from first, or for ineligible dispositions                                   
        if @StudyResultsExists = 1  
        begin  
            SELECT @sql1 = 'UPDATE S                                       
                            SET ' + @ResetCores + ',                                    
                                rtrn_dt=null--,                                    
                                --langId=null                                    
                            FROM S' + LTRIM(STR(@Study_id)) + '.Export_' + LTRIM(STR(@ExportSetID)) + CONVERT(VARCHAR(40), @Unique) + ' s, disposition d, ' + @DispTable + ' hd   
                            WHERE s.Dispostn = hd.' + @dispColName + '   
                              and d.disposition_ID = hd.disposition_ID   
                              AND hd.ExportReportResponses = 0'                                      
  
            if @InDebug = 1 print @sql1                        
            EXEC (@sql1)                
        end  
        else  
        begin  
            SELECT @sql1 = 'UPDATE S                                       
                            SET rtrn_dt = null--,   
                                --langId = null                                    
                            FROM S' + LTRIM(STR(@Study_id)) + '.Export_' + LTRIM(STR(@ExportSetID)) + CONVERT(VARCHAR(40), @Unique) + ' s, disposition d, ' + @DispTable + ' hd   
                            WHERE s.Dispostn = hd.' + @dispColName + '   
                              and d.disposition_ID = hd.disposition_ID                                   
                              AND hd.ExportReportResponses = 0'                                      
        
            if @InDebug = 1 print @sql1                        
            EXEC (@sql1)                
        end                  
  
        if @surveyType_ID = 3                  
        begin                                       
            -- Delete the non HCAHPS records                                     
            SELECT @sql1 = 'DELETE S' + LTRIM(STR(@Study_id)) + '.Export_' + LTRIM(STR(@ExportSetID)) + CONVERT(VARCHAR(40), @Unique) + '    
                            WHERE HHCAHPS = 0'  
    
            if @InDebug = 1 print @sql1                                    
            EXEC (@sql1)                         
              
            --Reset the question results for returns more than 42 days from first or for ineligible dispositions                                  
            --Reset the return date to null for returns more than 42 days from first or for ineligible dispositions                                    
            --Reset the languageId to null for non-returns, returns more than 42 days from first, or for ineligible dispositions                                    
            if @StudyResultsExists = 1  
            begin  
                SELECT @sql1 = 'UPDATE S                                       
                                SET ' + @ResetCores + ',                                    
                                    rtrn_dt = null,                                    
                                    langId = null                                    
                                FROM S' + LTRIM(STR(@Study_id)) + '.Export_' + LTRIM(STR(@ExportSetID)) + CONVERT(VARCHAR(40), @Unique) + ' s, disposition d, ' + @DispTable + ' hd   
                                WHERE s.Dispostn = hd.' + @dispColName + '   
                                  and d.disposition_ID = hd.disposition_ID                                   
                                  AND hd.ExportReportResponses = 0'                                      
                  
                if @InDebug = 1 print @sql1                        
                EXEC (@sql1)                
            end  
            else         
            begin           
                SELECT @sql1 = 'UPDATE S                                       
                                SET rtrn_dt = null,   
                                    langId = null                                    
                                FROM S' + LTRIM(STR(@Study_id)) + '.Export_' + LTRIM(STR(@ExportSetID)) + CONVERT(VARCHAR(40), @Unique) + ' s, disposition d, ' + @DispTable + ' hd   
                                WHERE s.Dispostn = hd.' + @dispColName + '   
                                  and d.disposition_ID = hd.disposition_ID                                   
                                  AND hd.ExportReportResponses=0'                                      
            
                if @InDebug = 1 print @sql1                        
                EXEC (@sql1)                
            end  
        end                  
                
        if @surveyType_ID = 4                  
        begin                                       
            -- Delete the non HCAHPS records                                     
            SELECT @sql1 = 'DELETE S' + LTRIM(STR(@Study_id)) + '.Export_' + LTRIM(STR(@ExportSetID)) + CONVERT(VARCHAR(40), @Unique) + '   
                            WHERE MNCM = 0'                          
            
            if @InDebug = 1 print @sql1                                    
            EXEC (@sql1)                                     
        end                      
    END --@CreateHeader=1                                        \  
    ------------END Cleanup for HCAHPS/HHCAHPS/MNCM--------------------------------------------------------                                                
    ------------END: Clean up for MNCM ----------------------------------------------------------              
  
    if @InDebug = 1 print 'before insert into ExportTables'                                     
    INSERT INTO #ExportTables (Table_Schema, Table_Name)                                      
    SELECT CONVERT(VARCHAR(10), 'S' + LTRIM(STR(@Study_id))), CONVERT(VARCHAR(100), 'Export_' + LTRIM(STR(@ExportSetID)) + CONVERT(VARCHAR(40), @Unique))                                      
  
    --Here we only add to the running total.                  
    --after all exportsetst have been combined we will then total up and count                  
                
    if @surveyType_ID = 3                
    BEGIN                
        --Check for Patients in File Count.                
        --First loook in HHCAHPS_PatInfileCount (new way) then if no records are found                
        --look in Export_[GUID] table (old way)                
        set @HDOSLsql = 'insert into #PatInFileDistinctCounts   
                         Select distinct p.NumPatInFile   
                         from S' + LTRIM(STR(@Study_id)) + '.Export_' + LTRIM(STR(@ExportSetID)) + CONVERT(VARCHAR(40), @Unique) + ' e,   
                              QUALISYS.QP_PROD.dbo.HHCAHPS_PatInfileCount p                 
                         where e.sampset = p.Sampleset_ID   
                           and e.sampUnit = p.Sampleunit_ID'                                
          
        if @InDebug = 1  
        begin        
            print @HDOSLsql                        
            Select '#PatInFileDistinctCounts - Sub' [#PatInFileDistinctCounts], * from #PatInFileDistinctCounts        
        end        
    
        exec (@HDOSLsql)                                
                  
        if @@ROWCOUNT = 0 and @blnHHInFileExists = 1                
        BEGIN                
            set @HDOSLsql = 'insert into #PatInFileDistinctCounts   
                             Select distinct HHInFile   
                             from S' + LTRIM(STR(@Study_id)) + '.Export_' + LTRIM(STR(@ExportSetID)) + CONVERT(VARCHAR(40), @Unique)                
             
            if @InDebug = 1         
            begin        
                print 'HHCAHPS_PatInfileCount returned no results so instead trying...'                
                print @HDOSLsql                        
                Select '#PatInFileDistinctCounts - Sub' [#PatInFileDistinctCounts], * from #PatInFileDistinctCounts        
            end        
                   
            exec (@HDOSLsql)                                
        END                
  
        if @blnHHInFilePatServExists = 1                  
        BEGIN                  
            set @HDOSLsql = 'insert into #PatInFileServedCounts   
                             Select distinct HHServ   
                             from S' + LTRIM(STR(@Study_id)) + '.Export_' + LTRIM(STR(@ExportSetID)) + CONVERT(VARCHAR(40), @Unique)                                
              
            if @InDebug = 1 print @HDOSLsql  
            exec (@HDOSLsql)                                
        END  
    END                
                
    if @blnHDOSLExists = 1                        
    BEGIN                 
        set @HDOSLsql = 'insert into #HDOSL   
                         Select distinct HDOSL   
                         from S' + LTRIM(STR(@Study_id)) + '.Export_' + LTRIM(STR(@ExportSetID)) + CONVERT(VARCHAR(40), @Unique)                                
          
        if @InDebug = 1 print @HDOSLsql  
        exec (@HDOSLsql)                                
    END                        
    ELSE                        
    BEGIN                        
        insert into #HDOSL select -1                        
    END  
  
    if @blnMethodExists = 1                                 
    begin                                
        create table #DistinctMethod (Method varchar(100))                                
                                
        --added isnull call to trap null conditions                           
        set @Methodsql = 'insert into #DistinctMethod   
                          Select distinct isnull(method, ''NULLVALUE'')   
                          from S' + LTRIM(STR(@Study_id)) + '.Export_' + LTRIM(STR(@ExportSetID)) + CONVERT(VARCHAR(40), @Unique)                                
          
        if @InDebug = 1 print @Methodsql  
        exec (@Methodsql)                                
                                
        if (select count(*) from #DistinctMethod) = 1     
        begin                                
            select @Method = method from #DistinctMethod                                
              
            --If NULLValue we can assume the field is not populated and so we should flag it as empty so the TPS report will be created.                          
            if @Method = 'NULLVALUE' set @Method = 'EMPTY'                          
        end                                
  
        if (select count(*) from #DistinctMethod) > 1                                
        begin                                
            set @Method = 'MIXED'                                
        end                                
          
        if (select count(*) from #DistinctMethod) < 1                                
        begin                                
            set @Method = 'EMPTY'                                
        end                                
    end                                
    else                                
    begin                                
        set @Method = 'MISSING'                                
    end  
END --@surveyType_ID = 3



GO