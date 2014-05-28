CREATE TABLE [dbo].[Rollback_Questionform](
	[Rollback_id] [int] NOT NULL,
	[QUESTIONFORM_ID] [int] NULL,
	[SENTMAIL_ID] [int] NULL,
	[SAMPLEPOP_ID] [int] NULL,
	[CUTOFF_ID] [int] NULL,
	[DATRETURNED] [datetime] NULL,
	[SURVEY_ID] [int] NULL,
	[UnusedReturn_id] [int] NULL,
	[datUnusedReturn] [datetime] NULL,
	[datResultsImported] [datetime] NULL,
	[strSTRBatchNumber] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[intSTRLineNumber] [int] NULL,
	[intPhoneAttempts] [int] NULL
) ON [PRIMARY]


