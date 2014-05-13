
USE [QP_Prod]
GO
/* Created By Arman Mnatsakanyan 
-- This are the "Global Settings for USA" means they are system wide (not application specific)
*/
/* Paste CREATE PROCEDURE Temp_InsertUpdateQualProParams ... here at the beginning of the installation */
Declare @EnvironmentName varchar(20)
Set @EnvironmentName = (Select strParam_Value  From QualPro_Params Where strParam_Nm = 'EnvName')

	/* Environment Independent Settings */
			Exec [Temp_InsertUpdateQualProParams] 
				'QualisysInstallPath', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'SamplingTool', --strParam_GRP
				'c:\Program Files\Qualisys', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'The path where Qualisys is installed' --Please enter the description
	/* End Environment Independent Settings */

	/*  REGISTRY SETTINGS
	The following settings are set in Registry
				'SqlTimeout'  = 600
				'SmtpServer' = smtp2.nationalresearch.com
	End Comment Registry Strings  */

	/* Production Settings */
	IF @EnvironmentName = 'PRODUCTION'
	Begin
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'NotificationConnection', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'ConnectionStrings', --strParam_GRP
				'Data Source=Mercury;UID=qpsa;PWD=qpsa;Initial Catalog=NotificationService;', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'Specifies the connection string for the NotificationService database' --Please enter the description
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'QualisysConnection', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'ConnectionStrings', --strParam_GRP
				'server=NRC10;database=QP_Prod;user=qpsa;password=qpsa;', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'Specifies the connection string for the QP_Prod database' --Please enter the description
		/* Environment name = "Production" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'NrcAuthConnection', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'ConnectionStrings', --strParam_GRP
				'Data Source=Mercury;UID=qpsa;PWD=qpsa;Initial Catalog=NRCAuth;', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'Specifies the connection string for the NRCAuth database' -- the description
		/* Environment name = "Production" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'QLoaderConnection', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'ConnectionStrings', --strParam_GRP
				'Data Source=Mars;UID=qpsa;PWD=qpsa;Initial Catalog=QP_Load', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'Specifies the connection string for the QP_Load database' --Please enter the description
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'DataMartConnection', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'ConnectionStrings', --strParam_GRP
				'Data Source=Medusa; Initial Catalog=QP_Comments; uid=qpsa; pwd=qpsa; Application Name=My Solutions', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'Specifies the connection string for the QP_Comments database' --Please enter the description
		 Exec [Temp_InsertUpdateQualProParams] 'ScanConnection', 'S', 'ConnectionStrings', 'Data Source=NRC10;UID=qpsa;PWD=qpsa;Initial Catalog=QP_Scan;', NULL, NULL, 'Specifies the connection string for the QP_Scan database' 
		 Exec [Temp_InsertUpdateQualProParams] 'QueueConnection', 'S', 'ConnectionStrings', 'Data Source=NRC10;UID=qpsa;PWD=qpsa;Initial Catalog=QP_Queue;', NULL, NULL, 'Specifies the connection string for the QP_Queue database' 
		 Exec [Temp_InsertUpdateQualProParams] 'WorkflowConnection', 'S', 'ConnectionStrings', 'Data Source=NRC10;UID=qpsa;PWD=qpsa;Initial Catalog=Workflow;', NULL, NULL, 'Specifies the connection string for the Workflow database' 
		 Exec [Temp_InsertUpdateQualProParams] 'NormsConnection', 'S', 'ConnectionStrings', 'Data Source=Medusa; Initial Catalog=QP_Norms; uid=qpsa; pwd=qpsa;', NULL, NULL, 'Specifies the connection string for the  QP_Norms database' 
		 		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'NrcPickerUrl', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'URLs', --strParam_GRP
				'http://www.nrcpicker.com/', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'URL to nrcpicker web site' --Please enter the description
		/* Environment name = "Production" */

 	/* End Production Settings */
	END

	/* Staging Settings */
	IF @EnvironmentName = 'STAGING'
	BEGIN
		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'NotificationConnection', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'ConnectionStrings', --strParam_GRP
				'Data Source=Jayhawk,5678;UID=qpsa;PWD=qpsa;Initial Catalog=NotificationService;', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'Specifies the connection string for the NotificationService database' --Please enter the description
		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'QualisysConnection', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'ConnectionStrings', --strParam_GRP
				'server=Tiger,5678;database=QP_Prod;user=qpsa;password=qpsa;', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'Specifies the connection string for the QP_Prod database' --Please enter the description
		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'NrcAuthConnection', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'ConnectionStrings', --strParam_GRP
				'Data Source=Jayhawk,5678;UID=qpsa;PWD=qpsa;Initial Catalog=NRCAuth;', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'Specifies the connection string for the NRCAuth database' --Please enter the description
		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'QLoaderConnection', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'ConnectionStrings', --strParam_GRP
				'Data Source=Cyclone,5678;UID=qpsa;PWD=qpsa;Initial Catalog=QP_Load', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'Specifies the connection string for the QP_Load database'  --Please enter the description
		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'DataMartConnection', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'ConnectionStrings', --strParam_GRP
				'Data Source=Longhorn,5678; Initial Catalog=QP_Comments; uid=qpsa; pwd=qpsa; ', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'Specifies the connection string for the QP_Comments database' --Please enter the description
		 Exec [Temp_InsertUpdateQualProParams] 'ScanConnection', 'S', 'ConnectionStrings', 'Data Source=Tiger,5678;UID=qpsa;PWD=qpsa;Initial Catalog=QP_Scan;', NULL, NULL, 'Specifies the connection string for the QP_Scan database' 
		 Exec [Temp_InsertUpdateQualProParams] 'QueueConnection', 'S', 'ConnectionStrings', 'Data Source=Tiger,5678;UID=qpsa;PWD=qpsa;Initial Catalog=QP_Queue;', NULL, NULL, 'Specifies the connection string for the QP_Queue database' 
		 Exec [Temp_InsertUpdateQualProParams] 'WorkflowConnection', 'S', 'ConnectionStrings', 'Data Source=Tiger,5678;UID=qpsa;PWD=qpsa;Initial Catalog=Workflow;', NULL, NULL, 'Specifies the connection string for the Workflow database' 
		 Exec [Temp_InsertUpdateQualProParams] 'NormsConnection', 'S', 'ConnectionStrings', 'Data Source=Longhorn,5678; Initial Catalog=QP_Norms; uid=qpsa; pwd=qpsa;', NULL, NULL, 'Specifies the connection string for the  QP_Norms database' 
		 		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'NrcPickerUrl', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'URLs', --strParam_GRP
				'http://stage.nrcpicker.com/', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'URL to nrcpicker web site' --Please enter the description
		/* Environment name = "Staging" */
	/* End Staging Settings */
	END
	
	/* Testing Settings */
	IF @EnvironmentName = 'TESTING'
	BEGIN
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'NotificationConnection', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'ConnectionStrings', --strParam_GRP
				'Data Source=Batman,5678;UID=qpsa;PWD=qpsa;Initial Catalog=NotificationService;', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'Specifies the connection string for the NotificationService database' --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'QualisysConnection', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'ConnectionStrings', --strParam_GRP
				'server=Spiderman,5678;database=QP_Prod;user=qpsa;password=qpsa;', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'Specifies the connection string for the QP_Prod database' --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'NrcAuthConnection', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'ConnectionStrings', --strParam_GRP
				'Data Source=Batman,5678;UID=qpsa;PWD=qpsa;Initial Catalog=NRCAuth;', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'Specifies the connection string for the NRCAuth database' --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'QLoaderConnection', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'ConnectionStrings', --strParam_GRP
				'Data Source=WonderWoman,5678;UID=qpsa;PWD=qpsa;Initial Catalog=QP_Load', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'Specifies the connection string for the QP_Load database' --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'DataMartConnection', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'ConnectionStrings', --strParam_GRP
				'Data Source=Hulk,5678; Initial Catalog=QP_Comments; uid=qpsa; pwd=qpsa;', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'Specifies the connection string for the QP_Comments database' --Please enter the description

		 Exec [Temp_InsertUpdateQualProParams] 'ScanConnection', 'S', 'ConnectionStrings', 'Data Source=Spiderman,5678;UID=qpsa;PWD=qpsa;Initial Catalog=QP_Scan;', NULL, NULL, 'Specifies the connection string for the QP_Scan database' 
		 Exec [Temp_InsertUpdateQualProParams] 'QueueConnection', 'S', 'ConnectionStrings', 'Data Source=Spiderman,5678;UID=qpsa;PWD=qpsa;Initial Catalog=QP_Queue;', NULL, NULL, 'Specifies the connection string for the QP_Queue database' 
		 Exec [Temp_InsertUpdateQualProParams] 'WorkflowConnection', 'S', 'ConnectionStrings', 'Data Source=Spiderman,5678;UID=qpsa;PWD=qpsa;Initial Catalog=Workflow;', NULL, NULL, 'Specifies the connection string for the Workflow database' 
		 Exec [Temp_InsertUpdateQualProParams] 'NormsConnection', 'S', 'ConnectionStrings', 'Data Source=Hulk,5678; Initial Catalog=QP_Norms; uid=qpsa; pwd=qpsa;', NULL, NULL, 'Specifies the connection string for the  QP_Norms database' 
		 		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'NrcPickerUrl', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'URLs', --strParam_GRP
				'http://test.nrcpicker.com/', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				'URL to nrcpicker web site' --Please enter the description
		/* Environment name = "Testing" */	
	/* End Testing Settings */
	END
