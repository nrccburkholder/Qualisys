/*

ROLLBACK!!!!!!!!!!!!!!!!!!!!

S49 ATL-395 Hospice CAHPS Lang Speak Question Update

As an approved Hospice CAHPS vendor, we need to update our processes to handle a change to the language-speak question, so that we comply with mandatory requirements.


ATL-396 - Update Survey Validation (delete previous core from SurveyTypeQuestionMappings)

Tim Butler


*/

USE [QP_Comments]
GO


begin tran

DELETE [QP_Comments].[dbo].[SurveyTypeQuestionMappings]
  where SurveyType_id = 11
  and QstnCore = 55137

commit tran

SELECT *
FROM [QP_Comments].[dbo].[SurveyTypeQuestionMappings]
where SurveyType_id = 11
