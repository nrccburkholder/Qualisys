/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [SurveyType_id]
      ,[QstnCore]
      ,[intOrder]
      ,[bitFirstOnForm]
      ,[bitExpanded]
      ,[datEncounterStart_dt]
      ,[datEncounterEnd_dt]
  FROM [QP_Prod].[dbo].[SurveyTypeQuestionMappings]
  where surveytype_id = (select surveytype_id from [QP_Prod].[dbo].[SurveyType] where [SurveyType_dsc] = 'HCAHPS IP')
  and qstncore in (43350, 50860)


    /*


select *
into bak_SurveyTypeQuestionMappings_Release001
from SurveyTypeQuestionMappings

  update [QP_Prod].[dbo].[SurveyTypeQuestionMappings]
	SET QstnCore = 50860
  where surveytype_id = (select surveytype_id from [QP_Prod].[dbo].[SurveyType] where [SurveyType_dsc] = 'HCAHPS IP')
  and QstnCore = 43350

  */

