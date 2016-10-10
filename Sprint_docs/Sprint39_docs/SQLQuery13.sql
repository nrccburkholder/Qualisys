

DECLARE @OldQstnCore int
DECLARE @NewQstnCore int


SET @OldQstnCore = 43350 
SET @NewQstnCore = 50860

 SELECT *
  FROM [QP_Prod].[dbo].[SurveyTypeQuestionMappings]
  where QstnCore = @OldQstnCore

  SELECT *
  FROM [QP_Prod].[dbo].[SurveyTypeQuestionMappings]
  where QstnCore = @NewQstnCore 