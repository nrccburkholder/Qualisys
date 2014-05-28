CREATE PROCEDURE [dbo].[QCL_StudyAddUser]
@SchemaName char(10)
AS

DECLARE @SQL varchar(5000)

SET NOCOUNT ON

/*
SET @SQL = 'Execute sp_addlogin ' + @SchemaName
EXEC(@SQL)
SET @SQL = 'Execute sp_adduser ' + @SchemaName + ', ' + @SchemaName + ', Studys'
EXEC(@SQL)
*/
SET NOCOUNT OFF


