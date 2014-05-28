CREATE TABLE [dbo].[SurveyValidationResults](
	[SurveyValidationResult_id] [int] IDENTITY(1,1) NOT NULL,
	[Survey_id] [int] NULL,
	[datRan] [datetime] NULL,
	[Error] [smallint] NULL,
	[strMessage] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


