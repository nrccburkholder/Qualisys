/* All-CAHPS Sprint 1, Story 3.1	
   Update surveyTypeQuestionMappings table to change old question core number to the new number
*/
UPDATE [QP_Prod].[dbo].[SurveyTypeQuestionMappings]
   SET [QstnCore] = 50860
 WHERE [QstnCore] = 43350
 AND [datEncounterStart_dt] = '2013-01-01'
GO




