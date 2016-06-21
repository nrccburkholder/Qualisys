-- add SubType_ID to StandardMethodologyBySurveyType
ALTER TABLE [dbo].[StandardMethodologyBySurveyType]
drop column SubType_ID 
GO


-- add SubType_ID to SurveyValidationFields
ALTER TABLE [dbo].[SurveyTypeQuestionMappings]
drop column SubType_ID 

GO

-- add SubType_ID to SurveyValidationFields
ALTER TABLE SurveyValidationFields
drop column SubType_ID 
