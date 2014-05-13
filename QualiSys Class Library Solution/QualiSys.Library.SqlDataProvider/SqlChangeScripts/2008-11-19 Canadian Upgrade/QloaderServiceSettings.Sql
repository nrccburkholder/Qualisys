/****************************************QLOADER SERVICE SETTINGS ***********************************************/
USE [QP_Prod]
GO
/* Created By Arman Mnatsakanyan Creation Date: 12/12/2008 9:24:52 AM */
/* PROCEDURE Temp_InsertUpdateQualProParams must exist for running the script */
Declare @EnvironmentName varchar(20)
Set @EnvironmentName = (Select strParam_Value  From QualPro_Params Where strParam_Nm = 'EnvName')

	/* Global Settings */
			Exec [Temp_InsertUpdateQualProParams] 
				'QLSSqlTimeout', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'QloaderService', --strParam_GRP
				Null, --strParam_Value
				'3600', --numParam_Value
				Null, --datParam_Value
				'SQL TimeOut setting for Qloader Service' -- Comment
	/* End Global Settings */


	/* Production Settings */
	IF @EnvironmentName = 'PRODUCTION'
	Begin
		/* Environment name = "Production" */
			/* QualisysExplorer also uses the following not application specific settings (Based on the app.config file): 
			1) 'QLoaderConnection', 
			2) ' SmtpServer'
			3) 'SQLTimeOut'
			4) 'NrcAuthConnection'
			5) 'QLDataStorePath'
			6) 'QLValidationReport'
			7) 'QLPackageOwnersEmailGroup' 
			*****************************************************************/
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'TimerInterval', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'QloaderService', --strParam_GRP
				Null, --strParam_Value
				'10000', --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'RunDTSExecutions', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QloaderService', --strParam_GRP
				'true', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'MaxConcurrentLoads', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'QloaderService', --strParam_GRP
				Null, --strParam_Value
				'2', --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'RunAddressCleaning', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QloaderService', --strParam_GRP
				'true', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'valid values are true,false.' --Please enter the description
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'MaxConcurrentCleaning', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'QloaderService', --strParam_GRP
				Null, --strParam_Value
				'2', --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'RunValidationReports', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QloaderService', --strParam_GRP
				'true', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'valid values are true,false.' --Please enter the description
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'MaxConcurrentValidations', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'QloaderService', --strParam_GRP
				Null, --strParam_Value
				'3', --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'RunApplies', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QloaderService', --strParam_GRP
				'true', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'MaxConcurrentApplies', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'QloaderService', --strParam_GRP
				Null, --strParam_Value
				'3', --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
	END
	/* End Production Settings */

	/* Staging Settings */
	IF @EnvironmentName = 'STAGING'
	BEGIN
		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'TimerInterval', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'QloaderService', --strParam_GRP
				Null, --strParam_Value
				'10000', --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description

		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'RunDTSExecutions', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QloaderService', --strParam_GRP
				'true', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'MaxConcurrentLoads', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'QloaderService', --strParam_GRP
				Null, --strParam_Value
				'2', --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'RunAddressCleaning', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QloaderService', --strParam_GRP
				'true', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'valid values are true,false.' --Please enter the description
		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'MaxConcurrentCleaning', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'QloaderService', --strParam_GRP
				Null, --strParam_Value
				'2', --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'RunValidationReports', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QloaderService', --strParam_GRP
				'true', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'valid values are true,false.' --Please enter the description
		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'MaxConcurrentValidations', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'QloaderService', --strParam_GRP
				Null, --strParam_Value
				'3', --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'RunApplies', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QloaderService', --strParam_GRP
				'true', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'MaxConcurrentApplies', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'QloaderService', --strParam_GRP
				Null, --strParam_Value
				'3', --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description

		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'QLPackageOwnersEmailGroup', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QloaderService', --strParam_GRP
				'LoadingTeamTest@nationalresearch.com', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
	END
	/* End Staging Settings */

	/* Testing Settings */
	IF @EnvironmentName = 'TESTING'
	BEGIN
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'TimerInterval', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'QloaderService', --strParam_GRP
				Null, --strParam_Value
				'10000', --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'RunDTSExecutions', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QloaderService', --strParam_GRP
				'true', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'MaxConcurrentLoads', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'QloaderService', --strParam_GRP
				Null, --strParam_Value
				'2', --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'RunAddressCleaning', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QloaderService', --strParam_GRP
				'true', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'valid values are true,false.' --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'MaxConcurrentCleaning', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'QloaderService', --strParam_GRP
				Null, --strParam_Value
				'2', --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'RunValidationReports', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QloaderService', --strParam_GRP
				'true', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'valid values are true,false.' --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'MaxConcurrentValidations', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'QloaderService', --strParam_GRP
				Null, --strParam_Value
				'3', --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'RunApplies', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QloaderService', --strParam_GRP
				'true', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'MaxConcurrentApplies', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'QloaderService', --strParam_GRP
				Null, --strParam_Value
				'3', --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'QLPackageOwnersEmailGroup', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QloaderService', --strParam_GRP
				'LoadingTeamTest@nationalresearch.com', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
	END
	/* End Testing Settings */
