CREATE TABLE [dbo].[BackgroundTemp](
	[ExtractFileID] [int] NOT NULL,
	[SAMPLEPOP_ID] [int] NOT NULL,
	[name] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[value] [nvarchar](3000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sourcetable] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]


