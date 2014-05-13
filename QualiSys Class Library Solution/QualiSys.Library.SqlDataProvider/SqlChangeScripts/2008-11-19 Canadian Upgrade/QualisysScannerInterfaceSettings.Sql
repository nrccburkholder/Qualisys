USE [QP_Prod]
GO

/* Temp_InsertUpdateQualProParams must exist prior running this script. */
Declare @EnvironmentName varchar(20)
Set @EnvironmentName = (Select strParam_Value  From QualPro_Params Where strParam_Nm = 'EnvName')

	/* Environment Independent Settings */
			Exec [Temp_InsertUpdateQualProParams] 
				'QSIMaxConcurrentTransfers',--strParam_nm
				'N',--strParam_type can be "N","S" or "D"
				'ScannerInterface', --strParam_GRP
				Null,
				5, --numParam_Value
				Null, --datParam_Value
				'Specifies how many files can be transferred at the same time' -- comment
				
			Exec [Temp_InsertUpdateQualProParams] 
				'QSIServicePauseInterval',--strParam_nm
				'N',--strParam_type can be "N","S" or "D"
				'ScannerInterface', --strParam_GRP
				Null,
				10000, --numParam_Value
				Null, --datParam_Value
				'Specifies how long the Scanner Interface Service pauses waiting for the next available thread in milliseconds' -- comment
				
			Exec [Temp_InsertUpdateQualProParams] 
				'QSIServiceInterval',--strParam_nm
				'N',--strParam_type can be "N","S" or "D"
				'ScannerInterface', --strParam_GRP
				Null,
				10000, --numParam_Value
				Null, --datParam_Value
				'Specifies how often the Scanner Interface Service checks for new files in milliseconds' -- comment
	/* End Environment Independent Settings */


	/* Production Settings */
	IF @EnvironmentName = 'PRODUCTION'
		BEGIN
			Exec [Temp_InsertUpdateQualProParams] 
				'QSITransferArchiveFolder',--strParam_nm
				'S',--strParam_type can be "N","S" or "D"
				'ScannerInterface', --strParam_GRP
				'\\Argus\Production\TransferResults\ArchivedFiles',
				Null, --numParam_Value
				Null, --datParam_Value
				'Specifies the location to archive files after they are transferred' -- comment

			Exec [Temp_InsertUpdateQualProParams] 
				'QSITransferTempFolder',--strParam_nm
				'S',--strParam_type can be "N","S" or "D"
				'ScannerInterface', --strParam_GRP
				'\\Argus\Production\TransferResults\InProcessFiles',
				Null, --numParam_Value
				Null, --datParam_Value
				'Specifies the base location for temp files used while transferring a file' -- comment

	/* End Production Settings */
		END
	/* Staging Settings */
	IF @EnvironmentName = 'STAGING'
		BEGIN
			Exec [Temp_InsertUpdateQualProParams] 
				'QSITransferArchiveFolder',--strParam_nm
				'S',--strParam_type can be "N","S" or "D"
				'ScannerInterface', --strParam_GRP
				'\\Huskers\Production\TransferResults\ArchivedFiles',--strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'Specifies the location to archive files after they are transferred' -- comment

			Exec [Temp_InsertUpdateQualProParams] 
				'QSITransferTempFolder',--strParam_nm
				'S',--strParam_type can be "N","S" or "D"
				'ScannerInterface', --strParam_GRP
				'\\Huskers\Production\TransferResults\InProcessFiles',--strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'Specifies the base location for temp files used while transferring a file' --comment		
		/* End Staging Settings */
		END
	/* Testing Settings */
	IF @EnvironmentName = 'TESTING'
		BEGIN
			Exec [Temp_InsertUpdateQualProParams] 
				'QSITransferArchiveFolder',--strParam_nm
				'S',--strParam_type can be "N","S" or "D"
				'ScannerInterface', --strParam_GRP
				'\\Superman\Production\TransferResults\ArchivedFiles',--strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'Specifies the location to archive files after they are transferred' -- comment

			Exec [Temp_InsertUpdateQualProParams] 
				'QSITransferTempFolder',--strParam_nm
				'S',--strParam_type can be "N","S" or "D"
				'ScannerInterface', --strParam_GRP
				'\\Superman\Production\TransferResults\InProcessFiles',--strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'Specifies the base location for temp files used while transferring a file' -- comment
		END
	/* End Testing Settings */
