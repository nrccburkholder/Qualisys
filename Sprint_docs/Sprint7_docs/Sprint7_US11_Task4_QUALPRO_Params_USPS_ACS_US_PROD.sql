USE QP_PROD

DECLARE @param_id int
DECLARE @strparam_nm varchar(75)
DECLARE @strparam_type char(1)
DECLARE @strparam_grp varchar(20)
DECLARE @strparam_value varchar(255)
DECLARE @numparam_value int
DECLARE @dataparam_value datetime
DECLARE @comments varchar(255)

SET @strparam_grp = 'USPS_ACS_Service'


begin tran

SET @strparam_nm = 'USPS_ACS_Webservice_username'
SET @strparam_type = 'S'
SET @strparam_value = 'kanstine@nationalresearch.com'
SET @numparam_value = NULL
SET @dataparam_value = NULL
SET @comments = 'Username for connecting to USPS ACS Download Web Service'

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

SET @strparam_nm = 'USPS_ACS_Webservice_password'
SET @strparam_type = 'S'
SET @strparam_value = 'NatlRes1245'
SET @dataparam_value = NULL
SET @comments = 'Password for connecting to USPS ACS Download Web Service'

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
		  ,[STRPARAM_VALUE] = @STRPARAM_VALUE
		  ,[NUMPARAM_VALUE] = @numparam_value
		  ,[DATPARAM_VALUE] = @dataparam_value
		  ,[COMMENTS] = @comments
	 WHERE PARAM_ID = @param_id
END

SET @strparam_nm = 'USPS_ACS_ResultFiles_Path'
SET @strparam_type = 'S'
SET @strparam_value = '\\superman\Production\USPS_ACS\Downloads' --'\\lnk0pfil01\Teams\Client Services\Audit Team\Accountable Care Organizations\ACS result files'
SET @dataparam_value = NULL
SET @comments = 'Location to download USPS ACS zip files'

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
		  ,[STRPARAM_VALUE] = @STRPARAM_VALUE
		  ,[NUMPARAM_VALUE] = @numparam_value
		  ,[DATPARAM_VALUE] = @dataparam_value
		  ,[COMMENTS] = @comments
	 WHERE PARAM_ID = @param_id
END



SET @strparam_nm = 'USPS_ACS_ServiceDownloadInterval'
SET @strparam_type = 'S'
SET @strparam_value = '0 0 23 1/1 * ? *' -- this is set to run once a day at 11:00 PM
SET @numparam_value = NULL
SET @dataparam_value = NULL
SET @comments = 'Service Interval for Download Job -- CronExpression'

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
		  ,[STRPARAM_VALUE] = @STRPARAM_VALUE
		  ,[NUMPARAM_VALUE] = @numparam_value
		  ,[DATPARAM_VALUE] = @dataparam_value
		  ,[COMMENTS] = @comments
	 WHERE PARAM_ID = @param_id
END



SET @strparam_nm = 'USPS_ACS_ServiceExtractInterval'
SET @strparam_type = 'S'
SET @strparam_value = '0 0 6 1/1 * ? *' -- this is set to run once a day at 6:00 AM
SET @numparam_value = NULL
SET @dataparam_value = NULL
SET @comments = 'Service Interval for Extract Job -- CronExpression'

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
		  ,[STRPARAM_VALUE] = @STRPARAM_VALUE
		  ,[NUMPARAM_VALUE] = @numparam_value
		  ,[DATPARAM_VALUE] = @dataparam_value
		  ,[COMMENTS] = @comments
	 WHERE PARAM_ID = @param_id
END


SET @strparam_nm = 'USPS_ACS_FileExtractionPassword'
SET @strparam_type = 'S'
SET @strparam_value = '9@1&1Y2A0D4S0E4U2t'
SET @numparam_value = NULL
SET @dataparam_value = NULL
SET @comments = 'Password for extracting files from USPS zips'

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
		  ,[STRPARAM_VALUE] = @STRPARAM_VALUE
		  ,[NUMPARAM_VALUE] = @numparam_value
		  ,[DATPARAM_VALUE] = @dataparam_value
		  ,[COMMENTS] = @comments
	 WHERE PARAM_ID = @param_id
END


