CREATE TABLE [dbo].[NewsBrief](
	[News_ID] [int] IDENTITY(1,1) NOT NULL,
	[Content] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Skip] [bit] NOT NULL,
	[Published] [bit] NOT NULL CONSTRAINT [DF_NewsBrief_Published]  DEFAULT (0),
	[CreatedBy] [int] NOT NULL,
	[DateCreated] [datetime] NOT NULL CONSTRAINT [DF__NewsBrief__DateC__092A4EB5]  DEFAULT (getdate()),
	[ModifiedBy] [int] NULL,
	[DateModified] [datetime] NULL,
	[PublishedBy] [int] NULL,
	[DatePublished] [datetime] NULL,
 CONSTRAINT [PK__NewsBrief__08362A7C] PRIMARY KEY CLUSTERED 
(
	[News_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


