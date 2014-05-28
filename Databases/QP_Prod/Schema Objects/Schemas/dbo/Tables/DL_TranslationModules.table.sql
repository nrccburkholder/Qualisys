CREATE TABLE [dbo].[DL_TranslationModules](
	[TranslationModule_ID] [int] IDENTITY(1,1) NOT NULL,
	[Vendor_ID] [int] NOT NULL,
	[ModuleName] [varchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WatchedFolderPath] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FileType] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Study_ID] [int] NULL,
	[Survey_ID] [int] NULL,
	[LithoLookupType_id] [int] NOT NULL DEFAULT ((0)),
 CONSTRAINT [PK_DL_TranslationModules] PRIMARY KEY CLUSTERED 
(
	[TranslationModule_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


