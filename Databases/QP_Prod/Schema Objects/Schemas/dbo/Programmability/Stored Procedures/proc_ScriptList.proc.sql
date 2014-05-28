--DROP PROCEDURE PROC_ScriptList                           
CREATE PROCEDURE dbo.proc_ScriptList       
-- Ver. 2.0                    
-- Created/Modified 2/10/04 SS                    
--  Modified 2/11/04 SS  -- Added @upw for VSS user login                  
--  Modified 7/20/04 SS  -- Changed location of BAT files to W:\@logicalsrv\*.BAT      
--  Modified 2/15/25 SS  -- Added "-I-" switch to VSS command prompt to ignore all prompts from VSS    
      
@logicalsrv VARCHAR(130),                          
@bitTable     BIT = 0,                           
@bitView      BIT = 0,                           
@bitFunction  BIT = 0,                           
@bitProcedure BIT = 0,                           
@bitDatabase  BIT = 0,                          
@bitJob       BIT = 0,                          
                          
--These are captured in the table scripting                          
@bitIndex     BIT = 0,                           
@bitKey       BIT = 0,                           
@bitCheck     BIT = 0,                           
@bitTrigger   BIT = 0                          
                           
AS                          
                          
SET NOCOUNT ON                          
                    
/******************/                     
 DECLARE @maxseq INT, @seq INT, @uncpath VARCHAR(255), @spc char(1), @sql NVARCHAR(4000), @dbname VARCHAR(130), @objectname VARCHAR(200), @objecttype VARCHAR(10),                           
 @objectsubtype VARCHAR(50), @Tablename VARCHAR(200), @scriptfile VARCHAR(1000), @whereowner VARCHAR(250), @ost VARCHAR(50), @scriptpath VARCHAR(255),                     
 @projpath VARCHAR(255), @vsspath VARCHAR(255), @cmd NVARCHAR(4000), @bitAddedVSS BIT, @Error INT, @upw VARCHAR(50)                  
                           
--DECLARE @bitTable BIT, @bitView BIT, @bitFunction BIT, @bitTrigger BIT, @bitProcedure BIT, @bitIndex BIT, @bitKey BIT, @bitCheck BIT, @bitJob BIT, @bitDatabase BIT                          
 --   SET @bitTable = 1                          
           
 SET @uncpath = '\\Neptune\Teams\Information Services\DBA\Scripts'                          
 SET @spc = '.'                          
 SET @sql = ''                    
 SET @projpath = '$/MSSQL/'                    
 SET @vsspath = '\\Neptune\teams\inform~1\develo~1\VSS'                    
 SET @upw = @logicalsrv + ',v$$$ql'                  
/******************/                     
                    
-- Create table to hold data that will be fed to proc_genscrip one record at a time.                          
                          
IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE NAME = 'SCRIPTLIST')                          
 BEGIN                          
 CREATE TABLE Scriptlist (SEQ INT IDENTITY(1,1), ObjectType VARCHAR(10), ObjectSubType VARCHAR(50), ServerName VARCHAR(130), DBName VARCHAR(130),                           
    OwnerName VARCHAR(50), ObjectName VARCHAR(200), TableName VARCHAR(200), ScriptFile VARCHAR(1000),                           
    id INT, uid SMALLINT, name varchar(128), xtype char(2), schema_ver INT, tiScript TINYINT, bitAddedVSS BIT DEFAULT 0, script_dt DATETIME)                          
 CREATE CLUSTERED INDEX CIX_scriptlist ON scriptlist (seq)                          
 END                          
                          
 CREATE TABLE #Scriptlist (ObjectType VARCHAR(10), ObjectSubType VARCHAR(50), ServerName VARCHAR(130), DBName VARCHAR(130),                           
    OwnerName VARCHAR(50), ObjectName VARCHAR(200), TableName VARCHAR(200), ScriptFile VARCHAR(1000),                           
    id INT, uid SMALLINT, name varchar(128), xtype char(2), schema_ver INT)                          
                          
 SET @maxseq = (SELECT MAX(seq) FROM script_dblist WHERE scriptbit = 1)                          
 SET @seq  = (SELECT MIN(seq) FROM script_dblist WHERE scriptbit = 1)                          
 SET @whereowner = ' AND  su.name IN (' + '''' + 'DBO' + '''' + ')'                                                    
                          
-- LOOP through all databases                          
WHILE @seq  <= @maxseq                          
BEGIN                         
 SET @dbname = (SELECT Database_Name FROM script_dblist WHERE seq = @seq AND scriptbit = 1)                          
                          
 IF @bitTable = 0 AND @bitView = 0 AND @bitFunction = 0 AND @bitProcedure = 0 AND @bitDatabase = 0 AND @bitJob = 0 AND @bitIndex = 0 AND @bitKey = 0 AND @bitCheck = 0 AND @bitTrigger = 0                          
  BEGIN                          
  SELECT @bitTable = bitTable, @bitView = bitView, @bitFunction = bitFunction, @bitProcedure = bitProcedure, @bitDatabase = bitDatabase, @bitJob = bitJob, @bitTrigger = bitTrigger,              @bitIndex = bitIndex, @bitKey = bitKey, @bitCheck = bitCheck 
  
    
     
