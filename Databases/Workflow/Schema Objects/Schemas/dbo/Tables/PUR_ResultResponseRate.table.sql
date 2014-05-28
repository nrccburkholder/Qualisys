CREATE TABLE [dbo].[PUR_ResultResponseRate](
	[PUReport_ID] [int] NOT NULL,
	[Order_ID] [int] NOT NULL,
	[Study_ID] [int] NOT NULL,
	[strStudy_Nm] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Survey_ID] [int] NOT NULL,
	[strSurvey_Nm] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Period_ID] [tinyint] NOT NULL,
	[SampleUnit_id] [int] NULL,
	[strSampleUnit_nm] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datDateRange_FromDate] [datetime] NULL,
	[datDateRange_ToDate] [datetime] NULL,
	[Target] [int] NULL,
	[Sampled] [int] NULL,
	[Undel] [int] NULL,
	[Returned] [int] NULL,
	[RespRate] [decimal](7, 6) NULL,
	[Tier] [int] NULL,
	[RRDetail] [tinyint] NOT NULL,
 CONSTRAINT [PK_PUR_ResultResponseRate] PRIMARY KEY CLUSTERED 
(
	[PUReport_ID] ASC,
	[Order_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


