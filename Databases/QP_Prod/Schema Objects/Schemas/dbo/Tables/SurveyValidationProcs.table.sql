CREATE TABLE [dbo].[SurveyValidationProcs](
	[SurveyValidationProcs_id] [int] IDENTITY(1,1) NOT NULL,
	[ProcedureName] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ValidMessage] [varchar](70) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[intOrder] [int] NULL
) ON [PRIMARY]


