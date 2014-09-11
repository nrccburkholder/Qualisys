USE [QP_Prod]
GO

IF NOT EXISTS(select 1 from dbo.subtype where Subtype_nm = 'ACO-8')
INSERT INTO [dbo].[Subtype]
           ([Subtype_nm]
           ,[SubtypeCategory_id]
           ,[bitRuleOverride])
     VALUES
           ('ACO-8'
           ,2
           ,0)

IF NOT EXISTS(select 1 from dbo.subtype where Subtype_nm = 'ACO-12')
INSERT INTO [dbo].[Subtype]
           ([Subtype_nm]
           ,[SubtypeCategory_id]
           ,[bitRuleOverride])
     VALUES
           ('ACO-12'
           ,2
           ,0)
GO

declare @ACO8 int 
select @ACO8 = subtype_id from subtype where Subtype_nm = 'ACO-8'

declare @ACO12 int 
select @ACO12 = subtype_id from subtype where Subtype_nm = 'ACO-12'

IF NOT EXISTS(select 1 from dbo.surveytypesubtype where surveytype_id = 10 and subtype_id = @ACO8)
INSERT INTO [dbo].[SurveyTypeSubtype]
           ([SurveyType_id]
           ,[Subtype_id])
     VALUES
           (10
           ,@ACO8)

IF NOT EXISTS(select 1 from dbo.surveytypesubtype where surveytype_id = 10 and subtype_id = @ACO12)
INSERT INTO [dbo].[SurveyTypeSubtype]
           ([SurveyType_id]
           ,[Subtype_id])
     VALUES
           (10
           ,@ACO12)



Update SurveyTypeQuestionMappings 
set SubType_ID = @ACO8
--select * from SurveyTypeQuestionMappings
where surveytype_id = 10 and
QstnCore in (50231,50232,50233)
and SubType_ID is null

GO