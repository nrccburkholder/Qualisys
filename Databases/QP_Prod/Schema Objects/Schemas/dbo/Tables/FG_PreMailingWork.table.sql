CREATE TABLE [dbo].[FG_PreMailingWork](
	[Study_id] [int] NULL,
	[Survey_id] [int] NULL,
	[SamplePop_id] [int] NULL,
	[ScheduledMailing_id] [int] NULL,
	[Priority_Flg] [tinyint] NULL,
	[Zip5] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Zip4] [varchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SampleSet_id] [int] NULL,
	[Pop_id] [int] NULL,
	[MailingStep_id] [int] NULL,
	[Methodology_id] [int] NULL,
	[OverrideItem_id] [int] NULL
) ON [FGPopTables]


