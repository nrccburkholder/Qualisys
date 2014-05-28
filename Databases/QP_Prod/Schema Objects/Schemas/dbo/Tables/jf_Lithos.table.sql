CREATE TABLE [dbo].[jf_Lithos](
	[LithoCode] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SentMailID] [int] NULL,
	[QuestionFormID] [int] NULL,
	[SamplePopID] [int] NULL,
	[SurveyID] [int] NULL,
	[CmntID] [int] NULL,
	[Generated] [datetime] NULL,
	[Mailed] [datetime] NULL,
	[Expired] [datetime] NULL,
	[Deleted] [datetime] NULL,
	[Returned] [datetime] NULL,
	[Entered] [datetime] NULL,
	[QtyNoCode] [int] NULL,
	[QtyOther] [int] NULL
) ON [PRIMARY]


