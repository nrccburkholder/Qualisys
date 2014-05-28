CREATE TABLE [dbo].[NonMailGen_NotifyLog](
	[notify_id] [int] IDENTITY(1,1) NOT NULL,
	[survey_id] [int] NULL,
	[sampleset_id] [int] NULL,
	[mailingstep_id] [int] NULL,
	[ademployee_id] [int] NULL,
	[notify_dt] [datetime] NULL,
	[piececnt] [int] NULL,
	[SentFlg] [tinyint] NULL
) ON [PRIMARY]


