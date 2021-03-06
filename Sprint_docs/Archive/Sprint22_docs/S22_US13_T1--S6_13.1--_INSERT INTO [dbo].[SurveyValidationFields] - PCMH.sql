/****** Script for SelectTopNRows command from SSMS  ******/

  USE [QP_Prod]


DECLARE @Surveytype_id int
DECLARE @Subtype_id int

SELECT @Surveytype_id = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'CGCAHPS'

if not exists (select 1 from subtype where Subtype_nm = 'PCMH Distinction') 
	INSERT INTO dbo.subtype VALUES ('PCMH Distinction',1,1)



select @Subtype_id = Subtype_Id
from Subtype
where Subtype_nm = 'PCMH Distinction'

if not exists (select 1 from surveytypesubtype where surveytype_id = @surveytype_id and subtype_id = @subtype_id)
	INSERT INTO dbo.SurveyTypeSubtype VALUES (@SurveyType_id,@subtype_id)


begin tran

INSERT INTO [dbo].[SurveyValidationFields]([SurveyType_Id],[ColumnName],[TableName] ,[bitActive], SubType_ID)VALUES(@Surveytype_id,'PCMH_PracName','ENCOUNTER',1,@Subtype_id)
INSERT INTO [dbo].[SurveyValidationFields]([SurveyType_Id],[ColumnName],[TableName] ,[bitActive], SubType_ID)VALUES(@Surveytype_id,'MoResVisDate','ENCOUNTER',1,@Subtype_id)
INSERT INTO [dbo].[SurveyValidationFields]([SurveyType_Id],[ColumnName],[TableName] ,[bitActive], SubType_ID)VALUES(@Surveytype_id,'PCMH_VisCnt','ENCOUNTER',1,@Subtype_id)
INSERT INTO [dbo].[SurveyValidationFields]([SurveyType_Id],[ColumnName],[TableName] ,[bitActive], SubType_ID)VALUES(@Surveytype_id,'PCMH_FileDate','ENCOUNTER',1,@Subtype_id)
INSERT INTO [dbo].[SurveyValidationFields]([SurveyType_Id],[ColumnName],[TableName] ,[bitActive], SubType_ID)VALUES(@Surveytype_id,'PCMH_Age','ENCOUNTER',1,@Subtype_id)
/*
commit tran

rollback tran

*/

SELECT *
  FROM [QP_Prod].[dbo].[SurveyValidationFields]