SET @strparam_nm = 'USPS_ACS_FileExtractionPath'
SET @strparam_type = 'S'
SET @strparam_value = '\\superman\Production\USPS_ACS\ExtractedFiles'
SET @numparam_value = NULL
SET @dataparam_value = NULL
SET @comments = 'Location to which files are extracted from USPS zip files'

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
		  ,[STRPARAM_VALUE] = @STRPARAM_VALUE
		  ,[NUMPARAM_VALUE] = @numparam_value
		  ,[DATPARAM_VALUE] = @dataparam_value
		  ,[COMMENTS] = @comments
	 WHERE PARAM_ID = @param_id
END

SET @strparam_nm = 'USPS_ACS_SendErrorNotificationTo'
SET @strparam_type = 'S'
SET @strparam_value = 'TransferResultsErrors@nationalresearch.com'
SET @numparam_value = NULL
SET @dataparam_value = NULL
SET @comments = 'Email address to send error notification to'

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
		  ,[STRPARAM_VALUE] = @STRPARAM_VALUE
		  ,[NUMPARAM_VALUE] = @numparam_value
		  ,[DATPARAM_VALUE] = @dataparam_value
		  ,[COMMENTS] = @comments
	 WHERE PARAM_ID = @param_id
END


SET @strparam_nm = 'USPS_ACS_SendErrorNotificationBcc'
SET @strparam_type = 'S'
SET @strparam_value = 'testing@nationalresearch.com'
SET @numparam_value = NULL
SET @dataparam_value = NULL
SET @comments = 'Email address to Bcc error notification to'

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
		  ,[STRPARAM_VALUE] = @STRPARAM_VALUE
		  ,[NUMPARAM_VALUE] = @numparam_value
		  ,[DATPARAM_VALUE] = @dataparam_value
		  ,[COMMENTS] = @comments
	 WHERE PARAM_ID = @param_id
END

SET @strparam_nm = 'USPS_ACS_SendStatusNotificationTo'
SET @strparam_type = 'S'
SET @strparam_value = 'TransferResultsErrors@nationalresearch.com'
SET @numparam_value = NULL
SET @dataparam_value = NULL
SET @comments = 'Email address to send status notification to'

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
		  ,[STRPARAM_VALUE] = @STRPARAM_VALUE
		  ,[NUMPARAM_VALUE] = @numparam_value
		  ,[DATPARAM_VALUE] = @dataparam_value
		  ,[COMMENTS] = @comments
	 WHERE PARAM_ID = @param_id
END


SET @strparam_nm = 'USPS_ACS_SendStatusNotificationBcc'
SET @strparam_type = 'S'
SET @strparam_value = 'testing@nationalresearch.com'
SET @numparam_value = NULL
SET @dataparam_value = NULL
SET @comments = 'Email address to Bcc status notification to'

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
		  ,[STRPARAM_VALUE] = @STRPARAM_VALUE
		  ,[NUMPARAM_VALUE] = @numparam_value
		  ,[DATPARAM_VALUE] = @dataparam_value
		  ,[COMMENTS] = @comments
	 WHERE PARAM_ID = @param_id
END


SET @strparam_nm = 'USPS_ACS_VersionList'
SET @strparam_type = 'S'
SET @strparam_value = '00,01'
SET @numparam_value = NULL
SET @dataparam_value = NULL
SET @comments = 'ACS File Format versions -- 00 is original'

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
		  ,[STRPARAM_VALUE] = @STRPARAM_VALUE
		  ,[NUMPARAM_VALUE] = @numparam_value
		  ,[DATPARAM_VALUE] = @dataparam_value
		  ,[COMMENTS] = @comments
	 WHERE PARAM_ID = @param_id
END

SET @strparam_nm = 'USPS_ACS_SentMailingRange'
SET @strparam_type = 'N'
SET @strparam_value = NULL
SET @numparam_value = '28'
SET @dataparam_value = NULL
SET @comments = 'Number of days to go back from file date to check for matching addresses'

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


SET @strparam_nm = 'USPS_ACS_DoDownload'
SET @strparam_type = 'N'
SET @strparam_value = NULL
SET @numparam_value = '0'
SET @dataparam_value = NULL
SET @comments = 'Indicates whether the USPS_ACS_Service should execute the Zip download when it runs. 0 = false, 1 = true'

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



SELECT *
FROM QUALPRO_PARAMS 
WHERE STRPARAM_GRP = @strparam_grp

SELECT *
from QUALPRO_PARAMS
where STRPARAM_GRP = 'USPS_ACS_Service'