,        
          
            
              
 @bitTrigger = bitTrigger   FROM script_dblist WHERE seq = @seq                   
  END                          
                          
 SET @seq  = @seq  + 1                          
                          
  IF @bitTable = 1                         
 BEGIN                        
 -- Gather info on TABLES                        
 SET @sql =                         
 ' INSERT INTO #ScriptList (ObjectType, ServerName, DBName, OwnerName, ObjectName, TableName, ScriptFile, id, uid, name, xtype, schema_ver ) ' + CHAR(10) +                         
  ' SELECT ' + '''' + 'TABLE' + '''' + ' AS ObjectType, ' + CHAR(10) +                         
    '''' + @@servername + '''' + ' AS ServerName, ' + CHAR(10) +                         
    '''' + @dbname + '''' + ' AS DBName, ' + CHAR(10) +                         
    ' su.name AS OwnerName, ' + CHAR(10) +                         
    ' ''['' + su.name + ''].['' + so.name + '']'' AS ObjectName, ' + CHAR(10) +                         
    '''' + ' ' + '''' + ' AS TableName, ' + CHAR(10) +                         
    '''' + ' ' + '''' +  ' AS ScriptFile, ' + CHAR(10) +                        
    ' so.id, so.uid, so.name, so.xtype, so.schema_ver ' + CHAR(10) +                        
  ' FROM ' + @dbname + '.dbo.sysobjects so, ' + @dbname + '.dbo.sysusers su WHERE so.uid = su.uid AND type = ' + '''' + 'U' + '''' + ' AND ISNULL(objectproperty(so.id,' + '''IsMSShipped''' + '),0) = 0 AND so.status >= 0 ' + @whereowner                    
  
    
     
 EXEC (@sql)                        
 SET @sql = ''                  
 END                        
                        
 IF @bitView = 1                        
 BEGIN                        
 -- Gather info on VIEWS                        
 SET @sql =                         
 ' INSERT INTO #ScriptList (ObjectType, ServerName, DBName, OwnerName, ObjectName, TableName, ScriptFile, id, uid, name, xtype, schema_ver ) ' + CHAR(10) +                         
  ' SELECT ' + '''' + 'VIEW' + '''' + ' AS ObjectType, ' + CHAR(10) +                        
    '''' + @@servername + '''' + ' AS ServerName, ' + CHAR(10) +                         
    '''' + @dbname + '''' + ' AS DBName, ' + CHAR(10) +                         
    ' su.name AS OwnerName, ' + CHAR(10) +                        
    ' ''['' + su.name + ''].['' + so.name + '']'' AS ObjectName, ' + CHAR(10) +                         
    '''' + ' ' + '''' + ' AS TableName, ' + CHAR(10) +                        
    '''' + ' ' + '''' +  ' AS ScriptFile, ' + CHAR(10) +                        
    ' so.id, so.uid, so.name, so.xtype, so.schema_ver ' + CHAR(10) +                        
  ' FROM ' + @dbname + '.dbo.sysobjects so, ' + @dbname + '.dbo.sysusers su  WHERE so.uid = su.uid AND type = ' + '''' + 'V' + '''' + ' AND ISNULL(objectproperty(so.id,' + '''IsMSShipped''' + '),0) = 0 AND so.status >= 0 ' + @whereowner                   
  
    
      
 EXEC (@sql)                        
 SET @sql = ''                  
 END                        
                        
                        
 IF @bitFunction = 1                        
 BEGIN          
 -- Gather info on FUNCTIONS                        
 SET @sql =                         
 ' INSERT INTO #ScriptList (ObjectType, ServerName, DBName, OwnerName, ObjectName, TableName, ScriptFile, id, uid, name, xtype, schema_ver ) ' + CHAR(10) +                         
  ' SELECT ' + '''' + 'FUNCTION' + '''' + ' AS ObjectType, ' + CHAR(10) +                        
    '''' + @@servername + '''' + ' AS ServerName, ' + CHAR(10) +                         
    '''' + @dbname + '''' + ' AS DBName, ' + CHAR(10) +          
    ' su.name AS OwnerName, ' + CHAR(10) +                        
    ' ''['' + su.name + ''].['' + so.name + '']'' AS ObjectName, ' + CHAR(10) +                         
    '''' + ' ' + '''' + ' AS TableName, ' + CHAR(10) +                        
    '''' + ' ' + '''' +  ' AS ScriptFile, ' + CHAR(10) +                        
    ' so.id, so.uid, so.name, so.xtype, so.schema_ver ' + CHAR(10) +                        
  ' FROM ' + @dbname + '.dbo.sysobjects so, ' + @dbname + '.dbo.sysusers su  WHERE so.uid = su.uid AND type IN (' +  '''' + 'TF' + '''' + ',' + '''' + 'IF' + '''' + ',' + '''' + 'FN' + '''' + ') AND ISNULL(objectproperty(so.id,' + '''IsMSShipped''' + '),
   
    
     
0        
          
            
) = 0 AND so.status >= 0 ' + @whereowner                         
 EXEC (@sql)                        
 SET @sql = ''                  
 END                        
                        
              
 IF @bitProcedure = 1                        
 BEGIN                        
 -- Gather info on PROCEDURES                        
 SET @sql =                         
 ' INSERT INTO #ScriptList (ObjectType, ServerName, DBName, OwnerName, ObjectName, TableName, ScriptFile, id, uid, name, xtype, schema_ver ) ' + CHAR(10) +                         
  ' SELECT ' + '''' + 'PROCEDURE' + '''' + ' AS ObjectType, ' + CHAR(10) +                         
    '''' + @@servername + '''' + ' AS ServerName, ' + CHAR(10) +                         
    '''' + @dbname + '''' + ' AS DBName,' + CHAR(10) +                         
    ' su.name AS OwnerName,' + CHAR(10) +                         
    ' ''['' + su.name + ''].['' + so.name + '']'' AS ObjectName, ' + CHAR(10) +                         
    '''' + ' ' + '''' + ' AS TableName,' + CHAR(10) +                         
    '''' + ' ' + '''' +  ' AS ScriptFile, ' + CHAR(10) +                        
    ' so.id, so.uid, so.name, so.xtype, so.schema_ver ' + CHAR(10) +                        
  ' FROM ' + @dbname + '.dbo.sysobjects so, ' + @dbname + '.dbo.sysusers su  WHERE so.uid = su.uid AND type IN (' + '''' + 'P' + '''' + ',' + '''' + 'X' + '''' + ') AND ISNULL(objectproperty(so.id,' + '''IsMSShipped''' + '),0) = 0 AND so.status >= 0 '    
  
    
      
        
          
            
                     
 EXEC (@sql)                        
 SET @sql = ''                  
 END                        
                        
 IF @bitTrigger = 1                        
 BEGIN                        
 -- Gather info on TRIGGERS                        
 SET @sql =                         
 ' INSERT INTO #ScriptList (ObjectType, ServerName, DBName, OwnerName, ObjectName, TableName, ScriptFile, id, uid, name, xtype, schema_ver ) ' + CHAR(10) +                         
  ' SELECT ' + '''' + 'TRIGGER' + '''' + ' AS ObjectType, ' + CHAR(10) +                        
    '''' + @@servername + '''' + ' AS ServerName, ' + CHAR(10) +                         
    '''' + @dbname + '''' + ' AS DBName, ' + CHAR(10) +                         
    ' su.name AS OwnerName, ' + CHAR(10) +                         
    ' ''['' + su.name + ''].['' + so.name + '']'' AS ObjectName, ' + CHAR(10) +                          
    ' so2.name AS TableName, ' + CHAR(10) +         '''' + ' ' + '''' +  ' AS ScriptFile, ' + CHAR(10) +                        
    ' so.id, so.uid, so.name, so.xtype, so.schema_ver ' + CHAR(10) +                        
  ' FROM ' + @dbname + '.dbo.sysobjects so, ' + @dbname + '.dbo.sysobjects so2, ' + @dbname + '.dbo.sysusers su  WHERE so.parent_obj=so2.id AND so.uid = su.uid AND so.type = ' + '''' + 'TR' + '''' + ' AND ISNULL(objectproperty(so.id,' + '''IsMSShipped''' 
  
    
      
        
          
            
+ '),0) = 0' + ' AND objectproperty(so2.id,' + '''IsMSShipped''' + ') = 0 AND so.status >= 0 '                        
 EXEC (@sql)                        
 SET @sql = ''              
 END                        
                         
 IF @bitIndex = 1                        
 BEGIN                        
 -- Gather info on INDEXES                        
 SET @sql =                         
 ' INSERT INTO #ScriptList (ObjectType, ServerName, DBName, OwnerName, ObjectName, TableName, ScriptFile, id, uid, name, xtype, schema_ver ) ' + CHAR(10) +                         
  ' SELECT ' + '''' + 'INDEX' + '''' + ' AS ObjectType, ' + CHAR(10) +                        
    '''' + @@servername + '''' + ' AS ServerName, ' + CHAR(10) +                         
    '''' + @dbname + '''' + ' AS DBName, ' + CHAR(10) +                         
    ' su.name AS OwnerName, ' + CHAR(10) +                        
    ' ''['' + su.name + ''].['' + so.name + '']'' AS ObjectName, ' + CHAR(10) +                         
    ' so.name AS TableName, ' + CHAR(10) +                        
    '''' + ' ' + '''' +  ' AS ScriptFile, ' + CHAR(10) +           
    ' so.id, so.uid, so.name, so.xtype, so.schema_ver ' + CHAR(10) +                        
  ' FROM ' + @dbname + '.dbo.sysobjects so, ' + @dbname + '.dbo.sysindexes si, ' + @dbname + '.dbo.sysusers su  WHERE so.id=si.id AND so.uid=su.uid AND so.type = ' + '''' + 'U' + '''' +  CHAR(10) +                         
  ' AND ISNULL(objectproperty(so.id,' + '''IsMSShipped''' + '),0) = 0  AND so.status >= 0  AND si.indid > 0  AND si.indid <> 255 AND  si.name NOT LIKE ' + '''' + '_WA_Sys_%' + '''' + @whereowner                         
                        
 EXEC (@sql)                        
 SET @sql = ''                  
 END                        
                        
 IF @bitKey = 1                        
 BEGIN                        
 -- Gather info on KEYS                        
 SET @sql =                        
 ' INSERT INTO #ScriptList (ObjectType, ServerName, DBName, OwnerName, ObjectName, TableName, ScriptFile, id, uid, name, xtype, schema_ver ) ' + CHAR(10) +                         
  ' SELECT ' + '''' + 'KEY' + '''' + ' AS ObjectType, ' + CHAR(10) +                         
    '''' + @@servername + '''' + ' AS ServerName, ' + CHAR(10) +                         
    '''' + @dbname + '''' + ' AS DBName, ' + CHAR(10) +                         
    ' su.name AS OwnerName, ' + CHAR(10) +                         
    ' ''['' + su.name + ''].['' + so.name + '']'' AS ObjectName, ' + CHAR(10) +                         
    ' so2.name AS TableName, ' + CHAR(10) +                         
    '''' + ' ' + '''' +  ' AS ScriptFile, ' + CHAR(10) +                        
    ' so.id, so.uid, so.name, so.xtype, so.schema_ver ' + CHAR(10) +                        
  ' FROM ' + @dbname + '.dbo.sysobjects so, ' + @dbname + '.dbo.sysobjects so2, ' +  @dbname + '.dbo.sysusers su  WHERE so.parent_obj=so2.id AND so.uid = su.uid ' + CHAR(10) +                         
  --   ' AND so.type IN (' + '''' + 'K' + '''' + ',' + '''' + 'F' + '''' + ') AND so.status > 0' + ' AND so2.status > 0' + @whereowner                         
  ' AND so.type IN (' + '''' + 'F' + '''' + ') AND ISNULL(objectproperty(so.id,' + '''IsMSShipped''' + '),0) = 0' + ' AND ISNULL(objectproperty(so2.id,' + '''IsMSShipped''' + '),0) = 0 AND so.status >= 0 ' + @whereowner                         
 EXEC (@sql)                        
 SET @sql = ''                  
 END                        
                        
 IF @bitCheck = 1                        
 BEGIN                        
 -- Gather info on CHECKS                        
 SET @sql =                        
 ' INSERT INTO #ScriptList (ObjectType, ServerName, DBName, OwnerName, ObjectName, TableName, ScriptFile, id, uid, name, xtype, schema_ver ) ' + CHAR(10) +                         
  ' SELECT ' + '''' + 'CHECK' + '''' + ' AS ObjectType, ' + CHAR(10) +                         
    '''' + @@servername + '''' + ' AS ServerName, ' + CHAR(10) +                         
    '''' + @dbname + '''' + ' AS DBName, ' + CHAR(10) +                         
    ' su.name AS OwnerName, ' + CHAR(10) +                         
    ' ''['' + su.name + ''].['' + so.name + '']'' AS ObjectName, ' + CHAR(10) +                         
    ' so2.name AS TableName, ' + CHAR(10) +                         
    '''' + ' ' + '''' +  ' AS ScriptFile, ' + CHAR(10) +                        
    ' so.id, so.uid, so.name, so.xtype, so.schema_ver ' + CHAR(10) +                        
  ' FROM ' + @dbname + '.dbo.sysobjects so, ' + @dbname + '.dbo.sysobjects so2, ' +  @dbname + '.dbo.sysusers su ' + CHAR(10) +                         
  ' WHERE so.parent_obj=so2.id AND so.uid = su.uid AND so.type IN (' + '''' + 'C' + '''' + ') AND ISNULL(objectproperty(so.id,' + '''IsMSShipped''' + '),0) = 0' + ' AND ISNULL(objectproperty(so2.id,' + '''IsMSShipped''' + '),0) = 0 AND so.status >= 0 ' + 
 
     
     
        
           
            
@whereowner                         
 EXEC (@sql)                        
 SET @sql = ''                  
 END                        
END                        
                        
 IF @bitJob = 1                        
 BEGIN                        
 -- Gather info on JOBS                        
 INSERT INTO #ScriptList (ObjectType, ServerName, DBName, OwnerName, ObjectName, TableName, ScriptFile)                         
  SELECT  'JOB' AS ObjectType,                         
    sj.originating_server AS ServerName,                         
    ' ' AS DBName,                         
    ' ' AS OwnerName,                        
    sj.name AS ObjectName,                         
    ' ' AS TableName,                         
    ' ' AS ScriptFile                        
  FROM msdb.dbo.sysjobs sj                         
 END                        
                        
 IF @bitDatabase = 1                        
 BEGIN                        
 -- Gather info on DATABASES                        
 INSERT INTO #ScriptList (ObjectType, ServerName, DBName, OwnerName, ObjectName, TableName, ScriptFile)                         
  SELECT  'DATABASE' AS ObjectType,                         
    @@servername  AS ServerName,                        
    ' ' AS DBName,                         
    ' ' AS OwnerName,                        
    database_name AS ObjectName,                         
    ' ' AS TableName,                        
    ' ' AS ScriptFile                        
  FROM script_dblist WHERE  scriptbit = 1                        
 END                        
                  
/*----------------------------------------*/                  
                  
-- UPDATE THE OBJECTSUBTYPE (Used to determine proper pathing for procedures)                  
DECLARE cur_ost CURSOR FOR SELECT objectsubtype FROM Script_ostlist                  
SET @OST = (SELECT TOP 1 objectsubtype FROM Script_ostlist)                  
                  
OPEN cur_ost                  
FETCH NEXT FROM cur_ost INTO @ost                  
                  
WHILE @@FETCH_STATUS = 0                  
 BEGIN                  
                   
 SET @sql = ''                  
 SET @sql =                   
 'UPDATE t1 SET objectsubtype = t2.scriptfolder ' + char(10) +                   
 'FROM #scriptlist t1 INNER JOIN Script_ostlist t2 ' + char(10) +                  
 'ON t1.objecttype COLLATE Latin1_General_CI_AI = t2.objecttype COLLATE Latin1_General_CI_AI'  + char(10) +                   
 'WHERE t2.objectsubtype = ''' + @ost + ''' AND T1.objectname LIKE ''%' + @ost + '%'' AND t1.dbname = t2.database_name'               
-- 'WHERE t2.objectsubtype = ''' + @ost + ''' AND T1.objectname LIKE ''%' + @ost + '%'' ESCAPE ' + '''/'''     -- SS 5/13/04              
                   
-- PRINT @SQL                  
 EXEC sp_executesql @sql                  
                   
 FETCH NEXT FROM cur_ost INTO @ost                  
 END                  
                  
CLOSE cur_ost                  
DEALLOCATE cur_ost                  
                  
--Update objectsubtype in temp table for currently defined objectsubtypes in permanent table (scriptlist) based upon object_id.                  
-- This will ensure that an established or manually redifined objectsubtype will not be overwritten by the next update                  
UPDATE T1 SET T1.objectsubtype = T2.objectsubtype FROM #scriptlist T1, scriptlist T2 WHERE t1.dbname = t2.dbname AND t1.id = t2.id                  
UPDATE T1 SET T1.objectsubtype = T2.objectsubtype FROM #scriptlist T1, scriptlist T2 WHERE t1.objecttype IN ('DATABASE','JOB') AND t1.objectname  = t2.objectname                         
                  
--Update objectsubtype for any "new" OBJECTS where the objectsubtype is currently null AFTER the above update.                  
UPDATE #scriptlist SET objectsubtype = CASE WHEN ObjectType = 'PROCEDURE' THEN 'UNDEF' ELSE '' END WHERE objectsubtype IS NULL --ISNULL(objectsubtype,'') = ''                  
/*----------------------------------------*/                  
                          
-- UPDATE path for database object scripts                          
UPDATE #ScriptList SET ScriptFile =                          
 CASE                           
   -- UPDATE path for sql database scripts                          
  WHEN objecttype = 'DATABASE' THEN @uncpath + '\' +@logicalsrv + '\DATABASE\' + objectname + '\' + objectname + '.sql'                          
   -- UPDATE path for sql JOB scripts                
  WHEN objecttype = 'JOB' THEN @uncpath + '\' +@logicalsrv + '\JOB\' + objectname + '.sql'                          
   -- UPDATE path for sql TABLE CHARACTERISTICTS scripts                          
  WHEN objecttype IN ('INDEX','KEY','TRIGGER','CHECK') THEN  @uncpath + '\' +@logicalsrv + '\DATABASE\' + DBNAME + '\' + OBJECTTYPE  + '\' + tablename + @spc + objectname + '.sql'                           
   -- UPDATE path for sql TABLE/VIEW/PROC scripts                          
  ELSE                     
 CASE WHEN Objectsubtype = '' THEN @uncpath + '\' +@logicalsrv + '\DATABASE\' + DBNAME + '\' + OBJECTTYPE  + '\' + REPLACE(ObjectName,'.',@SPC) + '.sql'  -- Place in UNDEF (no subtype defined)                    
 ELSE  @uncpath + '\' +@logicalsrv + '\DATABASE\' + DBNAME + '\' + OBJECTTYPE  + '\' + OBJECTSUBTYPE  + '\' + REPLACE(ObjectName,'.',@SPC) + '.sql'       -- Place is objectsubtype folder                    
 END                    
 END                          
                
/**************************/                      
-- !!!!                      
                      
                
-- DELETE SPECIFIC OBJECTS                 
-- DELETE FROM #scriptlist WHERE objectname like '%'                
                
                      
-- !!!!                      
/**************************/                      
                          
-- Update records that have changed since last scripting                          
UPDATE sl SET sl.tiScript = 0, sl.schema_ver = tsl.schema_ver FROM ScriptList sl, #scriptlist tsl WHERE sl.dbname = tsl.dbname AND sl.id = tsl.id and sl.schema_ver <> tsl.schema_ver                          
              
-- Update any logical objects that have a new physical object_id but the same physical name (example: procedure was dropped and recreated rather than altered)              
UPDATE sl SET sl.tiScript = 0, sl.id = tsl.id, sl.schema_ver = tsl.schema_ver FROM ScriptList sl, #scriptlist tsl WHERE sl.dbname = tsl.dbname AND sl.objectname = tsl.objectname and sl.id <> tsl.id              
                          
-- Delete matching records                          
DELETE tsl FROM #scriptlist tsl, scriptlist sl WHERE sl.dbname = tsl.dbname AND sl.id = tsl.id and sl.schema_ver = tsl.schema_ver                          
DELETE tsl FROM #scriptlist tsl, scriptlist sl WHERE tsl.objecttype IN ('DATABASE','JOB') AND sl.objectname  = tsl.objectname                           
                    
                    
-- Insert new records (have not been scripted before)                          
INSERT INTO scriptlist (ObjectType, ObjectSubType, ServerName, DBName, OwnerName, ObjectName, TableName, ScriptFile, id, uid, name, xtype, schema_ver, tiScript)                          
SELECT ObjectType, ObjectSubType, ServerName, DBName, OwnerName, ObjectName, TableName, ScriptFile, id, uid, name, xtype, schema_ver, 0 AS tiScript  FROM #scriptlist                          
              
DROP TABLE #scriptlist                          
/********************************************************************************************************************************************************************************************/                          
                          
SET @seq = 0                          
SET @maxseq = (SELECT max(seq) FROM Scriptlist)                          
                    
                          
  --SELECT * INTO SAV_NEWSCRIPT FROM SCRIPTLIST                          
                    
-- MAP DRIVES                    
-- V: = ss.exe folder                     
-- W: = workingfolder / scriptlist.scriptfile location                     
SET @cmd = 'net use V: ' + '"' + @vsspath + '\WIN32"'                    
exec master..xp_cmdshell @cmd, no_output                    
                    
SET @cmd = 'net use W: ' +  '"' + @uncpath + '"'                    
exec master..xp_cmdshell @cmd, no_output             
                    
                          
WHILE (SELECT COUNT(*) FROM scriptlist WHERE tiScript = 0) > 0                          
-- Execute scripting for each record in table.                          
 BEGIN                          
  --  SET @seq = @seq + 1                          
 SET @seq = (SELECT TOP 1 seq FROM scriptlist WHERE tiScript = 0 ORDER BY seq)                          
                    
 SET @projpath = '$/MSSQL/'                    
 SET @scriptpath = ''                    
                    
 SELECT                    
 @dbname = dbname,                     
 @objectname = objectname,                     
 @objecttype = objecttype,                     
 @objectsubtype = objectsubtype,                     
 @Tablename = tablename,                     
 @bitAddedVSS = bitAddedVSS,                    
 @scriptfile = scriptfile,                    
 @scriptpath =                     
  CASE                           
    -- path for sql database scripts                          
   WHEN objecttype = 'DATABASE' THEN @uncpath + '\' +@logicalsrv + '\DATABASE\' + objectname                    
    -- path for sql JOB scripts                          
   WHEN objecttype = 'JOB' THEN @uncpath + '\' +@logicalsrv + '\JOB'                    
    -- path for sql TABLE CHARACTERISTICTS scripts                          
   WHEN objecttype IN ('INDEX','KEY','TRIGGER','CHECK') THEN  @uncpath + '\' +@logicalsrv + '\DATABASE\' + DBNAME + '\' + OBJECTTYPE                    
    -- path for sql TABLE/VIEW/PROC scripts                          
   ELSE                     
  CASE WHEN Objectsubtype = '' THEN @uncpath + '\' +@logicalsrv + '\DATABASE\' + DBNAME + '\' + OBJECTTYPE                    
  ELSE  @uncpath + '\' +@logicalsrv + '\DATABASE\' + DBNAME + '\' + OBJECTTYPE  + '\' + OBJECTSUBTYPE                     
  END                    
  END,                    
 @projpath =                     
  CASE                           
    -- path for sql database scripts                          
   WHEN objecttype = 'DATABASE' THEN @projpath +@logicalsrv + '/DATABASE/' + objectname                    
    -- path for sql JOB scripts                          
   WHEN objecttype = 'JOB' THEN @projpath +@logicalsrv + '/JOB'                    
    -- path for sql TABLE CHARACTERISTICTS scripts                          
   WHEN objecttype IN ('INDEX','KEY','TRIGGER','CHECK') THEN  @projpath +@logicalsrv + '/DATABASE/' + DBNAME + '/' + OBJECTTYPE                    
    -- path for sql TABLE/VIEW/PROC scripts                          
   ELSE                     
  CASE WHEN Objectsubtype = '' THEN @projpath +@logicalsrv + '/DATABASE/' + DBNAME + '/' + OBJECTTYPE                    
  ELSE  @projpath + @logicalsrv + '/DATABASE/' + DBNAME + '/' + OBJECTTYPE  + '/' + OBJECTSUBTYPE                     
  END                    
  END                     
 FROM scriptlist WHERE @seq = seq                          
                    
 -- Check out the file provided it exists in a VSS project                     
 IF @bitAddedVSS = 1                    
   BEGIN                    
  -- CHECK OUT SCRIPT FROM SOURCESAFE                    
  -- 1) Change drive/dir to "working folder"                    
  -- 2) Set ssdir enviromental variable (where to find srcsafe.ini)                    
  -- 3) Execute SS checkout (will checkout specified project to current folder (set in step1 above))                    
  -- 4) Set ssdir to nothing (cleanup)                    
                      
  -- > outputs to file                    
  -- >> appends to file                    
                    
/*                    
  SET @cmd = 'ECHO SET SSDIR=' + @VSSPath + ASCII(13) +                    
  ' V:\SS CP ' + @projpath + ASCII(13) +                    
  ' V:\SS WORKFOLD ' + @projpath + ' "'  + @scriptpath + '"' + ASCII(13) +                    
  ' V:\SS CHECKOUT ' + @projpath + '/' + @objectname + '.sql -C- ' + ASCII(13) +                    
  ' SET SSDIR= > VSS_Checkout.bat'                    
  EXEC MASTER..XP_CMDSHELL @CMD                    
*/                    
                    
                    
  SET @cmd = 'ECHO SET SSDIR=' + @VSSPath + '> W:\' + @logicalsrv + '\VSS_Checkout.bat'                    
  exec master..xp_cmdshell @cmd, no_output                
                    
  SET @cmd = 'ECHO V:\SS CP ' + @projpath + '  -Y' + @upw + ' >> W:\' + @logicalsrv + '\VSS_Checkout.bat'                    
  exec master..xp_cmdshell @cmd, no_output                    
                    
  SET @cmd = 'ECHO V:\SS WORKFOLD ' + @projpath + ' "'  + @scriptpath + '"  -Y' + @upw + ' >> W:\' + @logicalsrv + '\VSS_Checkout.bat'                    
  exec master..xp_cmdshell @cmd, no_output                    
                      
  SET @cmd = 'ECHO V:\SS CHECKOUT ' + @projpath + '/' + @objectname + '.sql -C- -I-Y -Y' + @upw + ' >> W:\' + @logicalsrv + '\VSS_Checkout.bat'                    
  exec master..xp_cmdshell @cmd, no_output            
                    
  SET @cmd = 'ECHO SET SSDIR= >> W:\' + @logicalsrv + '\VSS_Checkout.bat'                    
  exec master..xp_cmdshell @cmd, no_output                    
                    
  SET @cmd ='W:\' + @logicalsrv + '\VSS_Checkout.bat'      
  exec master..xp_cmdshell @cmd, no_output                    
                    
   END                    
                     
 /*************************************/                     
 -- Update Script                    
 EXEC proc_genscript @@servername, @dbname, @objectname, @objecttype, @Tablename, @scriptfile, @error OUTPUT      -------------------------------------------------------!!!!!!!!!!!!!!!!!!!!!!!!!                    
 IF @ERROR <> 0                    
  BEGIN                       
   UPDATE Scriptlist SET tiScript = 99 WHERE seq = @seq                    
   GOTO ON_ERROR                    
  END                    
 /*************************************/                    
                     
 -- CHECK IN SCRIPT INTO SOURCESAFE                    
 -- 1) Change drive/dir to "working folder"                    
 -- 2) Set ssdir enviromental variable (where to find srcsafe.ini)                    
 -- 3) Execute SS checkIN (will checkout specified project to current folder (set in step1 above))                    
 -- 4) Set ssdir to nothing (cleanup)                    
                     
                    
 -- Check file back in if it was checked out (skip if the file was just added)                    
 IF @bitAddedVSS = 1                    
  BEGIN                    
                    
    SET @cmd = 'ECHO SET SSDIR=' + @VSSPath + '> W:\' + @logicalsrv + '\VSS_Checkin.bat'                    
    exec master..xp_cmdshell @cmd, no_output                    
                    
   SET @cmd = 'ECHO V:\SS CP ' + @projpath + '  -Y' + @upw + ' >> W:\' + @logicalsrv + '\VSS_Checkin.bat'                    
   exec master..xp_cmdshell @cmd, no_output                    
                    
   SET @cmd = 'ECHO V:\SS WORKFOLD ' + @projpath + ' "'  + @scriptpath + '"  -Y' + @upw + ' >> W:\' + @logicalsrv + '\VSS_Checkin.bat'                    
   exec master..xp_cmdshell @cmd, no_output                    
                       
   SET @cmd = 'ECHO V:\SS CHECKIN ' + @projpath + '/' + @objectname + '.sql -C- -I-Y -Y' + @upw + ' >> W:\' + @logicalsrv + '\VSS_Checkin.bat'                   
   exec master..xp_cmdshell @cmd, no_output                    
                     
   SET @cmd = 'ECHO SET SSDIR= >> W:\' + @logicalsrv + '\VSS_Checkin.bat'                     
   exec master..xp_cmdshell @cmd, no_output                    
                    
   SET @cmd = 'W:\' + @logicalsrv + '\VSS_Checkin.bat'      
   exec master..xp_cmdshell @cmd, no_output                    
  END                    
        
 IF @bitAddedVSS = 0                    
  BEGIN                    
                    
    SET @cmd = 'ECHO SET SSDIR=' + @VSSPath + '> W:\' + @logicalsrv + '\VSS_Add.bat'                    
    exec master..xp_cmdshell @cmd, no_output                    
                    
   SET @cmd = 'ECHO V:\SS CP ' + @projpath + '  -Y' + @upw + ' >> W:\' + @logicalsrv + '\VSS_Add.bat'                    
   exec master..xp_cmdshell @cmd, no_output                    
                    
   SET @cmd = 'ECHO V:\SS WORKFOLD ' + @projpath + ' "'  + @scriptpath + '"   -Y' + @upw + ' >> W:\' + @logicalsrv + '\VSS_Add.bat'                    
   exec master..xp_cmdshell @cmd, no_output                    
                    
   SET @cmd = 'ECHO V:\SS ADD "' + @scriptpath + '\' + @objectname + '.sql" -C- -I-Y -Y' + @upw + ' >> W:\' + @logicalsrv + '\VSS_Add.bat'                    
   exec master..xp_cmdshell @cmd, no_output                    
                    
    SET @cmd = 'ECHO SET SSDIR= >> W:\' + @logicalsrv + '\VSS_Add.bat'                    
    exec master..xp_cmdshell @cmd, no_output                    
                    
   SET @cmd = 'W:\' + @logicalsrv + '\VSS_Add.bat'        
   exec master..xp_cmdshell @cmd, no_output                    
                    
  -- updat bit to represent that the file has been added to VSS                    
  UPDATE scriptlist SET bitAddedVSS = 1 WHERE seq = @seq                    
  END                    
                    
 UPDATE scriptlist SET tiScript = 1, script_dt = GETDATE() WHERE seq = @seq                          
                    
 ON_ERROR:                    
 SET @error = 0                    
 SET @seq = (SELECT TOP 1 seq FROM scriptlist WHERE tiScript = 0 ORDER BY seq)                          
END                          
                          
-- CLEAN UP BAT FILES                
  SET @cmd = 'DEL W:\' + @logicalsrv + '\VSS_Add.bat'              
  EXEC master..xp_cmdshell @cmd, no_output        
        
  SET @cmd =  'DEL W:\' + @logicalsrv + '\VSS_Checkin.bat'                
  EXEC master..xp_cmdshell @cmd, no_output        
        
  SET @cmd ='DEL W:\' + @logicalsrv + '\VSS_Checkout.bat'                
  EXEC master..xp_cmdshell @cmd, no_output        
        
-- UNMAP DRIVES                    
  EXEC master..xp_cmdshell 'net use V: /DELETE', no_output                    
  EXEC master..xp_cmdshell 'net use W: /DELETE', no_output                    
                    
-- Check for errors and email the DBA
IF (SELECT COUNT(*) from scriptlist where ISNULL(tiscript,0) in (0,99)) > 0
	EXEC MASTER.DBO.XP_CMDSHELL 'cscript C:\Alert_VSSScript.vbs', no_output

SET NOCOUNT ON                          
RETURN                          
                          
                          
-- CHECK    
--  C = CHECK constraint                          
--  D = Default or DEFAULT constraint                          
-- KEY                          
--  F = FOREIGN KEY constraint                          
--  K (PK) = PRIMARY KEY constraint (type is K)                          
--  K (UQ) = UNIQUE constraint (type is K)                          
-- PROCEDURE                           
--  X = Extended stored procedure                          
--  P = Stored procedure                          
--  RF = Replication filter stored procedure                           
-- FUNCTION                          
--  FN = Scalar function                          
--  IF = Inlined table-function                          
--  TF = Table function                          
-- TRIGGER                           
--  TR = Trigger                          
-- TABLE                           
--  U = User table                          
-- VIEW                           
--  V = View                          
--                            
                          
-- DATABASE                          
 -- MASTER.DBO.SYSDATABASES -> script_dblist                          
-- JOB                         -- MSDB.DB0.SYSJOBS                    
                    
/*----------------------------------------------------------------------------------*/


