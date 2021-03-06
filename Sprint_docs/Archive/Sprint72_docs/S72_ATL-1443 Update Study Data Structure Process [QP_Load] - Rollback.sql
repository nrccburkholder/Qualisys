/*
S72_ATL-1443 Update Study Data Structure Process [QP_Load] - Rollback.sql

Chris Burkholder

3/30/2017

ALTER PROCEDURE [dbo].[LD_StudyTables]

*/

USE [QP_Load]
GO

/****** Object:  StoredProcedure [dbo].[LD_UpdateDRG_ALL]    Script Date: 4/11/2017 5:16:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[LD_UpdateDRG_ALL] @Study_ID int, @DataFile_id int  
AS  
-- New wrapper that calls LD_UpdateDRG from Qualisys.QP_Prod. This runs  
-- from QP_LOAD  
SET NOCOUNT ON  
EXEC QUALISYS.QP_PROD.DBO.LD_UpdateDRG_ALL   @Study_ID , @DataFile_id   
GO

/****** Object:  StoredProcedure [dbo].[LD_UpdateDRG]    Script Date: 4/11/2017 4:45:43 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[LD_UpdateDRG] @Study_ID int, @DataFile_id int
AS
-- New wrapper that calls LD_UpdateDRG from Qualisys.QP_Prod. This runs
-- from QP_LOAD
SET NOCOUNT ON
EXEC QUALISYS.QP_PROD.DBO.LD_UpdateDRG   @Study_ID , @DataFile_id 

GO

/****** Object:  StoredProcedure [dbo].[LD_StudyTables]    Script Date: 3/30/2017 2:58:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
      

ALTER PROCEDURE [dbo].[LD_StudyTables]    
 @Study_id INT, @DropIdentIfTableCreate int = 1,  @indebug int = 0     
AS    

if @indebug = 1 print 'BEGIN QLOADER LD_StudyTables'
DECLARE @strLoadingDest VARCHAR(200), @sql VARCHAR(8000), @Table_Name VARCHAR(100), @IdentValue INT    
    
--Add the study as a login to SQL if it does not exist    
IF NOT EXISTS (SELECT * FROM Master.dbo.sysLogins WHERE name='S'+LTRIM(STR(@Study_id)))    
BEGIN     
 SELECT @sql='EXEC SP_AddLogin @loginame=''S'+LTRIM(STR(@Study_id))+''''    
 if @indebug = 1 print @sql
 EXEC (@sql)    
END    
    
--Add the study as a login if it does not exist in the database.    
IF (SELECT ISNULL(USER_ID('S'+LTRIM(STR(@Study_id))),-999))<0    
BEGIN    
 SELECT @sql='EXEC sp_grantdbaccess ''S'+LTRIM(STR(@Study_id))+''''    
 if @indebug = 1 print @sql
 EXEC (@sql)    
END    
    
SELECT @strLoadingDest=strParam_Value FROM Loading_Params WHERE strParam_nm='Loading Destination'      
    
--Get a list of all the fields in the study tables    
CREATE TABLE #MetaData (              
 Table_id        INT,              
 strTable_nm      VARCHAR(42),              
 Field_id        INT,              
 strField_nm      VARCHAR(42),              
 bitKeyField_flg   BIT,              
 DataType_id      INT,              
 intLength       INT,  
 bitPII    BIT,  
 bitAllowUS   BIT  
)              
             
SET @sql='INSERT INTO #MetaData              
EXEC '+@strLoadingDest+'SP_SYS_DestinationFields '+LTRIM(STR(@Study_id))+',1'    
if @indebug = 1 print @sql
EXEC (@sql)    

if @indebug = 1 select 'QLOADER - #MetaData' [#MetaData], * from #MetaData  
    
UPDATE #MetaData SET strTable_nm=strTable_nm+'_Load'    
    
DECLARE @LoadingColumns TABLE (Table_Name VARCHAR(100), Column_Name VARCHAR(100))    
    
INSERT INTO @LoadingColumns     
SELECT Table_Name, Column_Name    
FROM Information_Schema.Columns    
WHERE Table_Schema='S'+LTRIM(STR(@Study_id))    
AND Table_Name IN (SELECT DISTINCT strTable_nm FROM #MetaData)    

if @indebug = 1 select 'QLOADER - @LoadingColumns' [@LoadingColumns], * from @LoadingColumns
    
CREATE TABLE #Create (Table_Name VARCHAR(100))    
    
INSERT INTO #Create    
SELECT DISTINCT md.strTable_nm    
FROM (SELECT DISTINCT strTable_nm FROM #MetaData) md     
 LEFT OUTER JOIN     
  (SELECT DISTINCT Table_Name FROM @LoadingColumns) lc    
ON md.strTable_nm=lc.Table_Name    
WHERE lc.Table_Name IS NULL    

if @indebug = 1 select 'QLOADER - #Create' [#Create], * from #Create
    
IF (SELECT COUNT(*) FROM #Create)>0    
BEGIN    
    
 --Need to first collect the identity value for each table.    
 CREATE TABLE #IdentValues (Table_Name VARCHAR(100), IdentValue INT)    
     
 SET @sql='INSERT INTO #IdentValues    
 EXEC '+@strLoadingDest+'SP_SYS_GetIdentityValue '+LTRIM(STR(@Study_id))    
 if @indebug = 1 print @sql
 EXEC (@sql)    
     
 --If any of the tables we need to create don't have a seed value, then exit the procedure    
 IF EXISTS (SELECT * FROM #IdentValues t, #Create c WHERE t.Table_Name='S'+LTRIM(STR(@Study_id))+'.'+c.Table_Name AND IdentValue IS NULL)    
 BEGIN    
  SELECT -1    
  RETURN    
 END    
     
END    
    
--We need to create the tables in #Create.    
SELECT TOP 1 @Table_Name=Table_Name FROM #Create    
WHILE @@ROWCOUNT>0    
BEGIN    
     
     
 SELECT @IdentValue=IdentValue FROM #IdentValues WHERE Table_Name='S'+LTRIM(STR(@Study_id))+'.'+@Table_Name    
 
 if @indebug = 1
 begin
	print '@Table_Name = ' + @Table_Name
	print '@IdentValue = ' + cast(@IdentValue as varchar(20))
 end
  
-- Modification 10/8/04 SJS -- Add 1 to the ident_current value so the seed value for the table is 1 greater than the ident_current.  
 SELECT @sql='CREATE TABLE S'+LTRIM(STR(@Study_id))+'.'+@Table_Name+' (DataFile_id INT NOT NULL,DF_id INT NOT NULL,'+strField_nm+' INT NOT NULL IDENTITY('+LTRIM(STR(@IdentValue+1))+',1)'+    
  ' CONSTRAINT PK_S'+LTRIM(STR(@Study_id))+@Table_Name+' PRIMARY KEY CLUSTERED'    
  FROM #MetaData WHERE strTable_nm=@Table_Name AND bitKeyField_flg=1    
     
 SELECT @sql=@sql+','+strField_nm+' '+CASE DataType_id WHEN 3 THEN 'VARCHAR('+LTRIM(STR(intLength))+')' WHEN 2 THEN 'DATETIME' ELSE 'INT' END    
  FROM #MetaData WHERE strTable_nm=@Table_Name AND bitKeyField_flg=0    
     
 SELECT @sql=@sql+')'    
 if @indebug = 1 print @sql     
 EXEC (@sql)    
     
 --Now to add the Indexes    
 SELECT @sql='CREATE INDEX IDX_S'+LTRIM(STR(@Study_id))+@Table_Name+'DataFile ON S'+LTRIM(STR(@Study_id))+'.'+@Table_Name+' (DataFile_id, DF_id)'    
 if @indebug = 1 print @sql
 EXEC (@sql)    
     
    

 if @DropIdentIfTableCreate = 1
 begin           
	 --Now to remove the identity column from the Load tables on the production box.    
	 SELECT @sql='EXEC '+@strLoadingDest+'SP_SYS_RemoveIdentity '+LTRIM(STR(@Study_id))+', '''+@Table_Name+''', '''+strField_nm+''''    
	  FROM #MetaData WHERE strTable_nm=@Table_Name AND bitKeyField_flg=1    
	 EXEC (@sql)    	   
 END 
 
 DELETE #Create WHERE Table_Name=@Table_Name
 SELECT TOP 1 @Table_Name=Table_Name FROM #Create  
    
END    
--Now that we have created all missing tables, we need to look for missing columns    
    
DELETE @LoadingColumns     
    
--Rebuild the @LoadingColumns table so we can look for missing columns    
INSERT INTO @LoadingColumns     
SELECT Table_Name, Column_Name    
FROM Information_Schema.Columns    
WHERE Table_Schema='S'+LTRIM(STR(@Study_id))    
AND Table_Name IN (SELECT DISTINCT strTable_nm FROM #MetaData)    
    
--Get rid of the columns that exist in both places    
DELETE md    
FROM #MetaData md, @LoadingColumns lc    
WHERE md.strTable_nm=lc.Table_Name    
AND md.strField_nm=lc.Column_Name    
    
--Now to build and execute and alter table statement for each table that is missing columns    
SELECT TOP 1 @Table_Name=strTable_nm FROM #MetaData    
WHILE @@ROWCOUNT>0    
BEGIN    
    
 --Build the initial alter table statement    
 SELECT @sql='ALTER TABLE S'+LTRIM(STR(@Study_id))+'.'+@Table_Name+' ADD '    
     
 --Now to add the columns that need to be added    
 SELECT @sql=@sql+strField_nm+' '+CASE DataType_id WHEN 3 THEN 'VARCHAR('+LTRIM(STR(intLength))+')' WHEN 2 THEN 'DATETIME' ELSE 'INT' END+','    
   FROM #MetaData WHERE strTable_nm=@Table_Name    
     
 --Remove the final comma    
 SELECT @sql=SUBSTRING(@sql,1,(LEN(@sql)-1))    
 if @indebug = 1 print @sql    
 EXEC (@sql)    
     
 DELETE #MetaData WHERE strTable_nm=@Table_Name    
     
 SELECT TOP 1 @Table_Name=strTable_nm FROM #MetaData    

 if @indebug = 1 print 'END QLOADER LD_StudyTables'
    
END    
  
GO