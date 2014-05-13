/********************************************* ADDRESSCLEANER SETTINGS *******************************************************/
USE [QP_Prod]
/* Created By Arman Mnatsakanyan Creation Date: 12/11/2008 3:38:27 PM */
/* Paste CREATE PROCEDURE Temp_InsertUpdateQualProParams ... here at the beginning of the installation */
Declare @EnvironmentName varchar(20)
Set @EnvironmentName = (Select strParam_Value  From QualPro_Params Where strParam_Nm = 'EnvName')

/* Environment Independent Settings */
 Exec [Temp_InsertUpdateQualProParams] 'AddressCleanerSqlTimeOut', 'N', 'AddressCleaner', '', '3600', NULL, 
 'SQL TimeOut value for AddressCleaner' 
 /*Settings used in CNames.vb*/
Exec [Temp_InsertUpdateQualProParams] 'ACEKeyFileName', 'S', 'AddressCleaner', 'Tnlib.key', NULL, NULL, 
	'This value is used in CNames.vb in Qualisys.Qloader.AddressCleaning project' 
Exec [Temp_InsertUpdateQualProParams] 'ACE_MAILER_CUST_CO', 'S', 'AddressCleaner', 'National Research Corporation', NULL, NULL, 
	'This value is used in CNames.vb in Qualisys.Qloader.AddressCleaning project'  
Exec [Temp_InsertUpdateQualProParams] 'ACE_MAILER_CUST_ADDRESS', 'S', 'AddressCleaner','1245 Q Street', NULL, NULL, 
	'This value is used in CNames.vb in Qualisys.Qloader.AddressCleaning project'  
Exec [Temp_InsertUpdateQualProParams] 'ACE_MAILER_CUST_CITY', 'S', 'AddressCleaner', 'Lincoln', NULL, NULL, 
	'This value is used in CNames.vb in Qualisys.Qloader.AddressCleaning project'  
Exec [Temp_InsertUpdateQualProParams] 'ACE_MAILER_CUST_STATE', 'S', 'AddressCleaner','NE', NULL, NULL, 
	'This value is used in CNames.vb in Qualisys.Qloader.AddressCleaning project'  
Exec [Temp_InsertUpdateQualProParams] 'ACE_MAILER_CUST_ZIP', 'S', 'AddressCleaner','68508', NULL, NULL, 
	'This value is used in CNames.vb in Qualisys.Qloader.AddressCleaning project'  
Exec [Temp_InsertUpdateQualProParams] 'ACE_MAILER_CUST_ZIP4', 'S', 'AddressCleaner','1430', NULL, NULL, 
	'This value is used in CNames.vb in Qualisys.Qloader.AddressCleaning project'  
	Exec [Temp_InsertUpdateQualProParams] 'TN_DCT_PARSING', 'S', 'AddressCleaner', 'parsing.dct', NULL, NULL, 
	'This value is used in CNames.vb in Qualisys.Qloader.AddressCleaning project'  
Exec [Temp_InsertUpdateQualProParams] 'TN_DCT_CAP1', 'S', 'AddressCleaner', 'pwcap.dct', NULL, NULL, 
	'This value is used in CNames.vb in Qualisys.Qloader.AddressCleaning project'  
Exec [Temp_InsertUpdateQualProParams] 'TN_GCF_FIRM', 'S', 'AddressCleaner',  'fprules.gcf', NULL, NULL, 
	'This value is used in CNames.vb in Qualisys.Qloader.AddressCleaning project'  
Exec [Temp_InsertUpdateQualProParams] 'TN_GCF_MLI', 'S', 'AddressCleaner', 'mlrules.gcf', NULL, NULL, 
	'This value is used in CNames.vb in Qualisys.Qloader.AddressCleaning project'  
Exec [Temp_InsertUpdateQualProParams] 'TN_GCF_FINAN', 'S', 'AddressCleaner', 'finan.gcf', NULL, NULL, 
	'This value is used in CNames.vb in Qualisys.Qloader.AddressCleaning project'  
Exec [Temp_InsertUpdateQualProParams] 'TN_GREETING_NAME_PREFIX', 'S', 'AddressCleaner', 'Dear', NULL, NULL, 
	'This value is used in CNames.vb in Qualisys.Qloader.AddressCleaning project'  
Exec [Temp_InsertUpdateQualProParams] 'TN_GREETING_NAME_CONNECTOR', 'S', 'AddressCleaner', '&', NULL, NULL, 
	'This value is used in CNames.vb in Qualisys.Qloader.AddressCleaning project'  
