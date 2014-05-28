CREATE TABLE [dbo].[drm_questionform_inc0028173](
	[QUESTIONFORM_ID] [int] IDENTITY(1,1) NOT NULL,
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
	[intPhoneAttempts] [int] NULL,
	[bitComplete] [bit] NULL,
	[ReceiptType_id] [int] NULL,
	[strScanBatch] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BubbleCnt] [int] NULL,
	[QstnCoreCnt] [int] NULL,
	[bitExported] [bit] NULL,
	[numCAHPSSupplemental] [smallint] NULL
) ON [PRIMARY]


