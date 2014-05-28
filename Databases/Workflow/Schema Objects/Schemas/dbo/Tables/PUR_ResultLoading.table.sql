CREATE TABLE [dbo].[PUR_ResultLoading](
	[PUReport_ID] [int] NOT NULL,
	[DataSet_ID] [int] NOT NULL,
	[Study_ID] [int] NULL,
	[strStudy_nm] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LoadOnDate] [datetime] NULL,
	[ReportDateBegin] [datetime] NULL,
	[ReportDateEnd] [datetime] NULL,
	[RecNum] [int] NULL,
	[PopNum] [int] NULL,
 CONSTRAINT [PK_PUR_PUR_ResultLoading] PRIMARY KEY CLUSTERED 
(
	[PUReport_ID] ASC,
	[DataSet_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


