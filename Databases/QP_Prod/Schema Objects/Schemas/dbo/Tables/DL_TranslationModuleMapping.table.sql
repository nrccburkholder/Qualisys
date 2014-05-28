CREATE TABLE [dbo].[DL_TranslationModuleMapping](
	[TranslationModuleMapping_ID] [int] IDENTITY(1,1) NOT NULL,
	[TranslationModule_ID] [int] NOT NULL,
	[OrigColumnName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[NRCColumnName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SchemaFormat] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TranslationModuleMapping_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]


