CREATE TABLE [dbo].[recurringencounter](
	[RECURRINGENC_ID] [int] IDENTITY(1,1) NOT NULL,
	[STUDY_ID] [int] NOT NULL,
	[STARTENC_ID] [int] NOT NULL,
	[ENDENC_ID] [int] NULL,
	[POP_ID] [int] NOT NULL
) ON [PRIMARY]


