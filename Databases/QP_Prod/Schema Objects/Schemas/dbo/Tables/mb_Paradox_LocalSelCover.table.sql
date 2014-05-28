CREATE TABLE [dbo].[mb_Paradox_LocalSelCover](
	[Survey_ID] [int] NULL,
	[SelCover_ID] [int] NULL,
	[PageType] [int] NULL,
	[Type] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Description] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Integrated] [bit] NOT NULL,
	[bitLetterHead] [bit] NOT NULL
) ON [PRIMARY]


