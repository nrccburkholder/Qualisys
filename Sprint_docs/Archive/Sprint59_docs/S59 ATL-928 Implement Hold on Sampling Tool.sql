/*
	S59 ATL-928 Implement Hold on Sampling Tool

	Implement a warning / block on Sampling Tool which prevents sampling from taking place if there is a HOLD record for the selected channel.

	Tim Butler

	Adding QUALPRO_Param for ODS connection string

*/

USE QP_PROD

DECLARE @param_id int
DECLARE @strparam_nm varchar(75)
DECLARE @strparam_type char(1)
DECLARE @strparam_grp varchar(20)
DECLARE @strparam_value varchar(255)
DECLARE @numparam_value int
DECLARE @dataparam_value datetime
DECLARE @comments varchar(255)
DECLARE @serverName varchar(20)
DECLARE @dbName varchar(50)

SET @serverName = @@SERVERNAME 

SET @strparam_grp = 'ConnectionStrings'

SET @dbName = CASE @serverName 
		WHEN 'nrc10' THEN 'pidisql01.nationalresearch.com'
		WHEN 'MHM0PQUALSQL02' THEN 'pidisql01.nationalresearch.com'
		WHEN 'gator' THEN 'sidisql01.devnrcus.local'
		WHEN 'MHM0SQUALSQL02' THEN 'sidisql01.devnrcus.local'
		ELSE 'didisql01.devnrcus.local'
END	

print @serverName + ' ' + @dbName

begin tran

SET @strparam_nm = 'ODSConnection'
SET @strparam_type = 'S'
SET @strparam_value = 'Data Source=' + @dbName + ';Initial Catalog=odsdb;user=odsdb;password=pho3nix!'
SET @numparam_value = NULL
SET @dataparam_value = NULL
SET @comments = 'Specifies the connection string for the ODS database'

SET @param_id = null
SELECT @param_id = param_id
FROM QUALPRO_PARAMS 
WHERE STRPARAM_GRP = @strparam_grp
AND STRPARAM_NM = @strparam_nm

IF @@ROWCOUNT = 0
BEGIN

	INSERT INTO [dbo].[QUALPRO_PARAMS]
           ([STRPARAM_NM]
           ,[STRPARAM_TYPE]
           ,[STRPARAM_GRP]
           ,[STRPARAM_VALUE]
           ,[NUMPARAM_VALUE]
           ,[DATPARAM_VALUE]
           ,[COMMENTS])
     VALUES
           (@strparam_nm
           ,@strparam_type
           ,@strparam_grp
           ,@strparam_value
           ,@numparam_value
           ,@dataparam_value
           ,@comments)
END
ELSE
BEGIN
	UPDATE [dbo].[QUALPRO_PARAMS]
	   SET [STRPARAM_NM] = @strparam_nm
		  ,[STRPARAM_TYPE] = @strparam_type
		  ,[STRPARAM_GRP] = @strparam_grp
		  ,[STRPARAM_VALUE] = @strparam_value
		  ,[NUMPARAM_VALUE] = @numparam_value
		  ,[DATPARAM_VALUE] = @dataparam_value
		  ,[COMMENTS] = @comments
	 WHERE PARAM_ID = @param_id
END

commit tran

select *
from dbo.QUALPRO_PARAMS
where STRPARAM_GRP = @strparam_grp
and STRPARAM_NM = @strparam_nm 

