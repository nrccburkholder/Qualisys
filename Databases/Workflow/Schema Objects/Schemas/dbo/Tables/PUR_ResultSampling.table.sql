CREATE TABLE [dbo].[PUR_ResultSampling](
	[PUReport_ID] [int] NOT NULL,
	[SampleSet_ID] [int] NOT NULL,
	[MailingStep_ID] [int] NULL,
	[MailingStepStatus] [tinyint] NULL,
	[strMailingStep_NM] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Study_ID] [int] NULL,
	[strStudy_NM] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Survey_ID] [int] NULL,
	[strSurvey_NM] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datSampleCreate_Dt] [datetime] NULL,
	[datDateRange_FromDate] [datetime] NULL,
	[datDateRange_ToDate] [datetime] NULL,
	[SamplePopCount] [int] NULL,
	[datProcessed] [datetime] NULL,
	[MailPiece] [int] NULL
) ON [PRIMARY]


