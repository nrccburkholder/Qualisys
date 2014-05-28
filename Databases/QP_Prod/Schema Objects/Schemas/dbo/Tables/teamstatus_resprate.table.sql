CREATE TABLE [dbo].[teamstatus_resprate](
	[Client] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Study] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Study_ID] [int] NULL,
	[Survey] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Survey_ID] [int] NULL,
	[Historical] [decimal](5, 2) NULL,
	[CurrentPeriod] [decimal](5, 2) NULL
) ON [PRIMARY]


