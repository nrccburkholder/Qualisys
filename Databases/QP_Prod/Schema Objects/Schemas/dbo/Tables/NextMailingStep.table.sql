CREATE TABLE [dbo].[NextMailingStep](
	[NextScheduledMailing_id] [int] NULL,
	[SentMail_id] [int] NULL,
	[SamplePop_id] [int] NULL,
	[MailingStep_id] [int] NULL,
	[Methodology_id] [int] NULL,
	[intintervaldays] [int] NULL,
	[nextdatgenerate] [datetime] NULL,
	[datUpdated] [datetime] NULL
) ON [PRIMARY]


