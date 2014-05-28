CREATE TABLE [dbo].[DL_SurveyDataLoad](
	[SurveyDataLoad_ID] [int] IDENTITY(1,1) NOT NULL,
	[DataLoad_ID] [int] NULL,
	[Survey_ID] [int] NULL,
	[DateCreated] [datetime] NULL CONSTRAINT [DF_DL_SurveyDataLoad_DateCreated]  DEFAULT (getdate()),
	[Notes] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bitHasErrors] [bit] NOT NULL CONSTRAINT [DF_DL_SurveyDataLoad_bitHasErrors]  DEFAULT (0),
 CONSTRAINT [PK_DL_SurveyDataLoad] PRIMARY KEY CLUSTERED 
(
	[SurveyDataLoad_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


