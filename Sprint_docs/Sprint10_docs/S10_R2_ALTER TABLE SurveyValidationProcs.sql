USE QP_PROD
GO


ALTER TABLE [dbo].[SurveyValidationProcs]
	add bitActive bit NOT NULL DEFAULT(1)
 
