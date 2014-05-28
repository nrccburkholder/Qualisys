CREATE TABLE [dbo].[Comments_07062010194755000](
	[Cmnt_id] [int] IDENTITY(1,1) NOT NULL,
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
 CONSTRAINT [PK__commen_07062010194755001] PRIMARY KEY CLUSTERED 
(
	[Cmnt_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


