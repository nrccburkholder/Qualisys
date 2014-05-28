CREATE TABLE [dbo].[DL_DataLoad](
	[DataLoad_ID] [int] IDENTITY(1,1) NOT NULL,
	[Vendor_ID] [int] NULL,
	[TranslationModule_ID] [int] NULL,
	[DisplayName] [varchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OrigFileName] [varchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrentFilePath] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DateLoaded] [datetime] NULL,
	[bitShowInTree] [bit] NULL CONSTRAINT [DF_DL_dataLoad_bitShowInTree]  DEFAULT (1),
	[TotalRecordsLoaded] [int] NULL,
	[TotalDispositionUpdateRecords] [int] NULL,
	[DateCreated] [datetime] NULL CONSTRAINT [DF_DL_dataLoad_DateCreated]  DEFAULT (getdate()),
 CONSTRAINT [PK_DL_dataLoad] PRIMARY KEY CLUSTERED 
(
	[DataLoad_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


