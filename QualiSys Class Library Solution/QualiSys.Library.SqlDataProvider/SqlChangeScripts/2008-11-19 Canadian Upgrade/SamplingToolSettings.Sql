
USE [QP_Prod]
GO
/* Created By Arman Mnatsakanyan Creation Date: 12/10/2008 3:48:43 PM */
/*  CREATE PROCEDURE Temp_InsertUpdateQualProParams ... here at the beginning of the installation */
Declare @EnvironmentName varchar(20)
Set @EnvironmentName = (Select strParam_Value  From QualPro_Params Where strParam_Nm = 'EnvName')

	--These are not application specific settings. DO NOT uncomment.
				-- 'QualisysInstallPath' = 'c:\Program Files\Qualisys'
				-- 'NotificationConnection' = 'Data Source=Jayhawk;UID=qpsa;PWD=qpsa;Initial Catalog=NotificationService;'
				-- 'QualisysConnection' = 'server=Tiger;database=QP_Prod;user=qpsa;password=qpsa;'
				-- 'NrcAuthConnection' = 'Data Source=Jayhawk;UID=qpsa;PWD=qpsa;Initial Catalog=NRCAuth;'
				-- 'SmtpServer'= 'Huskers'
				-- 'SqlTimeout' = 600
	/* Global Settings */
			Exec [Temp_InsertUpdateQualProParams] 
				'SPLogEvents', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'SamplingTool', --strParam_GRP
				'true', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'Currently unused. May be used to turn logging on\off.' --Please enter the description
	/* End Global Settings */

	/* Production Settings */
	IF @EnvironmentName = 'PRODUCTION'
	BEGIN
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'SPWPath', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'SamplingTool', --strParam_GRP
				'http://iris/reportserver?/NRC+Picker+Client+Management/Sample+Plan+Worksheet', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'Sample Plan Wroksheet report url.' --Please enter the description
	/* End Production Settings */
	END
	/* Staging Settings */
	IF @EnvironmentName = 'STAGING'
	BEGIN
		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'SPWPath', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'SamplingTool', --strParam_GRP
				'http://runningrebel/reportserver?/NRC+Picker+Client+Management/Sample+Plan+Worksheet', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'Sample Plan Wroksheet report url.' --Please enter the description
	/* End Staging Settings */
	END
	/* Testing Settings */
	IF @EnvironmentName = 'TESTING'
	BEGIN
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'SPWPath', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'SamplingTool', --strParam_GRP
				'http://ironman/reportserver?/NRC+Picker+Client+Management/Sample+Plan+Worksheet', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'Sample Plan Wroksheet report url.' --Please enter the description
	END
	/* End Testing Settings */
