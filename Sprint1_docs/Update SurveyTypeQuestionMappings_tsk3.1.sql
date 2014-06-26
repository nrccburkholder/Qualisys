/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [SurveyType_id]
      ,[QstnCore]
      ,[intOrder]
      ,[bitFirstOnForm]
      ,[bitExpanded]
      ,[datEncounterStart_dt]
      ,[datEncounterEnd_dt]
  FROM [QP_Prod].[dbo].[SurveyTypeQuestionMappings]
  where surveytype_id = (select surveytype_id from [QP_Prod].[dbo].[SurveyType] where [SurveyType_dsc] = 'HCAHPS IP')
  and qstncore = 43350


  /*
  update [QP_Prod].[dbo].[SurveyTypeQuestionMappings]
	SET QstnCore = 50860
  where surveytype_id = (select surveytype_id from [QP_Prod].[dbo].[SurveyType] where [SurveyType_dsc] = 'HCAHPS IP')
  and QstnCore = 43350

  */