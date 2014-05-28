CREATE TABLE [dbo].[NewsBrief_Bak](
	[News_ID] [int] IDENTITY(1,1) NOT NULL,
	[Content] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Skip] [bit] NOT NULL,
	[Published] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[DateModified] [datetime] NULL,
	[PublishedBy] [int] NULL,
	[DatePublished] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


