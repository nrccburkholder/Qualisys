/**************************** QUALISYS DATA ENTRY SETTINGS *************************************/
USE [QP_Prod]
GO
/* Created By Arman Mnatsakanyan */
/* Temp_InsertUpdateQualProParams  SP must exist to run this script.  */
Declare @EnvironmentName varchar(20)
Set @EnvironmentName = (Select strParam_Value  From QualPro_Params Where strParam_Nm = 'EnvName')

/* ------------------------------------ Settings that are used but are not application specific: ------------------------------------------------------
	QualisysConnection
	NrcAuthConnection
	SmtpServer
	SqlTimeout
---------------------------------------------------------------------------------------------------------------------------------------------------- */

	/* Production Settings */
	IF @EnvironmentName = 'PRODUCTION'
	BEGIN
	/* Environment name = "Production USA" */
			Exec [Temp_InsertUpdateQualProParams] 
				'QDELogging', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'QualisysDataEntry', --strParam_GRP
				Null, --strParam_Value
				'1', --numParam_Value
				Null, --datParam_Value
				'Sets whether or not user actions are logged in QDELog table' --Please enter the description
	END
	/* End Production Settings */
	
	/* Staging Settings */
	IF @EnvironmentName = 'STAGING'
	BEGIN
	/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'QDELogging', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'QualisysDataEntry', --strParam_GRP
				Null, --strParam_Value
				'1', --numParam_Value
				Null, --datParam_Value
				'Sets whether or not user actions are logged in QDELog table' --Please enter the description
	END
	/* End Staging Settings */

	/* Testing Settings */
	IF @EnvironmentName = 'TESTING'
	BEGIN
	/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'QDELogging', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'QualisysDataEntry', --strParam_GRP
				Null, --strParam_Value
				'1', --numParam_Value
				Null, --datParam_Value
				'Sets whether or not user actions are logged in QDELog table' --Please enter the description
	END
	/* End Testing Settings */
