use QP_PROD

-- add SubType_ID to SurveyValidationFields
ALTER TABLE [dbo].[SurveyTypeQuestionMappings]
ADD SubType_ID int NULL