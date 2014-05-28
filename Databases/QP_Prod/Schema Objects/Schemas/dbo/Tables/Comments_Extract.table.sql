CREATE TABLE [dbo].[Comments_Extract](
	[CmntExtract_ID] [int] IDENTITY(1,1) NOT NULL,
	[Cmnt_ID] [int] NOT NULL,
	[tiExtracted] [tinyint] NOT NULL CONSTRAINT [DF_Comment_Extract_bitExtracted]  DEFAULT (0),
	[datExtracted_DT] [datetime] NULL,
	[Study_ID] [int] NULL
) ON [PRIMARY]


