/*
S19 US19 ICH Questionnaire -- Modify survey validation

Tim Butler

"Remove" QuestionCores 47206, 47207, 51201, 51202, 51203

Add QuestionCore 52433

*/


USE QP_PROD
GO

DECLARE @SurveyType_ID int

select @SurveyType_ID = SurveyType_Id from SurveyType where SurveyType_dsc = 'ICHCAHPS'


begin tran

update [dbo].[SurveyTypeQuestionMappings]
	SET datEncounterEnd_dt = '2014-12-31 00:00:00.000'
WHERE [QstnCore] = 47206
and [SurveyType_id] = @SurveyType_ID

update [dbo].[SurveyTypeQuestionMappings]
	SET datEncounterEnd_dt = '2014-12-31 00:00:00.000'
WHERE [QstnCore] = 47207
and [SurveyType_id] = @SurveyType_ID

update [dbo].[SurveyTypeQuestionMappings]
	SET datEncounterEnd_dt = '2014-12-31 00:00:00.000'
WHERE [QstnCore] = 51201
and [SurveyType_id] = @SurveyType_ID

update [dbo].[SurveyTypeQuestionMappings]
	SET datEncounterEnd_dt = '2014-12-31 00:00:00.000'
WHERE [QstnCore] = 51202
and [SurveyType_id] = @SurveyType_ID

update [dbo].[SurveyTypeQuestionMappings]
	SET datEncounterEnd_dt = '2014-12-31 00:00:00.000'
WHERE [QstnCore] = 51203
and [SurveyType_id] = @SurveyType_ID


INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_ID])
VALUES(@SurveyType_ID,52433,59,0,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)


commit tran
