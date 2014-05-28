CREATE TABLE [dbo].[Rollback_ScheduledMailing](
	[Rollback_id] [int] NOT NULL,
	[SCHEDULEDMAILING_ID] [int] NULL,
	[MAILINGSTEP_ID] [int] NULL,
	[SAMPLEPOP_ID] [int] NULL,
	[OVERRIDEITEM_ID] [int] NULL,
	[SENTMAIL_ID] [int] NULL,
	[METHODOLOGY_ID] [int] NULL,
	[DATGENERATE] [datetime] NULL
) ON [PRIMARY]


