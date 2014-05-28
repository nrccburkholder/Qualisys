CREATE TABLE [dbo].[PCLGenPerformanceLog](
	[PCLGenRun_id] [int] NOT NULL,
	[GenDate] [datetime] NULL,
	[Computer_nm] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BatchStart_dt] [datetime] NULL,
	[TotalCnt] [int] NULL,
	[Avg_Sec_Per_Svy] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[PCLGenRun_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


