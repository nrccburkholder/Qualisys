CREATE TABLE [dbo].[CommentTextTempError](
	[ExtractFileID] [int] NOT NULL,
	[LithoCode] [int] NOT NULL,
	[Cmnt_id] [int] NOT NULL,
	[IsMasked] [bit] NOT NULL,
	[BlockNum] [int] NOT NULL,
	[BlockData] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]


