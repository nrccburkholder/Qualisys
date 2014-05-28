CREATE TABLE [dbo].[QuestionsFromParadox2](
	[Core] [int] NULL,
	[Description] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Fielded] [smallint] NULL,
	[Scale] [int] NULL,
	[Short] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HeadID] [int] NULL,
	[FollowedBy] [int] NULL,
	[PrecededBy] [int] NULL,
	[AddedBy] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddedOn] [smalldatetime] NULL,
	[ModifiedBy] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ModifiedOn] [smalldatetime] NULL,
	[ServID] [int] NULL,
	[ThemID] [int] NULL,
	[RestrictQuestion] [bit] NOT NULL,
	[Tested] [bit] NOT NULL,
	[Notes] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LevelQuest] [smallint] NULL,
	[Parent] [int] NULL,
	[FullText] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