Exec [Temp_InsertUpdateQualProParams] 'TN_GREETING_NAME_SUFFIX', 'S', 'AddressCleaner', ':', NULL, NULL, 
	'This value is used in CNames.vb in Qualisys.Qloader.AddressCleaning project'  
Exec [Temp_InsertUpdateQualProParams] 'TN_GREETING_NAME_MULTI_MALE_SALUTE', 'S', 'AddressCleaner', 'Sirs', NULL, NULL, 
	'This value is used in CNames.vb in Qualisys.Qloader.AddressCleaning project'  
Exec [Temp_InsertUpdateQualProParams] 'TN_GREETING_NAME_MULTI_FEMALE_SALUTE', 'S', 'AddressCleaner', 'Madams', NULL, NULL, 
	'This value is used in CNames.vb in Qualisys.Qloader.AddressCleaning project'  
/*End Settings used in CNames.vb*/
/*Settings used in CAddresses.vb*/
Exec [Temp_InsertUpdateQualProParams] 'CACE_DCT_ADDRLN', 'S', 'AddressCleaner', 'Addrlnca.dct', NULL, NULL, 
	'This value is used in CAddresses.vb in Qualisys.Qloader.AddressCleaning project'  
Exec [Temp_InsertUpdateQualProParams] 'CACE_DCT_LASTLN', 'S', 'AddressCleaner', 'Lastlnca.dct', NULL, NULL, 
	'This value is used in CAddresses.vb in Qualisys.Qloader.AddressCleaning project' 
Exec [Temp_InsertUpdateQualProParams] 'CACE_DCT_CAP', 'S', 'AddressCleaner', 'Pwcasca.dct', NULL, NULL, 
	'This value is used in CAddresses.vb in Qualisys.Qloader.AddressCleaning project' 
Exec [Temp_InsertUpdateQualProParams] 'CACE_KEYFILE', 'S', 'AddressCleaner', 'CAcelib.key', NULL, NULL, 
	'This value is used in CAddresses.vb in Qualisys.Qloader.AddressCleaning project' 
Exec [Temp_InsertUpdateQualProParams] 'CACE_DIR_CITY', 'S', 'AddressCleaner', 'cancity.dir', NULL, NULL, 
	'This value is used in CAddresses.vb in Qualisys.Qloader.AddressCleaning project' 
Exec [Temp_InsertUpdateQualProParams] 'CACE_DIR_FSA', 'S', 'AddressCleaner', 'canfsa.dir', NULL, NULL, 
	'This value is used in CAddresses.vb in Qualisys.Qloader.AddressCleaning project' 
Exec [Temp_InsertUpdateQualProParams] 'CACE_DIR_CAN', 'S', 'AddressCleaner', 'canada.dir', NULL, NULL, 
	'This value is used in CAddresses.vb in Qualisys.Qloader.AddressCleaning project' 
Exec [Temp_InsertUpdateQualProParams] 'CACE_DIR_PCI', 'S', 'AddressCleaner', 'canpci.dir', NULL, NULL, 
	'This value is used in CAddresses.vb in Qualisys.Qloader.AddressCleaning project' 
-- Set the dicionaries
Exec [Temp_InsertUpdateQualProParams] 'ACE_DCT_ADDRLN', 'S', 'AddressCleaner', 'Addrln.dct', NULL, NULL, 
	'This value is used in CAddresses.vb in Qualisys.Qloader.AddressCleaning project' 
Exec [Temp_InsertUpdateQualProParams] 'ACE_DCT_LASTLN', 'S', 'AddressCleaner', 'Lastln.dct', NULL, NULL, 
	'This value is used in CAddresses.vb in Qualisys.Qloader.AddressCleaning project' 
Exec [Temp_InsertUpdateQualProParams] 'ACE_DCT_CAP', 'S', 'AddressCleaner', 'Pwcas.dct', NULL, NULL, 
	'This value is used in CAddresses.vb in Qualisys.Qloader.AddressCleaning project' 
Exec [Temp_InsertUpdateQualProParams] 'ACE_DCT_FIRMLN', 'S', 'AddressCleaner', 'firmln.dct', NULL, NULL, 
	'This value is used in CAddresses.vb in Qualisys.Qloader.AddressCleaning project' 

        --Set the directories
Exec [Temp_InsertUpdateQualProParams] 'ACE_DIR_CITY', 'S', 'AddressCleaner', 'city10.dir', NULL, NULL, 
	'This value is used in CAddresses.vb in Qualisys.Qloader.AddressCleaning project' 
