CREATE TABLE [dbo].[yyy_ResultResponseRate](
	[Order_ID] [int] IDENTITY(1,1) NOT NULL,
	[Study_ID] [int] NOT NULL,
	[strStudy_Nm] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Survey_ID] [int] NOT NULL,
	[strSurvey_Nm] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Period_ID] [tinyint] NOT NULL,
	[SampleUnit_ID] [int] NULL,
	[strSampleUnit_nm] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datDateRange_FromDate] [datetime] NULL,
	[datDateRange_ToDate] [datetime] NULL,
	[Target] [int] NULL,
	[Sampled] [int] NULL,
	[Undel] [int] NULL,
	[Returned] [int] NULL,
	[RespRate] [decimal](7, 6) NULL,
	[Tier] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Order_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


