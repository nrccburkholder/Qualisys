CREATE TABLE [dbo].[QuestionFormTemp](
	[ExtractFileID] [int] NOT NULL,
	[QUESTIONFORM_ID] [int] NOT NULL,
	[SAMPLEPOP_ID] [int] NOT NULL,
	[strLithoCode] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[isComplete] [nvarchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RECEIPTTYPE_ID] [int] NULL,
	[returnDate] [datetime] NULL,
	[DatMailed] [datetime] NULL,
	[DatExpire] [datetime] NULL,
	[DatGenerated] [datetime] NULL,
	[DatPrinted] [datetime] NULL,
	[DatBundled] [datetime] NULL,
	[DatUndeliverable] [datetime] NULL,
	[DatFirstMailed] [datetime] NULL,
	[DaysFromFirstMailing] [int] NULL,
	[DaysFromCurrentMailing] [int] NULL,
	[SURVEY_ID] [int] NULL,
	[SurveyType_id] [int] NULL,
	[IsDeleted] [bit] NOT NULL,
	[LangID] [int] NULL
) ON [PRIMARY]


