/*

S34 US 18  As a data mgmt associate I want the OCS HH validation warnings for HHPay_MCaid and HHPay_MCare removed so that I am not having to approve files unnecessarily. 

Task 1: delete records from table that holds OCS HH validation thresholds (delete from validation_definitions table and insert into validation_definitions_deleted)

Tim Butler

ROLLBACK

*/




begin tran

	INSERT [QP_DataLoad].[dbo].[Validation_Definitions]
	SELECT [NullValidationDefinitionID]
		  ,[ClientGroup_ID]
		  ,[Client_ID]
		  ,[Study_ID]
		  ,[Survey_ID]
		  ,[SurveyType_ID]
		  ,[Table_nm]
		  ,[Field_nm]
		  ,[FailureThresholdPct]
		  ,[CheckForValue]
		  ,Getdate()
	  FROM [QP_DataLoad].[dbo].[Validation_Definitions_Deleted]
	  where Field_nm in ('HHPay_MCaid', 'HHPay_MCare')

	  DELETE FROM [QP_DataLoad].[dbo].[Validation_Definitions_Deleted]
	  where Field_nm in ('HHPay_MCaid', 'HHPay_MCare')


commit tran


SELECT * -- should return nothing
FROM [QP_DataLoad].[dbo].[Validation_Definitions_Deleted]

SELECT * -- should return something
FROM [QP_DataLoad].[dbo].[Validation_Definitions]
where Field_nm in ('HHPay_MCaid', 'HHPay_MCare')