CREATE TABLE [dbo].[DODCOB](
	[RETURNDATE] [datetime] NULL,
	[PIN] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LITHO] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SAMPLESET_ID] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SUBMIT] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[H000001] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[H000002] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[H000003] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[pop_id] [int] NULL,
	[samplepop_id] [int] NULL,
	[survey_id] [int] NULL
) ON [PRIMARY]


