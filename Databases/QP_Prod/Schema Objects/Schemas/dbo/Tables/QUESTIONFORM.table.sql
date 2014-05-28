CREATE TABLE [dbo].[QUESTIONFORM](
	[QUESTIONFORM_ID] [int] IDENTITY(1,1) NOT NULL,
	[SENTMAIL_ID] [int] NULL,
	[SAMPLEPOP_ID] [int] NULL,
	[CUTOFF_ID] [int] NULL,
	[DATRETURNED] [datetime] NULL,
	[SURVEY_ID] [int] NULL,
	[UnusedReturn_id] [int] NULL CONSTRAINT [DF_QUESTIONFORM_UnusedReturn_id]  DEFAULT (0),
	[datUnusedReturn] [datetime] NULL,
	[datResultsImported] [datetime] NULL,
	[strSTRBatchNumber] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[intSTRLineNumber] [int] NULL,
	[intPhoneAttempts] [int] NULL,
	[bitComplete] [bit] NULL,
	[ReceiptType_id] [int] NULL,
	[strScanBatch] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BubbleCnt] [int] NULL CONSTRAINT [DF__QUESTIONF__Bubbl__55CB7197]  DEFAULT ((0)),
	[QstnCoreCnt] [int] NULL CONSTRAINT [DF__QUESTIONF__QstnC__56BF95D0]  DEFAULT ((0)),
	[bitExported] [bit] NULL CONSTRAINT [DF_QUESTIONFORM_bitModified]  DEFAULT ((0)),
	[numCAHPSSupplemental] [smallint] NULL,
 CONSTRAINT [PK_QUESTIONFORM] PRIMARY KEY CLUSTERED 
(
	[QUESTIONFORM_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


