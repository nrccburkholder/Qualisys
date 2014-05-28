CREATE TABLE [dbo].[SkipQstnsDups](
	[SkipQstnsDups] [bigint] IDENTITY(1,1) NOT NULL,
	[survey_id] [int] NULL,
	[skip_id] [int] NULL,
	[QstnCore] [int] NULL,
	[datGenerated] [datetime] NULL,
	[CreateDate] [datetime] NULL,
	[ErrorMsg] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


