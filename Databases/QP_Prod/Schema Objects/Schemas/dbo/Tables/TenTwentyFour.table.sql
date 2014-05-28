CREATE TABLE [dbo].[TenTwentyFour](
	[Autonum] [int] IDENTITY(1,1) NOT NULL,
	[strClientName] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[strStudyName] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Study_ID] [int] NULL,
	[ProjectManagerEmployee_ID] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datPollingDate] [datetime] NULL,
	[ColumnCount] [int] NULL
) ON [PRIMARY]


