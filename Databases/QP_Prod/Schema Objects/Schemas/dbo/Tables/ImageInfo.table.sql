CREATE TABLE [dbo].[ImageInfo](
	[ImageID] [int] IDENTITY(1,1) NOT NULL,
	[Barcode] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LithoCode] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CDLabel] [varchar](12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PaperSize] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BatchNumber] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[GroupNumber] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ImageFileName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_ImageInfo_1] PRIMARY KEY NONCLUSTERED 
(
	[ImageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


