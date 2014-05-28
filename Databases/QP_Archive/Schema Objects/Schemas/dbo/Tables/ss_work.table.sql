CREATE TABLE [dbo].[ss_work](
	[Cmnt_id] [int] NOT NULL,
	[strCmntText] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datEntered] [datetime] NULL,
	[datReported] [datetime] NULL,
	[CmntType_id] [int] NULL,
	[CmntValence_id] [int] NULL,
	[QuestionForm_id] [int] NULL,
	[SampleUnit_id] [int] NULL,
	[QstnCore] [int] NULL,
	[strVSTRBatchNumber] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[intVSTRLineNumber] [int] NULL,
	[strCmntOrHand] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[strCmntTextUM] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[samplepop_id] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


