CREATE TABLE [dbo].[DL_LithoCodes](
	[DL_LithoCode_ID] [int] IDENTITY(1,1) NOT NULL,
	[SurveyDataLoad_ID] [int] NULL,
	[DL_Error_ID] [int] NULL,
	[strLithoCode] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bitIgnore] [bit] NULL CONSTRAINT [DF_DL_LithoCodes_bitIgnore]  DEFAULT (0),
	[bitSubmitted] [bit] NULL CONSTRAINT [DF_DL_LithoCodes_bitSubmitted]  DEFAULT (0),
	[bitExtracted] [bit] NULL CONSTRAINT [DF_DL_LithoCodes_bitExtracted]  DEFAULT (0),
	[bitSkipDuplicate] [bit] NULL CONSTRAINT [DF_DL_LithoCodes_bitSkipDuplicate]  DEFAULT (0),
	[bitDispositionUpdate] [bit] NULL CONSTRAINT [DF_DL_LithoCodes_bitDispositionUpdate]  DEFAULT (0),
	[DateCreated] [datetime] NULL CONSTRAINT [DF_DL_dataLoadLithoCodes_DateCreated]  DEFAULT (getdate()),
	[TranslationCode] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_DL_LithoCodes] PRIMARY KEY CLUSTERED 
(
	[DL_LithoCode_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


