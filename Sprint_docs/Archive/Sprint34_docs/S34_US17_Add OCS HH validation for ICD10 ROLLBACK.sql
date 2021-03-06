
/*

ROLLBACK

S34 US17 As a data mgmt associate I want a load warning if >= 90% of records have missing primary ICD-10 values so that I can ensure we are getting correct data from our clients

Task 1 - add a record to the table that holds OCS HH validation thresholds (validation_definitions)

Tim Butler

*/

USE [QP_DataLoad]
GO


begin tran



DELETE
  FROM [QP_DataLoad].[dbo].[Validation_Definitions]
  WHERE Table_nm = 'Encounter'
  AND Field_nm = 'ICD10'

commit tran