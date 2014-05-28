CREATE TABLE [dbo].[drm_bad_lithos](
	[strLithoCode] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datUndeliverable] [datetime] NULL,
	[datReturned] [datetime] NULL,
	[datResultsImported] [datetime] NULL,
	[datUnusedReturn] [datetime] NULL,
	[UnusedReturn_id] [int] NULL,
	[strSTRBatchNumber] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[intSTRLineNumber] [int] NULL,
	[strNTLogin_Nm] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[strWorkstation] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datReset] [datetime] NULL
) ON [PRIMARY]


