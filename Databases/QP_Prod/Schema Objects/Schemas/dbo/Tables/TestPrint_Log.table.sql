CREATE TABLE [dbo].[TestPrint_Log](
	[TP_id] [int] NOT NULL,
	[study_id] [int] NULL,
	[survey_id] [int] NULL,
	[sampleset_id] [int] NULL,
	[samplepop_id] [int] NULL,
	[pop_id] [int] NULL,
	[methodology_id] [int] NULL,
	[mailingstep_id] [int] NULL,
	[overrideitem_id] [int] NULL,
	[language] [int] NULL,
	[employee_id] [int] NULL,
	[bitMockup] [bit] NULL,
	[datScheduled] [datetime] NULL,
	[selcover_id] [int] NULL,
	[batch_id] [int] NULL,
	[priority_flg] [tinyint] NULL,
	[bitDone] [bit] NULL,
	[datDone] [datetime] NULL,
	[strSections] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[strEmail] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


