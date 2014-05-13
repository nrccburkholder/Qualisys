/* ******************** QLOADER SETTINGS *******************************************************************/
USE [QP_Prod]
GO
/* Created By Arman Mnatsakanyan Creation Date: 12/9/2008 5:00:01 PM */
/* Temp_InsertUpdateQualProParams  SP must exist to run this script.  */
Declare @EnvironmentName varchar(20)
Set @EnvironmentName = (Select strParam_Value  From QualPro_Params Where strParam_Nm = 'EnvName')

	/* Global Settings */
			Exec [Temp_InsertUpdateQualProParams] 
				'QLLogEvents', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QLoader', --strParam_GRP
				'true', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
	/* End Global Settings */


	/* Production Settings */
	IF @EnvironmentName = 'PRODUCTION'
	Begin
		/* Environment name = "Production" */
			/* ------------------------------------ These settings are used but are not application specific --------------------------------------------
				'QualisysConnection', 	'Data Source=NRC10;UID=qpsa;PWD=qpsa;Initial Catalog=QP_Prod', --strParam_Value
				'QLoaderConnection', 	'Data Source=Mars;UID=qpsa;PWD=qpsa;Initial Catalog=QP_Load', --strParam_Value
				'NrcAuthConnection', 	'Data Source=Mercury;UID=qpsa;PWD=qpsa;Initial Catalog=NRCAuth;', --strParam_Value
				'SmtpServer', 		'smtp2.nationalresearch.com', --strParam_Value
				'SqlTimeout', 		'600'
			---------------------------------------------------------------------------------------------------------------------------------------------------------- */
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'QLDataStorePath', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QLoader', --strParam_GRP
				'\\Neptune\NRC4\QLoader\Prod', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'QLDTSServiceMachine', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QLoader', --strParam_GRP
				'Mars', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'QLDTSServiceName', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QLoader', --strParam_GRP
				'QLoader Service', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'QLReportServer', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QLoader', --strParam_GRP
				'http://iris/ReportServer?/DataLoadingReports/', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'QLValidationReport', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QLoader', --strParam_GRP
				'ValidationReports', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'QLPackageReport', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QLoader', --strParam_GRP
				'PackageReport', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'QLPackageOwnersEmailGroup', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QLoader', --strParam_GRP
				'LoadingTeamTest@nationalresearch.com', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
	/* 'QLoader' and 'Approval Mode' settings were origianlly in QualPro_Params table. They never went to app.config  */
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams]
				'QLoader', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QLoader', --strParam_GRP
				'Mars', --strParam_Value
				'0', --numParam_Value
				'10-12-2006 09:21:14.013', --datParam_Value
				'strParam_Value: Server name for QLoader' --comments
		/* Environment name = "Production" */
			 Exec [Temp_InsertUpdateQualProParams] 
				 'Approval Mode', --strParam_nm
				 'N', --strParam_type can be "N","S" or "D"
				 'QLoader', --strParam_GRP
				 NULL, --strParam_Value
				 '1', --numParam_Value
				 NULL, --datParam_Value
				 'If 1, loading and approving can be done by the same person. If 2 they have to be separate people.' --comments
	END
	/* End Production Settings */

	/* Staging Settings */
	IF @EnvironmentName = 'STAGING'
	Begin
		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'QLDataStorePath', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QLoader', --strParam_GRP
				'\\Huskers\QLoader', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'QLDTSServiceMachine', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QLoader', --strParam_GRP
				'Cyclone', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'QLDTSServiceName', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QLoader', --strParam_GRP
				'QLoader Service', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'QLReportServer', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QLoader', --strParam_GRP
				'http://runningrebel/ReportServer?/DataLoadingReports/', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'QLValidationReport', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QLoader', --strParam_GRP
				'ValidationReports', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'QLPackageReport', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QLoader', --strParam_GRP
				'PackageReport', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams] 
				'QLPackageOwnersEmailGroup', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QLoader', --strParam_GRP
				'LoadingTeamTest@nationalresearch.com', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Staging" */
			Exec [Temp_InsertUpdateQualProParams]
				'QLoader', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QLoader', --strParam_GRP
				'Cyclone', --strParam_Value
				'0', --numParam_Value
				'10-12-2006 09:21:14.013', --datParam_Value
				'strParam_Value: Server name for QLoader' --comments
		/* Environment name = "Staging" */
			 Exec [Temp_InsertUpdateQualProParams] 
				 'Approval Mode', --strParam_nm
				 'N', --strParam_type can be "N","S" or "D"
				 'QLoader', --strParam_GRP
				 NULL, --strParam_Value
				 '1', --numParam_Value
				 NULL, --datParam_Value
				 'If 1, loading and approving can be done by the same person. If 2 they have to be separate people.' --comments				
	END
	/* End Staging Settings */

	/* Testing Settings */
	IF @EnvironmentName = 'TESTING'
	Begin
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'QLDataStorePath', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QLoader', --strParam_GRP
				'\\Superman\QLoader', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'QLDTSServiceMachine', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QLoader', --strParam_GRP
				'WonderWoman', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'QLDTSServiceName', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QLoader', --strParam_GRP
				'QLoader Service', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'QLReportServer', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QLoader', --strParam_GRP
				'http://ironman/ReportServer?/DataLoadingReports/', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'QLValidationReport', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QLoader', --strParam_GRP
				'ValidationReports', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'QLPackageReport', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QLoader', --strParam_GRP
				'PackageReport', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'QLPackageOwnersEmailGroup', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QLoader', --strParam_GRP
				'LoadingTeamTest@nationalresearch.com', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		/* Environment name = "Testing" */
			Exec [Temp_InsertUpdateQualProParams]
				'QLoader', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'QLoader', --strParam_GRP
				'Wonderwoman', --strParam_Value
				'0', --numParam_Value
				'10-12-2006 09:21:14.013', --datParam_Value
				'strParam_Value: Server name for QLoader' --comments
		/* Environment name = "Testing" */
			 Exec [Temp_InsertUpdateQualProParams] 
				 'Approval Mode', --strParam_nm
				 'N', --strParam_type can be "N","S" or "D"
				 'QLoader', --strParam_GRP
				 NULL, --strParam_Value
				 '1', --numParam_Value
				 NULL, --datParam_Value
				 'If 1, loading and approving can be done by the same person. 
				 If 2 they have to be separate people.' --comments								
		END
	/* End Testing Settings */
