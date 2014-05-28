CREATE TABLE [dbo].[cmnt_questionresult_work](
	[questionform_id] [int] NULL,
	[strlithocode] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[samplepop_id] [int] NULL,
	[val] [int] NULL,
	[sampleunit_id] [int] NULL,
	[qstncore] [int] NULL,
	[datmailed] [datetime] NULL,
	[datimported] [datetime] NULL,
	[study_id] [int] NULL,
	[datGenerated] [datetime] NULL,
	[Survey_id] [int] NULL,
	[ReceiptType_ID] [int] NULL,
	[SurveyType_ID] [int] NULL,
	[bitComplete] [int] NULL,
	[FinalDisposition] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


