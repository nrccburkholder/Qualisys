CREATE TABLE [dbo].[GHS_MailMergeSubJobLog](
	[Job_ID] [int] NOT NULL,
	[SubJob_ID] [int] NOT NULL,
	[RecNum] [int] NOT NULL,
	[StartRespondent_ID] [int] NOT NULL,
	[EndRespondent_ID] [int] NOT NULL,
	[StartSeqNum] [int] NOT NULL,
	[EndSeqNum] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Job_ID] ASC,
	[SubJob_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


