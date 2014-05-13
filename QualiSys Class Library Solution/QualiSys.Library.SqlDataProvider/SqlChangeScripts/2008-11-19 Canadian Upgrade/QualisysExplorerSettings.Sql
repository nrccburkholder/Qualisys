/********************************* QUALISYSEXPLORER SETTINGS *******************************************************/
USE [QP_Prod]
GO
/* Created By Arman Mnatsakanyan Creation Date: 12/9/2008 4:12:57 PM */
/* Temp_InsertUpdateQualProParams must exist before running this script. */
Declare @EnvironmentName varchar(20)
Set @EnvironmentName = (Select strParam_Value  From QualPro_Params Where strParam_Nm = 'EnvName')

	/* User Settings (These settings must stay in configuration file)
				Name: 'QEWindowLocation', Value: '0, 0
				Name: 'QEWindowState', Value: 'Maximized
				Name: 'QEWindowSize', Value: '500, 500
				Name: 'QESplitterDistance', Value: '220
		End User Settings */

	/* Application My.Settings  (Looks like it's not used anywhere)  
			Exec [Temp_InsertUpdateQualProParams] 
				'QEQualiSysExplorer_AddressCleaning_Cleaner', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QualisysExplorer', --strParam_GRP
				'http://wonderwoman/addresscleaning/Cleaner.asmx', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description */ 
	/* End Application My.Settings */



	/* Global Settings */
			Exec [Temp_InsertUpdateQualProParams] 
				'QELogEvents', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QualisysExplorer', --strParam_GRP
				'true', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
			/* Comment Connection Strings, SMTPServer, SQLTimeOut
			Exec [Temp_InsertUpdateQualProParams] 
				'SqlTimeout', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'QualisysExplorer', --strParam_GRP
				Null, --strParam_Value
				'600', --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
			End Comment Connection Strings, SMTPServer, SQLTimeOut */
	/* End Global Settings */


	/* Production Settings */
	IF @EnvironmentName = 'PRODUCTION'
	Begin
		/* Environment name = "Production USA" */
			/* QualisysExplorer also uses the following not application specific settings:
			1) 'QualisysConnection', 
			2) ' SmtpServer'
			3) 'SQLTimeOut'
			*****************************************************************/
		/* Environment name = "Production USA" */
			Exec [Temp_InsertUpdateQualProParams] 
				'QEAddressCleaningUrl', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QualisysExplorer', --strParam_GRP
				'http://mars/AddressCleaning/Cleaner.asmx', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
	End
		/************************** Environment name = "Production CA" *******************/
			/* Comment Connection Strings, SMTPServer, SQLTimeOut
			Exec [Temp_InsertUpdateQualProParams] 
				'QualisysConnection', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QualisysExplorer', --strParam_GRP
				'server=NRCC02;database=QP_Prod;user=webpref;password=surveypref;', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
			End Comment Connection Strings, SMTPServer, SQLTimeOut */
		/* Environment name = "Production CA" ************************************************
			Exec [Temp_InsertUpdateQualProParams] 
				'QEAddressCleaningUrl', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QualisysExplorer', --strParam_GRP
				'http://NRCC02:62370/AddressCleaning/Cleaner.asmx', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description*/
		/* Environment name = "Production CA" *************************************************/
			/* Comment Connection Strings, SMTPServer, SQLTimeOut
			Exec [Temp_InsertUpdateQualProParams] 
				'SmtpServer', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QualisysExplorer', --strParam_GRP
				'NRCC02', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
			End Comment Connection Strings, SMTPServer, SQLTimeOut */
	/* End Production Settings */

	/* Staging Settings */
	IF @EnvironmentName = 'STAGING'
	Begin
		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'QEAddressCleaningUrl', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QualisysExplorer', --strParam_GRP
				'http://cyclone/AddressCleaning/Cleaner.asmx', --strParam_Value
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
				'QEAddressCleaningUrl', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QualisysExplorer', --strParam_GRP
				'http://wonderwoman/AddressCleaning/Cleaner.asmx', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
	End
	/* End Testing Settings */
