CREATE TABLE [dbo].[StandardMethodologyBySurveyType](
	[StandardMethodologyID] [int] NULL,
	[SurveyType_id] [int] NULL,
	[SubType_ID] [int] NULL,
	[bitExpired] bit NOT NULL DEFAULT(0)
) ON [PRIMARY]


