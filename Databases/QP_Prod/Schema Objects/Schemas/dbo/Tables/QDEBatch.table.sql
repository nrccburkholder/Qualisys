CREATE TABLE [dbo].[QDEBatch](
	[Batch_id] [int] IDENTITY(1,1) NOT NULL,
	[strBatchName]  AS (replace(convert(varchar,[datEntered],109),'  ',' ')),
	[BatchType_id] [int] NULL,
	[datEntered] [datetime] NOT NULL,
	[strEnteredBy] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datFinalized] [datetime] NULL,
	[strFinalizedBy] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_QDEBatch] PRIMARY KEY CLUSTERED 
(
	[Batch_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


