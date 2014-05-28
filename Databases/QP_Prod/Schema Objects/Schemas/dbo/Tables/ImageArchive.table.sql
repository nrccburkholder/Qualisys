CREATE TABLE [dbo].[ImageArchive](
	[lImageID] [int] IDENTITY(1,1) NOT NULL,
	[sBarcode] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sLithoCode] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_ImageInfo_LithoCode]  DEFAULT (0),
	[sArchiveLabel] [varchar](12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sTemplateLabel] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sBatchLabel] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sFileName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[dtArchiveDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ImageInfo] PRIMARY KEY NONCLUSTERED 
(
	[lImageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


