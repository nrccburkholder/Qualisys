CREATE TABLE [dbo].[Scheduled_TP](
	[TP_id] [int] IDENTITY(1,1) NOT NULL,
	[study_id] [int] NULL,
	[survey_id] [int] NULL,
	[sampleset_id] [int] NULL,
	[pop_id] [int] NULL,
	[methodology_id] [int] NULL,
	[mailingstep_id] [int] NULL,
	[overrideitem_id] [int] NULL,
	[language] [int] NULL,
	[bitMockup] [bit] NULL CONSTRAINT [DF_Scheduled_TP_bitMockup]  DEFAULT (1),
	[strSections] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[strEmail] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[employee_id] [int] NULL,
	[bitDone] [bit] NULL CONSTRAINT [DF_Scheduled_TP_bitDone]  DEFAULT (0),
	[datScheduled] [datetime] NULL
) ON [PRIMARY]


