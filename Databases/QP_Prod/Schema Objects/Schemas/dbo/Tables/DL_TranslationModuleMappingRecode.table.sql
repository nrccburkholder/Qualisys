CREATE TABLE [dbo].[DL_TranslationModuleMappingRecode](
	[TranslationModuleMappingRecode_ID] [int] IDENTITY(1,1) NOT NULL,
	[TranslationModuleMapping_ID] [int] NOT NULL,
	[OrigValue] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[NewValue] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TranslationModuleMappingRecode_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]


