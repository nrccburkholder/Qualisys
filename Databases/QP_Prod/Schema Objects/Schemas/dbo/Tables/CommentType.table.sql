CREATE TABLE [dbo].[CommentType](
	[CommentType_ID] [int] IDENTITY(1,1) NOT NULL,
	[strCommentType_NM] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[bitCommentInterface] [bit] NULL
) ON [PRIMARY]


