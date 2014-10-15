USE QP_PROD
GO


ALTER TABLE [dbo].[SurveyValidationProcs]
	add Active bit NOT NULL DEFAULT(1)
 
