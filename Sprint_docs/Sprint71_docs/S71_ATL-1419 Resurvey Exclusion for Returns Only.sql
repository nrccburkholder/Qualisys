/*

S71_ATL-1419 Resurvey Exclusion for Returns Only.sql

Chris Burkholder

3/20/2017

INSERT INTO SubTypeCategory
INSERT INTO SubType

select * from surveytype
select * from subtypecategory
select * from subtype
select * from surveytypesubtype

*/

USE [QP_Prod]
GO

if not exists(select * from SubTypeCategory where SubtypeCategory_nm = 'Resurvey Exclusion Type')
INSERT INTO [dbo].[SubtypeCategory]
           ([SubtypeCategory_nm]
           ,[bitMultiSelect])
     VALUES
           ('Resurvey Exclusion Type'
           ,0)
GO

if not exists(select * from Subtype where Subtype_nm = 'Returns Only')
INSERT INTO [dbo].[Subtype]
           ([Subtype_nm]
           ,[SubtypeCategory_id]
           ,[bitRuleOverride]
           ,[bitQuestionnaireRequired]
           ,[bitActive])
     VALUES
           ('Returns Only'
           ,3
           ,0
           ,0
           ,1)
GO

if not exists(select * from SurveyTypeSubtype where SurveyType_id = 7)
INSERT INTO [dbo].[SurveyTypeSubtype]
           ([SurveyType_id]
           ,[Subtype_id])
     VALUES
           (7
           ,IDENT_CURRENT('dbo.Subtype'))
GO

