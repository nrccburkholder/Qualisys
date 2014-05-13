/******************************************* DATALOADER ADMIN SITE SETTINGS ***************************************************/
USE [QP_Prod]
GO
/* Created By Arman Mnatsakanyan Creation Date: 5/19/2009  */
/* PROCEDURE Temp_InsertUpdateQualProParams must exist for this script to run */
Declare @EnvironmentName varchar(20)
Set @EnvironmentName = (Select strParam_Value  From QualPro_Params Where strParam_Nm = 'EnvName')
		/* Global settings (independent of the environments) */
			Exec [Temp_InsertUpdateQualProParams] 
			'LDUploadedFileReport', 
			'S', 
			'DataLoader', 
			'Data+Loader+Uploaded+File', 
			NULL, NULL, 'SSRS [Uploaded Files] report name' 
		/* End Global Settings */
		
	IF @EnvironmentName = 'PRODUCTION'
		Begin
		/* Environment name = "Production" */
			 Exec [Temp_InsertUpdateQualProParams] 
			 'LDReportServer', 
			 'S', 
			 'DataLoader', 
			 'http://Iris/ReportServer/Pages/ReportViewer.aspx?/DataLoader/', 
			 NULL, NULL, 'Data Loader SSRS reports link' 	
		End
	/* End Production Settings */
	/* Staging Settings */
	IF @EnvironmentName = 'STAGING'
		Begin
			 Exec [Temp_InsertUpdateQualProParams] 
			 'LDReportServer', 
			 'S', 
			 'DataLoader', 
			 'http://RunningRebel/ReportServer/Pages/ReportViewer.aspx?/DataLoader/', 
			 NULL, NULL, 'Data Loader SSRS reports link' 	
		End
	/* End Staging Settings*/
	/* Testing Settings */
	IF @EnvironmentName = 'TESTING'
		Begin
			 Exec [Temp_InsertUpdateQualProParams] 
			 'LDReportServer', 
			 'S', 
			 'DataLoader', 
			 'http://ironman/ReportServer/Pages/ReportViewer.aspx?/DataLoader/', 
			 NULL, NULL, 'Data Loader SSRS reports link' 	
		End
	/*End Testing Settings */