CREATE PROCEDURE [dbo].[TR_SelectTransferResultsUserActivity]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


DECLARE @Country as nvarchar(2)

SELECT @Country = strParam_Value
FROM QualPro_Params 
WHERE strParam_nm='Country'

DECLARE @countryName1 varchar(10)
DECLARE @countryName2 varchar(10)
DECLARE @linkedServer varchar(20)

IF @Country = 'CA'
BEGIN
	SET @countryName1 = 'Canada'
	SET @countryName2 = 'US'
	SET @linkedServer = '[QUALISYSUS]'
END
ELSE
BEGIN
	SET @countryName2 = 'Canada'
	SET @countryName1 = 'US'
	SET @linkedServer = '[QUALISYSCA]'
END

	DECLARE @sql nvarchar(max)

	SET @sql = 'SELECT '
	SET @sql = @sql + '''' + @countryName1 + ''' ''Country'' '
	SET @sql = @sql + ',[UserName] ''User'' '
	SET @sql = @sql + '	,[WorkStationName] ''Workstation'' '
	SET @sql = @sql + '	,[Login_dt] ''Started'' '
	SET @sql = @sql + '	,CASE [STRChecked] WHEN 1 THEN ''ON'' ELSE ''---'' END ''STR'' '
	SET @sql = @sql + '	,CASE [VSTRChecked] WHEN 1 THEN ''ON'' ELSE ''---'' END ''VSTR'' '
	SET @sql = @sql + 'FROM [dbo].[TransferResultLoginActivity] '
	SET @sql = @sql + 'WHERE [Logout_dt] is NULL '
	SET @sql = @sql + 'UNION '
	SET @sql = @sql + 'SELECT '
	SET @sql = @sql + '''' + @countryName2 + ''' ''Country'' '
	SET @sql = @sql + ',[UserName] ''User'' '
	SET @sql = @sql + '	,[WorkStationName] ''Workstation'' '
	SET @sql = @sql + '	,[Login_dt] ''Started'' '
	SET @sql = @sql + '	,CASE [STRChecked] WHEN 1 THEN ''ON'' ELSE ''---'' END ''STR'' '
	SET @sql = @sql + '	,CASE [VSTRChecked] WHEN 1 THEN ''ON'' ELSE ''---'' END ''VSTR'' '
	SET @sql = @sql + 'FROM ' + @linkedServer + '.[QP_Prod].[dbo].[TransferResultLoginActivity] '
	SET @sql = @sql + 'WHERE [Logout_dt] is NULL '
	SET @sql = @sql + 'ORDER BY [Login_dt] desc '

	print @sql
	EXECUTE sp_executesql @sql

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


