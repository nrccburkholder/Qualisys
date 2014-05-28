CREATE TABLE [dbo].[CommentTemp](
	[ExtractFileID] [int] NOT NULL,
	[LithoCode] [int] NOT NULL,
	[SAMPLEUNIT_ID] [int] NOT NULL,
	[CMNT_ID] [int] NOT NULL,
	[nrcQuestionCore] [int] NOT NULL,
	[commentType] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[commentValence] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[isSuppressedOnWeb] [nvarchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datEntered] [datetime] NULL
) ON [PRIMARY]


