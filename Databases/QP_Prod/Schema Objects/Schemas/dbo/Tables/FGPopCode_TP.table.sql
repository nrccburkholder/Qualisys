CREATE TABLE [dbo].[FGPopCode_TP](
	[TP_id] [int] NOT NULL,
	[survey_id] [int] NULL,
	[sampleunit_id] [int] NULL,
	[language] [int] NULL,
	[code] [int] NULL,
	[codetext] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [FGPopTables]


