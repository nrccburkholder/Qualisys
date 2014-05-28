CREATE TABLE [dbo].[drm_bad_extract_sr_nonquestion](
	[Study_id] [int] NOT NULL,
	[Survey_ID] [int] NULL,
	[Questionform_id] [int] NOT NULL,
	[SamplePop_id] [int] NOT NULL,
	[SampleUnit_id] [int] NOT NULL,
	[strLithoCode] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SampleSet_id] [int] NULL,
	[datReturned] [datetime] NULL,
	[datReportDate] [datetime] NULL,
	[strUnitSelectType] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bitComplete] [bit] NULL,
	[DaysFromFirstMailing] [int] NULL,
	[DaysFromCurrentMailing] [int] NULL,
	[LangID] [int] NULL,
	[ReceiptType_ID] [int] NULL
) ON [PRIMARY]


