
/********************************************* NORMS SETTINGS *******************************************************/
USE [QP_Prod]
GO
/* Created By Arman Mnatsakanyan Creation Date: 3/13/2009 10:50:54 AM */
/* PROCEDURE Temp_InsertUpdateQualProParams must exist for this script to run */
Declare @EnvironmentName varchar(20)
Set @EnvironmentName = (Select strParam_Value  From QualPro_Params Where strParam_Nm = 'EnvName')
		/*  These settings are also used in Norms application
				'QP_NormsConnection', --strParam_nm
				'QP_CommentsConnection', --strParam_nm
				'NRCAuthConnection', --strParam_nm
				'SMTPServer', --strParam_nm
		*/
	/* Global Settings */
			Exec [Temp_InsertUpdateQualProParams] 
				'NRMCanadaNormGeneralSettingReport', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'Norms', --strParam_GRP
				'Canada Norm General Settings Report', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
			Exec [Temp_InsertUpdateQualProParams] 
				'NRMCanadaNormSurveySelectionReport', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'Norms', --strParam_GRP
				'Canada Norm Survey Report', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
			Exec [Temp_InsertUpdateQualProParams] 
				'NRMCanadaNormRollupSelectionReport', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'Norms', --strParam_GRP
				'Canada Norm Rollup Report', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
			Exec [Temp_InsertUpdateQualProParams] 
				'NRMCanadaNormQuestionScoreReport', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'Norms', --strParam_GRP
				'Canada Norm Question Score Report', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
			Exec [Temp_InsertUpdateQualProParams] 
				'NRMCanadaQuestionBenchmarkPerformerReport', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'Norms', --strParam_GRP
				'Canada Question Benchmark Performer', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
			Exec [Temp_InsertUpdateQualProParams] 
				'NRMCanadaDimensionBenchmarkPerformerReport', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'Norms', --strParam_GRP
				'Canada Dimension Benchmark Performer', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
	/* End Global Settings */


	/* Production Settings */
	IF @EnvironmentName = 'PRODUCTION'
		Begin
		/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'NRMReportServer', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'Norms', --strParam_GRP
				'http://iris/ReportServer?/ComparisonData/', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		End
	/* End Production Settings */

	/* Staging Settings */
	IF @EnvironmentName = 'STAGING'
		Begin
				/* Environment name = "Production" */
			Exec [Temp_InsertUpdateQualProParams] 
				'NRMReportServer', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'Norms', --strParam_GRP
				'http://RunningRebel/ReportServer?/ComparisonData/', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null -- The URL needs to be verified
		End
	/* End Staging Settings */

	/* Testing Settings */
	IF @EnvironmentName = 'TESTING'
		Begin
		/* Environment name = "Testing" */	
			Exec [Temp_InsertUpdateQualProParams] 
				'NRMReportServer', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'Norms', --strParam_GRP
				'http://ironman/ReportServer?/ComparisonData/', --strParam_Value
				Null, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		End
	/* End Testing Settings */
