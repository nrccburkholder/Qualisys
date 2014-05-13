
USE [QP_Prod]
GO

/* Paste CREATE PROCEDURE Temp_InsertUpdateQualProParams ... here at the beginning of the installation */
Declare @EnvironmentName varchar(20)
Set @EnvironmentName = (Select strParam_Value  From QualPro_Params Where strParam_Nm = 'EnvName')

	/* Global Settings */
			Exec [Temp_InsertUpdateQualProParams] 
				'CMLogEvents', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'ConfigurationManager', --strParam_GRP
				'true', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
	/* End Global Settings */


	/* Production Settings */
	IF @EnvironmentName = 'PRODUCTION'
	Begin
			Exec [Temp_InsertUpdateQualProParams] 
				'CMRecalcHistoryReport', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'ConfigurationManager', --strParam_GRP
				'http://iris/reportserver?/NRC+Picker+Client+Management/Calculation+History', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
	/* End Production Settings */
	End

	/* Staging Settings */
	IF @EnvironmentName = 'STAGING'
	Begin
			Exec [Temp_InsertUpdateQualProParams] 
				'CMRecalcHistoryReport', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'ConfigurationManager', --strParam_GRP
				'http://runningrebel/reportserver?/NRC+Picker+Client+Management/Calculation+History', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description

	/* End Staging Settings */
	End

	/* Testing Settings */
	IF @EnvironmentName = 'TESTING'
	Begin
			Exec [Temp_InsertUpdateQualProParams] 
				'CMRecalcHistoryReport', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'ConfigurationManager', --strParam_GRP
				'http://ironman/reportserver?/NRC+Picker+Client+Management/Calculation+History', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
	/* End Testing Settings */
	End
