CREATE TABLE [dbo].[Query](
	[Core] [int] NULL,
	[Description] [time](7) NULL,
	[Fielded] [smallint] NULL,
	[Scale] [int] NULL,
	[Short] [nvarchar](120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HeadID] [int] NULL,
	[FollowedBy] [int] NULL,
	[PrecededBy] [int] NULL,
	[AddedBy] [time](7) NULL,
	[AddedOn] [datetime] NULL,
	[ModifiedBy] [time](7) NULL,
	[ModifiedOn] [datetime] NULL,
	[ServID] [int] NULL,
	[ThemID] [int] NULL,
	[RestrictQuestion] [bit] NULL,
	[Tested] [bit] NULL,
	[Notes] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LevelQuest] [smallint] NULL,
	[Parent] [int] NULL,
	[FullText] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


