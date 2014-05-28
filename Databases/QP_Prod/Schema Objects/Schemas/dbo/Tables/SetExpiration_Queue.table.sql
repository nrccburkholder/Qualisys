CREATE TABLE [dbo].[SetExpiration_Queue](
	[SentMail_id] [int] NOT NULL,
	[SamplePop_id] [int] NOT NULL,
	[MailingStep_id] [int] NOT NULL,
	[ExpireInDays] [int] NULL,
	[ExpireFromStep] [int] NULL,
	[PreviousMailDate] [datetime] NULL,
	[datExpire]  AS (dateadd(day,([ExpireInDays] + 1),convert(datetime,convert(varchar,[PreviousMailDate],101)))),
 CONSTRAINT [PK_SetExpiration_Queue] PRIMARY KEY CLUSTERED 
(
	[SentMail_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


