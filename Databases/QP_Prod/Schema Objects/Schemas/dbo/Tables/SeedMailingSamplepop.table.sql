CREATE TABLE [dbo].[SeedMailingSamplepop](
	[Samplepop_id] [int] NOT NULL,
	[MailingReceiver_id] [int] NULL,
	[datUsed] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Samplepop_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]