Exec [Temp_InsertUpdateQualProParams] 'ACE_DIR_ZCF', 'S', 'AddressCleaner', 'zcf10.dir', NULL, NULL, 
	'This value is used in CAddresses.vb in Qualisys.Qloader.AddressCleaning project' 
Exec [Temp_InsertUpdateQualProParams] 'ACE_DIR_REVZIP4', 'S', 'AddressCleaner', 'Revzip4.dir', NULL, NULL, 
	'This value is used in CAddresses.vb in Qualisys.Qloader.AddressCleaning project' 
Exec [Temp_InsertUpdateQualProParams] 'ACE_DIR_ZIP4_1', 'S', 'AddressCleaner', 'zip4us.dir', NULL, NULL, 
	'This value is used in CAddresses.vb in Qualisys.Qloader.AddressCleaning project' 
Exec [Temp_InsertUpdateQualProParams] 'ACE_DIR_ELOT', 'S', 'AddressCleaner', 'elot.dir', NULL, NULL, 
	'This value is used in CAddresses.vb in Qualisys.Qloader.AddressCleaning project' 

        --Set zip4 SHS/Reverse Soundex, DPV, and LACSLink files
Exec [Temp_InsertUpdateQualProParams] 'ACE_DIR_ZIP4_REV_SNDX', 'S', 'AddressCleaner','zip4us.rev', NULL, NULL, 
	'This value is used in CAddresses.vb in Qualisys.Qloader.AddressCleaning project' 
Exec [Temp_InsertUpdateQualProParams] 'ACE_DIR_ZIP4_SHS', 'S', 'AddressCleaner','zip4us.shs', NULL, NULL, 
	'This value is used in CAddresses.vb in Qualisys.Qloader.AddressCleaning project' 
Exec [Temp_InsertUpdateQualProParams] 'ACE_FRM_3553', 'S', 'AddressCleaner','Ace3553.frm', NULL, NULL, 
	'This value is used in CAddresses.vb in Qualisys.Qloader.AddressCleaning project' 
