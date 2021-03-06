/****** This script assumes that EnvName parameter already exists in QualPro_Params table ******/
USE [QP_Prod]
GO

--********************************************************************************************
/*Environment Independent Settings*/
	Exec [Temp_InsertUpdateQualProParams] 
	'NumberOfDaysPriorToSampleDataFileExpectedToArrive', --strParam_nm
	'N', --strParam_type can be "N","S" or "D"
	'QualisysLibrary', --strParam_GRP
	Null, --strParam_Value
	2, --numParam_Value
	NULL, --datParam_Value
	'Number Of Days Prior To Sample DataFile Expected To Arrive'

	Exec [Temp_InsertUpdateQualProParams] 
	'CanceledSampleDefaultDate','D','QualisysLibrary',
	Null, --strParam_Value
	Null, --numParam_Value
	'1/1/1900', --datParam_Value
	Null
	
	Exec [Temp_InsertUpdateQualProParams] 
	'SwitchToPropSamplingDate','D','QualisysLibrary',
	Null, --strParam_Value
	Null, --numParam_Value
	'1/1/2057', --datParam_Value
	Null

/*End Environment Independent Settings*/
--*********************************************************************************************

