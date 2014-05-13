
/********************************************* NRCAUTHADMIN SETTINGS *******************************************************/
USE [QP_Prod]
GO
/* Created By Arman Mnatsakanyan Creation Date: 3/19/2009 9:43:24 AM */
/* PROCEDURE Temp_InsertUpdateQualProParams must exist for this script to run */
Declare @EnvironmentName varchar(20)
Set @EnvironmentName = (Select strParam_Value  From QualPro_Params Where strParam_Nm = 'EnvName')

	/* User Settings (These settings must stay in configuration file)
				Name: 'NAAMainFormLocation', Value: '0, 0'
				Name: 'NAAMainFormWindowState', Value: 'Maximized'
				Name: 'NAAMainFormSize', Value: '635, 496'
				Name: 'NAAStandardOneClickDialogSize', Value: '608, 408'
				Name: 'NAAMainFormSplitterLocation', Value: '218'
		End User Settings */
			/* The following is the list of not application specific settings that are used also in NRCAuth Admin
				'NRCAuthConnection', 
				'DataMartConnection', 
				'SmtpServer', 
				'NrcPickerURL'
				'SqlTimeOut'
			End  Comment */

			/* Global Settings */
			Exec [Temp_InsertUpdateQualProParams] 
				'NAAMailFromAccount', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'NrcAuthAdmin', --strParam_GRP
				'LogonSupport@NRCPicker.com', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'This From account is used to send the exception e-mails from Nrc Auth Admin.' --Please enter the description
	/* End Global Settings */


	/* Production Settings */
	IF @EnvironmentName = 'PRODUCTION'
		Begin
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'NAAReportServer', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'NrcAuthAdmin', --strParam_GRP
				'Reports', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'The SSRS server name where NrcAuth Reports are stored.' --Please enter the description
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'NAAReportFolder', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'NrcAuthAdmin', --strParam_GRP
				'/NRCAuthReports', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'The SSRS Folder name where NrcAuth Reports are stored' --Please enter the description
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'NAASiteUrl', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'NrcAuthAdmin', --strParam_GRP
				'https://NRCPicker.com/MyAccount/', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'MyAccount Web application URL' --Please enter the description
		End
	/* End Production Settings */

	/* Staging Settings */
	IF @EnvironmentName = 'STAGING'
		Begin
		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'NAAReportServer', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'NrcAuthAdmin', --strParam_GRP
				'RunningRebel', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'The SSRS server name where NrcAuth Reports are stored.' --Please enter the description

		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'NAAReportFolder', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'NrcAuthAdmin', --strParam_GRP
				'/Web Usage Reports', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'The SSRS Folder name where NrcAuth Reports are stored' --Please enter the description

		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'NAASiteUrl', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'NrcAuthAdmin', --strParam_GRP
				'https://stage.nrcpicker.com/MyAccount/', --strParam_Value
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
				'NAAReportServer', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'NrcAuthAdmin', --strParam_GRP
				'Ironman', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'The SSRS server name where NrcAuth Reports are stored.' --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'NAAReportFolder', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'NrcAuthAdmin', --strParam_GRP
				'/Web Usage Reports', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'NAASiteUrl', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'NrcAuthAdmin', --strParam_GRP
				'https://test.nrcpicker.com/MyAccount/', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Testing" */	
		End
	/* End Testing Settings */
