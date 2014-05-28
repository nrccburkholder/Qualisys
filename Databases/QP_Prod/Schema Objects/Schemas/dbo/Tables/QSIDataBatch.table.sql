CREATE TABLE [dbo].[QSIDataBatch](
	[Batch_ID] [int] IDENTITY(1,1) NOT NULL,
	[BatchName]  AS (replace(CONVERT([varchar](50),[DateEntered],(109)),'  ',' ')),
	[Locked] [bit] NOT NULL,
	[DateEntered] [datetime] NOT NULL,
	[EnteredBy] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DateFinalized] [datetime] NULL,
	[FinalizedBy] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED 
(
	[Batch_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]


