CREATE TABLE [dbo].[ContractedLanguages](
	[LanguageCode] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LanguageName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LangID] [int] NULL,
	[DisplayOrder] [smallint] NOT NULL,
 CONSTRAINT [PK_ContractedLanguages] PRIMARY KEY CLUSTERED 
(
	[LanguageCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


