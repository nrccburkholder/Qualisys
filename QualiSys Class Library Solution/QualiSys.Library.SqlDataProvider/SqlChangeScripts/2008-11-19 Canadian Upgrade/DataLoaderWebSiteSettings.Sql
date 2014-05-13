
/******************************************* DATALOADER WEB SITE SETTINGS ***************************************************/
USE [QP_Prod]
GO
/* Created By Arman Mnatsakanyan Creation Date: 2/27/2009 2:52:10 PM */
/* PROCEDURE Temp_InsertUpdateQualProParams must exist for this script to run */
Declare @EnvironmentName varchar(20)
Set @EnvironmentName = (Select strParam_Value  From QualPro_Params Where strParam_Nm = 'EnvName')

			/* Not application specific settings used in DaatLoader Web Site:
				'NotificationConnection', --strParam_nm
				'NrcAuthConnection', --strParam_nm
				'DataMartConnection',  'Data Source=Medusa; Initial Catalog=QP_Comments; uid=qpsa; pwd=qpsa; Application Name=My Solutions'
				'QP_LoadConnection', 'Data Source=Mars;UID=qpsa;PWD=qpsa;Initial Catalog=QP_Load', --strParam_Value
				'SmtpServer', --strParam_nm
			*/

	/* Application My.Settings */
			Exec [Temp_InsertUpdateQualProParams] 
				'DLWExceptionFromAddress', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'DataLoaderWebSite', --strParam_GRP
				'MySolutions@NationalResearch.com', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'From address for exception emails' --Please enter the description
			Exec [Temp_InsertUpdateQualProParams] 
				'DLWExceptionToAddress', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'DataLoaderWebSite', --strParam_GRP
				'MySolutionsExceptions@NationalResearch.com', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'destination email address for exception emails' --Please enter the description
	/* End Application My.Settings */



	/* Global Settings */
			/* Comment Connection Strings, SMTPServer, SQLTimeOut
				'SqlTimeout', --strParam_nm
			End Comment Connection Strings, SMTPServer, SQLTimeOut */
			Exec [Temp_InsertUpdateQualProParams] 
				'DLWeReportsUrl', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'DataLoaderWebSite', --strParam_GRP
				'/eReports', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'eReports URL (relative)' --Please enter the description
			Exec [Temp_InsertUpdateQualProParams] 
				'DLWeCommentsUrl', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'DataLoaderWebSite', --strParam_GRP
				'/eComments', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'eComments relative URL' --Please enter the description
			Exec [Temp_InsertUpdateQualProParams] 
				'DLWeToolKitUrl', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'DataLoaderWebSite', --strParam_GRP
				'/My%20Solutions/eToolKit', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'eToolKit URL' --Please enter the description
			Exec [Temp_InsertUpdateQualProParams] 
				'DLWMyAccountUrl', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'DataLoaderWebSite', --strParam_GRP
				'/MyAccount', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'MyAccount relative URL' --Please enter the description
			Exec [Temp_InsertUpdateQualProParams] 
				'ClientSupportEmailAddress', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'DataLoaderWebSite', --strParam_GRP
				'ClientSupport@NationalResearch.com', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'Client Support team e-mail address. Used by DataLoader Web Site and Qualisys.Qloader.Library' --Please enter the description
			Exec [Temp_InsertUpdateQualProParams] 
				'LoadingTeamTestEmailAddress', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'DataLoaderWebSite', --strParam_GRP
				'LoadingTeamTest@NationalResearch.com', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'e-mail address for testing DataLoader. The success or failure email will go to this address instead of the package owner address.' --Please enter the description				
			Exec [Temp_InsertUpdateQualProParams] 
				'MySolutionsEmailAddress', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'DataLoaderWebSite', --strParam_GRP
				'MySolutions@nationalresearch.com', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'MySolutions e-mail address. This is currently used by DataLoader Web Site.' --Please enter the description		
	/* End Global Settings */

	/* Production Settings */
	IF @EnvironmentName = 'PRODUCTION'
		Begin
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'DLWUseSsl', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'DataLoaderWebSite', --strParam_GRP
				'True', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'Set to true to use SSL for DataLoader Web site.' --Please enter the description
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'DLWDataLoaderSaveFolder', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'DataLoaderWebSite', --strParam_GRP
				'\\hercules\data\DataLoaderFiles', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'Destination Folder for uploaded files' --Please enter the description
		End
	/* End Production Settings */

	/* Staging Settings */
	IF @EnvironmentName = 'STAGING'
		Begin
		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'DLWUseSsl', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'DataLoaderWebSite', --strParam_GRP
				'True', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'Set to true to use SSL for DataLoader Web site.' --Please enter the description
		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'DLWDataLoaderSaveFolder', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'DataLoaderWebSite', --strParam_GRP
				'\\nugget\data\DataLoaderFiles', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'Destination Folder for uploaded files' --Please enter the description
		End
	/* End Staging Settings */

	/* Testing Settings */
	IF @EnvironmentName = 'TESTING'
		Begin
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'DLWUseSsl', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'DataLoaderWebSite', --strParam_GRP
				'True', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'Set to true to use SSL for DataLoader Web site.' --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'DLWDataLoaderSaveFolder', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'DataLoaderWebSite', --strParam_GRP
				'\\sylar\data\DataLoaderFiles', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'Destination Folder for uploaded files' --Please enter the description
		End
	/* End Testing Settings */
