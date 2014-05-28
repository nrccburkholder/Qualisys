CREATE TABLE [dbo].[Generation_Rollbacks](
	[Rollback_id] [int] IDENTITY(1,1) NOT NULL,
	[Survey_id] [int] NULL,
	[datBundled] [datetime] NULL,
	[PaperConfig_id] [int] NULL,
	[strPostalBundle] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Who] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datRollback_start] [datetime] NULL,
	[datRollback_end] [datetime] NULL,
	[datRecoveryDeleted] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Rollback_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


