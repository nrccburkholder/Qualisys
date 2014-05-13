
/********************************************* EXPORTMANAGER SETTINGS *******************************************************/
USE [QP_Prod]
GO
/* Created By Arman Mnatsakanyan Creation Date: 2/24/2009 4:20:33 PM */
/* PROCEDURE Temp_InsertUpdateQualProParams must exist for this script to run */
Declare @EnvironmentName varchar(20)
Set @EnvironmentName = (Select strParam_Value  From QualPro_Params Where strParam_Nm = 'EnvName')

	/* User Settings (These settings must stay in configuration file)
				Name: 'EMLastExportPath', Value: '
				Name: 'EMMainFormLocation', Value: '0, 0
				Name: 'EMMainFormSize', Value: '720, 500
				Name: 'EMMainFormSplitterLocation', Value: '218
				Name: 'EMMainFormWindowState', Value: 'Maximized
		End User Settings */

	/* Application My.Settings */
			Exec [Temp_InsertUpdateQualProParams] 
				'EMMaxExportCombinationYearDifference', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'ExportManager', --strParam_GRP
				Null, --strParam_Value
				'2', --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
			Exec [Temp_InsertUpdateQualProParams] 
				'EMMaxExportCombinationCount', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'ExportManager', --strParam_GRP
				Null, --strParam_Value
				'20', --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
	/* End Application My.Settings */



	/* Global Settings */
			Exec [Temp_InsertUpdateQualProParams] 
				'EMLogEvents', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'ExportManager', --strParam_GRP
				'true', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
	/* End Global Settings */


	/* Production Settings */
	IF @EnvironmentName = 'PRODUCTION'
		Begin
		/* The following not application specific settings are also used in WebDocumentManager  application
		SMTPServer, NRCAuthConnection, DatamartConnection, SqlTimeout			*/
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'EMErroredFolderPath', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'ExportManager', --strParam_GRP
				'\\Neptune\nrc4\ExportErrors\', --strParam_Value
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
				'EMErroredFolderPath', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'ExportManager', --strParam_GRP
				'\\Huskers\ExportErrors\', --strParam_Value
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
				'EMErroredFolderPath', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'ExportManager', --strParam_GRP
				'\\Superman\ExportErrors\', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		End
	/* End Testing Settings */
