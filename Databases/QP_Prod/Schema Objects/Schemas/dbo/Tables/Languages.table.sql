CREATE TABLE [dbo].[Languages](
	[LangID] [int] NOT NULL,
	[Language] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Dictionary] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WebLanguageLabel] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SkipGoPhrase] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SkipEndPhrase] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[QualiSysLanguage] [tinyint] NULL CONSTRAINT [DF_Languages_QualiSysLanguage]  DEFAULT (0),
 CONSTRAINT [PK_LANGUAGES] PRIMARY KEY NONCLUSTERED 
(
	[LangID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


