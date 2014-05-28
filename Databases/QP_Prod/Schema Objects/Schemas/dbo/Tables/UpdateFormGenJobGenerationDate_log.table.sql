CREATE TABLE [dbo].[UpdateFormGenJobGenerationDate_log](
	[Survey_ID] [int] NULL,
	[MailingStep_ID] [int] NULL,
	[CurrentDatGenerate] [datetime] NULL,
	[NewDatGenerate] [datetime] NULL,
	[DateTimeOfChange] [datetime] NULL CONSTRAINT [DF_UpdateFormGenJobGenerationDate_log_DateTimeOfChange]  DEFAULT (getdate())
) ON [PRIMARY]


