/****** Object:  Stored Procedure dbo.proc_genscript    Script Date: 9/10/2003 9:50 AM ******/  
  
CREATE PROCEDURE proc_genscript   
 @ServerName varchar(130),   
 @DBName varchar(130),   
 @ObjectName varchar(200),   
 @ObjectType varchar(10),   
 @TableName varchar(200),  
 @ScriptFile varchar(1000),  
 @error INT OUTPUT  
AS  
  
DECLARE @CmdStr varchar(2000)  
DECLARE @object int  
DECLARE @hr int  
DECLARE @property varchar(255)  
DECLARE @return varchar(255)  
DECLARE @src varchar(255)  
DECLARE @desc varchar(255)  
DECLARE @Options varchar(30)  
  
SET NOCOUNT ON  
  
-- Create an object.  
SET @CmdStr = 'Connect('+@ServerName+')'  
EXEC @hr = sp_OACreate 'SQLDMO.SQLServer', @object OUT  
  
IF @hr <> 0  
BEGIN  
   EXEC sp_OAGetErrorInfo @object, @src OUT, @desc OUT   
   SELECT hr=convert(varbinary(4),@hr), Source=@src, Description=@desc  
   SET @error = @hr  
END  
  
  
--*Comment out for standard login  
-- Set a property.  
EXEC @hr = sp_OASetProperty @object, 'LoginSecure', TRUE  
  
IF @hr <> 0  
BEGIN  
   EXEC sp_OAGetErrorInfo @object, @src OUT, @desc OUT   
   SELECT hr=convert(varbinary(4),@hr), Source=@src, Description=@desc  
   SET @error = @hr  
   GOTO Destructor  
END  
  
  
/* Uncomment for Standard Login  
EXEC @hr = sp_OASetProperty @object, 'Login', 'sa'  
EXEC @hr = sp_OASetProperty @object, 'password', 'sapassword'  
  
IF @hr <> 0  
BEGIN  
   EXEC sp_OAGetErrorInfo @object, @src OUT, @desc OUT   
   SELECT hr=convert(varbinary(4),@hr), Source=@src, Description=@desc  
   GOTO Destructor  
END  
*/  
  
  
  
  
  
-- Call a method.  
EXEC @hr = sp_OAMethod @object,@CmdStr  
  
IF @hr <> 0  
BEGIN  
   EXEC sp_OAGetErrorInfo @object, @src OUT, @desc OUT   
   SELECT hr=convert(varbinary(4),@hr), Source=@src, Description=@desc  
   SET @error = @hr  
   GOTO Destructor  
END  
  
/*  
SQLDMOScript_TransferDefault    
  
422143  - 131072 = 291071  
  
Default.   
  SQLDMOScript_PrimaryObject,   
  SQLDMOScript_Drops,   
  SQLDMOScript_Bindings,   
  SQLDMOScript_ClusteredIndexes,   
  SQLDMOScript_NonClusteredIndexes,   
  SQLDMOScript_Triggers,   
  SQLDMOScript_ToFileOnly,  (64)  
  SQLDMOScript_Permissions,   
REM (sjs 2/12/04)  SQLDMOScript_IncludeHeaders,  (131072)  
  SQLDMOScript_Aliases,   
  SQLDMOScript_IncludeIfNotExists,   
  and SQLDMOScript_OwnerQualify   
  combined using an OR logical operator.   
  
*/  
  
SET @Options = convert(varchar,  
  CASE @ObjectType  
    WHEN 'Database' THEN 422143   
    WHEN 'Procedure'THEN 422143  
    WHEN 'View'  THEN 422143   
    WHEN 'Table' THEN 291071  
    WHEN 'Function' THEN 422143   
    WHEN 'Index' THEN 422143   
    WHEN 'Trigger' THEN 422143   
    WHEN 'Key'  THEN 422143   
    WHEN 'Check' THEN 422143   
    WHEN 'Job'  THEN 422143   
  END)  
  
