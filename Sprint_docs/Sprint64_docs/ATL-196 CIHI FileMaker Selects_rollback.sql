USE QP_PROD
GO



if exists (select * from sys.procedures where schema_name(schema_id)='CIHI' and name = 'Select_Final_Contact')
	drop procedure [CIHI].[Select_Final_Contact]
GO
