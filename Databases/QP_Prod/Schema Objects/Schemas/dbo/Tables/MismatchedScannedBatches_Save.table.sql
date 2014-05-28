﻿CREATE TABLE [dbo].[MismatchedScannedBatches_Save](
	[strlithocode] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[QUESTIONFORM_ID] [int] NOT NULL,
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
	[QstnCoreCnt] [int] NULL
) ON [PRIMARY]


