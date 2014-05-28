CREATE TABLE [dbo].[PCLNeeded_TP](
	[samplepop_id] [int] NULL,
	[survey_id] [int] NULL,
	[selcover_id] [int] NULL,
	[language] [int] NULL,
	[TP_id] [int] NOT NULL,
	[batch_id] [int] NULL,
	[bitDone] [bit] NOT NULL,
	[priority_flg] [tinyint] NULL,
	[strEmail] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[employee_id] [int] NULL,
	[bitMockup] [bit] NULL
) ON [PRIMARY]


