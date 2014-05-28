CREATE TABLE [dbo].[dmp_tempSummitExcl_20110520](
	[SamplingExlusionLog_ID] [int] NOT NULL,
	[Survey_ID] [int] NULL,
	[Sampleset_ID] [int] NULL,
	[Sampleunit_ID] [int] NULL,
	[Pop_ID] [int] NULL,
	[Enc_ID] [int] NULL,
	[SamplingExclusionType_ID] [int] NULL,
	[DQ_BusRule_ID] [int] NULL,
	[DateCreated] [datetime] NULL,
	[STRSAMPLEUNIT_NM] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SamplingExclusionType_nm] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SamplingExclusionType_Desc] [varchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


