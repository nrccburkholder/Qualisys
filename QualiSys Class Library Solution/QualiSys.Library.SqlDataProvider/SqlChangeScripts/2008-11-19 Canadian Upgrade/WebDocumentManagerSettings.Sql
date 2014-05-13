
/********************************************* WEBDOCUMENTMANAGER SETTINGS *******************************************************/
USE [QP_Prod]
GO
/* Created By Arman Mnatsakanyan Creation Date: 2/23/2009 10:02:29 AM */
/* PROCEDURE Temp_InsertUpdateQualProParams must exist for this script to run */
Declare @EnvironmentName varchar(20)
Set @EnvironmentName = (Select strParam_Value  From QualPro_Params Where strParam_Nm = 'EnvName')

	/* Environment Independent Settings */
			Exec [Temp_InsertUpdateQualProParams] 
				'FileSizeLimitkB', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'WebDocumentManager', --strParam_GRP
				Null, --strParam_Value
				'10240', --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
	/* End Global Settings */


	/* Production Settings */
	IF @EnvironmentName = 'PRODUCTION'
		Begin
		/* The following not application specific settings are also used in WebDocumentManager  application
				SMTPServer, NRCAuthConnection, DatamartConnection, SqlTimeout			*/
		/* Environment name = "Production USA" */
			Exec [Temp_InsertUpdateQualProParams] 
				'WebDocumentPosterUrl', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'WebDocumentManager', --strParam_GRP
				'http://nrcpicker.com:12140/FileManager.asmx', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		End
	/* End Production Settings */

	/* Staging Settings */
	IF @EnvironmentName = 'STAGING'
		Begin
		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'WebDocumentPosterUrl', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'WebDocumentManager', --strParam_GRP
				'http://stage.nrcpicker.com:12140/FileManager.asmx', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description

		End
	/* End Staging Settings */

	/* Testing Settings */
	IF @EnvironmentName = 'TESTING'
		Begin
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'WebDocumentPosterUrl', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'WebDocumentManager', --strParam_GRP
				'http://test.nrcpicker.com:12140/FileManager.asmx', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		End
	/* End Testing Settings */

