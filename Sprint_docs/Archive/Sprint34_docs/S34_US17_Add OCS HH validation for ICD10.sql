
/*


S34 US17 As a data mgmt associate I want a load warning if >= 90% of records have missing primary ICD-10 values so that I can ensure we are getting correct data from our clients

Task 1 - add a record to the table that holds OCS HH validation thresholds (validation_definitions)

Tim Butler

*/

USE [QP_DataLoad]
GO




IF NOT EXISTS (SELECT 1 FROM [QP_DataLoad].[dbo].[Validation_Definitions]
  WHERE Table_nm = 'Encounter'
  AND Field_nm = 'ICD10_1')
BEGIN

	begin tran
		INSERT INTO [dbo].[Validation_Definitions]
				   ([ClientGroup_ID]
				   ,[Client_ID]
				   ,[Study_ID]
				   ,[Survey_ID]
				   ,[SurveyType_ID]
				   ,[Table_nm]
				   ,[Field_nm]
				   ,[FailureThresholdPct]
				   ,[CheckForValue])
			 VALUES
				   (NULL
				   ,NULL
				   ,NULL
				   ,NULL
				   ,3
				   ,'Encounter'
				   ,'ICD10_1'
				   ,90
				   ,NULL)

	commit tran

END

SELECT TOP 1000 [NullValidationDefinitionID]
      ,[ClientGroup_ID]
      ,[Client_ID]
      ,[Study_ID]
      ,[Survey_ID]
      ,[SurveyType_ID]
      ,[Table_nm]
      ,[Field_nm]
      ,[FailureThresholdPct]
      ,[CheckForValue]
  FROM [QP_DataLoad].[dbo].[Validation_Definitions]