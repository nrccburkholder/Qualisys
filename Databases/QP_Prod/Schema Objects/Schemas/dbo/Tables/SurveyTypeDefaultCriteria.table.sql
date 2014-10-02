CREATE TABLE [dbo].[SurveyTypeDefaultCriteria](
	[SurveyTypeDefaultCriteria] INT NOT NULL IDENTITY(1,1),
	[SurveyType_id] INT NULL,
	[Country_id] INT NULL,
	[DefaultCriteriaStmt_id] INT NULL
) ON [PRIMARY] 