SET @CmdStr =   
  CASE @ObjectType  
    WHEN 'Database' THEN 'Databases("'              + @ObjectName + '").Script(' + @Options + ',"' + @ScriptFile + '")'  
    WHEN 'Procedure'THEN 'Databases("' + @DBName + '").StoredProcedures("'      + @ObjectName + '").Script(' + @Options + ',"' + @ScriptFile + '")'  
    WHEN 'View'  THEN 'Databases("' + @DBName + '").Views("'         + @ObjectName + '").Script(' + @Options + ',"' + @ScriptFile + '")'  
    WHEN 'Table' THEN 'Databases("' + @DBName + '").Tables("'        + @ObjectName + '").Script(' + @Options + ',"' + @ScriptFile + '")'  
    WHEN 'Function' THEN 'Databases("' + @DBName + '").UserDefinedFunctions("'      + @ObjectName + '").Script(' + @Options + ',"' + @ScriptFile + '")'  
    WHEN 'Index' THEN 'Databases("' + @DBName + '").Tables("' + @TableName + '").Indexes("'  + @ObjectName + '").Script(' + @Options + ',"' + @ScriptFile + '")'  
    WHEN 'Trigger' THEN 'Databases("' + @DBName + '").Tables("' + @TableName + '").Triggers("'  + @ObjectName + '").Script(' + @Options + ',"' + @ScriptFile + '")'  
    WHEN 'Key'  THEN 'Databases("' + @DBName + '").Tables("' + @TableName + '").Keys("'   + @ObjectName + '").Script(' + @Options + ',"' + @ScriptFile + '")'  
    WHEN 'Check' THEN 'Databases("' + @DBName + '").Tables("' + @TableName + '").Checks("'   + @ObjectName + '").Script(' + @Options + ',"' + @ScriptFile + '")'  
    WHEN 'Job'  THEN 'Jobserver.Jobs("'                + @ObjectName + '").Script(' + @Options + ',"' + @ScriptFile + '")'  
  END  
  
 --SET @CmdStr = @CmdStr + @ObjectName + '").Script(64,"' + @ScriptFile + '")'  
  
EXEC @hr = sp_OAMethod @object, @CmdStr  
  
IF @hr <> 0  
BEGIN  
   EXEC sp_OAGetErrorInfo @object, @src OUT, @desc OUT   
   SELECT hr=convert(varbinary(4),@hr), Source=@src, Description=@desc  
   SET @error = @hr  
   GOTO Destructor  
END  
  
  
  
-- Destroy the object.  
Destructor:  
  
-- Disconnect OA object (prior to Destruction) else associated processess will be orphaned when the OA object is Destroyed. LARGE MEMORY LEAK!!!  
EXEC @hr = sp_OAMethod @object, 'Disconnect'  
EXEC @hr = sp_OADestroy @object  
  
IF @hr <> 0  
BEGIN  
   EXEC sp_OAGetErrorInfo @object, @src OUT, @desc OUT   
   SELECT hr=convert(varbinary(4),@hr), Source=@src, Description=@desc  
   SET @error = @hr  
   RETURN  
END  
  
SET NOCOUNT OFF  
  
/********************************************************/  
/****** Object:  Stored Procedure dbo.proc_genscript ****/  
/******Script Date: 9/10/2003 9:50 AM                ****/  
/****** Reference: databasejournal.com               ****/  
/****** Created By:Shailesh Khanal                   ****/  
/********************************************************/  
  
  
-- The script file location is relative to the SQL Server box.  
--   
-- EXEC dbo.proc_genscript   
--   
-- Usage Example: exec proc_genscript   
--  @ServerName = 'MyServer',   
--  @DBName = 'Pubs',   
--  @ObjectName = 'CK__authors__au_id__77BFCB91',   
--  @ObjectType = 'Check',   
--  @TableName = 'authors',  
--  @ScriptFile = 'c:\temp\pubs.sql'  
  
-- To generate scripts for multiple objects, you can write a procedure, which builds a cursor with all the object names you want scripted and call proc_genscript one by one.  
  
/********************************************************/


