
/***************************************** DataMart EXPORTSERVICE SETTINGS ***********************************************/
USE [QP_Prod]
GO
/* Created By Arman Mnatsakanyan Creation Date: 2/24/2009 4:44:09 PM */
/* PROCEDURE Temp_InsertUpdateQualProParams must exist for this script to run */
Declare @EnvironmentName varchar(20)
Set @EnvironmentName = (Select strParam_Value  From QualPro_Params Where strParam_Nm = 'EnvName')
			Exec [Temp_InsertUpdateQualProParams] 
				'ESDataMartDataProvider', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'ExportService', --strParam_GRP
				'Nrc.DataMart.Library.SqlProvider.SqlDataProvider, Nrc.DataMart.Library.SqlProvider', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
	/* Production Settings */
	IF @EnvironmentName = 'PRODUCTION'
		Begin
		/* Environment name = "Production" */
			/* Comment Connection Strings, SMTPServer, SQLTimeOut
				'DataMartConnection', --strParam_nm
				'SmtpServer', --strParam_nm
			End Comment Connection Strings, SMTPServer, SQLTimeOut */
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'ESExportIntervalSeconds', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'ExportService', --strParam_GRP
				Null, --strParam_Value
				'600', --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'ESErroredFolderPath', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'ExportService', --strParam_GRP
				'\\Neptune\nrc4\ExportErrors\', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'ESErroredFileExpirationDays', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'ExportService', --strParam_GRP
				Null, --strParam_Value
				'14', --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'ESOutputFolderPath', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'ExportService', --strParam_GRP
				'\\Neptune\nrc4\Exports\', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'ESFileExpirationDays', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'ExportService', --strParam_GRP
				Null, --strParam_Value
				'14', --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'ESExportNotifcationEmailAddress', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'ExportService', --strParam_GRP
				'Analyst@NationalResearch.com', --strParam_Value
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
				'ESExportIntervalSeconds', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'ExportService', --strParam_GRP
				Null, --strParam_Value
				'600', --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description

		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'ESErroredFolderPath', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'ExportService', --strParam_GRP
				'\\Huskers\ExportErrors\', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description

		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'ESErroredFileExpirationDays', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'ExportService', --strParam_GRP
				Null, --strParam_Value
				'14', --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description

		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'ESOutputFolderPath', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'ExportService', --strParam_GRP
				'\\Huskers\ScheduledExports\', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description

		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'ESFileExpirationDays', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'ExportService', --strParam_GRP
				Null, --strParam_Value
				'14', --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description

		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'ESExportNotifcationEmailAddress', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'ExportService', --strParam_GRP
				'Testing@NationalResearch.com', --strParam_Value
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
				'ESExportIntervalSeconds', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'ExportService', --strParam_GRP
				Null, --strParam_Value
				'120', --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'ESErroredFolderPath', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'ExportService', --strParam_GRP
				'\\Superman\ExportErrors\', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'ESErroredFileExpirationDays', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'ExportService', --strParam_GRP
				Null, --strParam_Value
				'14', --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'ESOutputFolderPath', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'ExportService', --strParam_GRP
				'\\Superman\ScheduledExports\', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'ESFileExpirationDays', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'ExportService', --strParam_GRP
				Null, --strParam_Value
				'14', --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'ESExportNotifcationEmailAddress', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'ExportService', --strParam_GRP
				'Testing@NationalResearch.com', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		End
	/* End Testing Settings */