/*Settings used in CAddresses.vb*/
 /* End Environment Independent Settings */
 
	/* Production Settings */
	IF @EnvironmentName = 'PRODUCTION'
		Begin
	/* Environment name = "Production" 
			Exec [Temp_InsertUpdateQualProParams] 
				'QLDataStorePath', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'AddressCleaner', --strParam_GRP
				'\\neptune\nrc4\QLoader\Prod', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
*/
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'TrueNameLibraries', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'AddressCleaner', --strParam_GRP
				'c:\pw\tnlib\', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'AceDirectories', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'AddressCleaner', --strParam_GRP
				'c:\pw\dirs\', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'AceDictionaries', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'AddressCleaner', --strParam_GRP
				'c:\pw\acelib\', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'CAceDictionaries', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'AddressCleaner', --strParam_GRP
				'c:\pw\cacelib\', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'AceDpvDirectory', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'AddressCleaner', --strParam_GRP
				'c:\pw\dpv\', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'AceLacsLinkDirectory', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'AddressCleaner', --strParam_GRP
				'c:\pw\lacslink\', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'AceRootFolder', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'AddressCleaner', --strParam_GRP
				'c:\pw\', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'BatchSize', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'AddressCleaner', --strParam_GRP
				Null, --strParam_Value
				'3000', --numParam_Value
				Null, --datParam_Value
				'Address Cleaning Batch Size - This is number of DB records to be processed at a time 
		        If set to anything less than 1000 the program will override and use 1000 ' -- the description
				
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'CACEAddressOverPostalCode', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'AddressCleaner', --strParam_GRP
				'TRUE', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'-Canadian Ace Priority on Address OVER Postal Code (TRUE or FALSE) 
		        If set to: TRUE  - then Address has priority and Postal Code may change. 
		        FALSE - then Postal Code has priority and Address may change. ' -- the description
				
			Exec [Temp_InsertUpdateQualProParams] 'AceLogDirectory', 'S', 'AddressCleaner', 'C:\pw\logs\', NULL, NULL, 'This value is used in CAddresses.vb in Qualisys.Qloader.AddressCleaning project' 
		End
	/* End Production Settings */

	/* Staging Settings */
	IF @EnvironmentName = 'STAGING'
		Begin
		/* Environment name = "Staging" 
			Exec [Temp_InsertUpdateQualProParams] 
				'QLDataStorePath', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'AddressCleaner', --strParam_GRP
				'\\Huskers\QLoader', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		*/

		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'TrueNameLibraries', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'AddressCleaner', --strParam_GRP
				'e:\pw\tnlib\', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description

		/* Environment name = "Staging" */

			Exec [Temp_InsertUpdateQualProParams] 
				'AceDirectories', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'AddressCleaner', --strParam_GRP
				'e:\pw\dirs\', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description

		/* Environment name = "Staging" */

			Exec [Temp_InsertUpdateQualProParams] 
				'AceDictionaries', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'AddressCleaner', --strParam_GRP
				'e:\pw\acelib\', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description

		/* Environment name = "Staging" */

			Exec [Temp_InsertUpdateQualProParams] 
				'CAceDictionaries', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'AddressCleaner', --strParam_GRP
				'e:\pw\cacelib\', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description

		/* Environment name = "Staging" */

			Exec [Temp_InsertUpdateQualProParams] 
				'AceDpvDirectory', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'AddressCleaner', --strParam_GRP
				'e:\pw\dpv\', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description

		/* Environment name = "Staging" */

			Exec [Temp_InsertUpdateQualProParams] 
				'AceLacsLinkDirectory', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'AddressCleaner', --strParam_GRP
				'e:\pw\lacslink\', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description

		/* Environment name = "Staging" */

			Exec [Temp_InsertUpdateQualProParams] 
				'AceRootFolder', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'AddressCleaner', --strParam_GRP
				'e:\pw\', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description

		/* Environment name = "Staging" */

			Exec [Temp_InsertUpdateQualProParams] 
				'BatchSize', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'AddressCleaner', --strParam_GRP
				Null, --strParam_Value
				'3000', --numParam_Value
				Null, --datParam_Value
				'Address Cleaning Batch Size - This is number of DB records to be processed at a time 
		        If set to anything less than 1000 the program will override and use 1000 ' -- the description

		/* Environment name = "Staging" */

			Exec [Temp_InsertUpdateQualProParams] 
				'CACEAddressOverPostalCode', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'AddressCleaner', --strParam_GRP
				'TRUE', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'-Canadian Ace Priority on Address OVER Postal Code (TRUE or FALSE) 
		        If set to: TRUE  - then Address has priority and Postal Code may change. 
		        FALSE - then Postal Code has priority and Address may change. ' -- the description

		/* Environment name = "Staging" */			
			Exec [Temp_InsertUpdateQualProParams] 
				'AceLogDirectory', 
				'S', 
				'AddressCleaner', 
				'e:\pw\logs\', NULL, NULL, 
				'This value is used in CAddresses.vb in Qualisys.Qloader.AddressCleaning project' 
		End
	/* End Staging Settings */

	/* Testing Settings */
	IF @EnvironmentName = 'TESTING'
		Begin
		/* Environment name = "Testing" 
			Exec [Temp_InsertUpdateQualProParams] 
				'QLDataStorePath', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'AddressCleaner', --strParam_GRP
				'\\Superman\QLoader', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
*/	
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'TrueNameLibraries', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'AddressCleaner', --strParam_GRP
				'e:\pw\tnlib\', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'AceDirectories', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'AddressCleaner', --strParam_GRP
				'e:\pw\dirs\', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'AceDictionaries', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'AddressCleaner', --strParam_GRP
				'e:\pw\acelib\', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'CAceDictionaries', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'AddressCleaner', --strParam_GRP
				'e:\pw\cacelib\', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'AceDpvDirectory', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'AddressCleaner', --strParam_GRP
				'e:\pw\dpv\', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'AceLacsLinkDirectory', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'AddressCleaner', --strParam_GRP
				'e:\pw\lacslink\', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'AceRootFolder', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'AddressCleaner', --strParam_GRP
				'e:\pw\', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'BatchSize', --strParam_nm
				'N', --strParam_type can be "N","S" or "D"
				'AddressCleaner', --strParam_GRP
				Null, --strParam_Value
				'3000', --numParam_Value
				Null, --datParam_Value
				'Address Cleaning Batch Size - This is number of DB records to be processed at a time 
		        If set to anything less than 1000 the program will override and use 1000 ' -- the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'CACEAddressOverPostalCode', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'AddressCleaner', --strParam_GRP
				'TRUE', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'-Canadian Ace Priority on Address OVER Postal Code (TRUE or FALSE) 
		        If set to: TRUE  - then Address has priority and Postal Code may change. 
		        FALSE - then Postal Code has priority and Address may change. ' -- the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
			'AceLogDirectory', 
			'S', 
			'AddressCleaner', 
			'e:\pw\logs\', NULL, NULL, 
			'This value is used in CAddresses.vb in Qualisys.Qloader.AddressCleaning project' 
		End
	/* End Testing Settings */
