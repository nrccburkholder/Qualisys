/****** Script for SelectTopNRows command from SSMS  ******/

  USE [QP_Prod]


DECLARE @Surveytype_id int
DECLARE @Subtype_id int

SELECT @Surveytype_id = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'CGCAHPS'

select @Subtype_id = Subtype_Id
from Subtype
where Subtype_nm = 'PCMH'


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
