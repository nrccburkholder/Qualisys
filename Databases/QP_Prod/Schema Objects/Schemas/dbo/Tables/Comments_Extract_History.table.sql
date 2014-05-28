CREATE TABLE [dbo].[Comments_Extract_History](
	[CmntExtract_ID] [int] NOT NULL,
	[Cmnt_ID] [int] NOT NULL,
	[tiExtracted] [tinyint] NOT NULL,
	[datExtracted_DT] [datetime] NULL,
	[Study_ID] [int] NULL
) ON [PRIMARY]


