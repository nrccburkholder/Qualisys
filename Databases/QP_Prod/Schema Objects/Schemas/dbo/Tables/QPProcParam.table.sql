CREATE TABLE [dbo].[QPProcParam](
	[QPProcParam_id] [int] IDENTITY(1,1) NOT NULL,
	[QPReport_ID] [int] NULL,
	[QPReportProc_ID] [int] NULL,
	[strParam_nm] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[strParam_type] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[strQueryForList] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[QueryForList_id] [int] NULL,
 CONSTRAINT [PK__QPProcParam__05E4990D] PRIMARY KEY CLUSTERED 
(
	[QPProcParam_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]


