CREATE TABLE [dbo].[CommentValences](
	[CmntValence_id] [int] NOT NULL,
	[strCmntValence_Nm] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[bitRetired] [bit] NOT NULL CONSTRAINT [DF_CommentValences_bitRetired]  DEFAULT (0),
 CONSTRAINT [PK_CommentValences] PRIMARY KEY NONCLUSTERED 
(
	[CmntValence_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


