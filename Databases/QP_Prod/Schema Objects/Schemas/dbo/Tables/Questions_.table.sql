CREATE TABLE [dbo].[Questions$](
	[Core] [float] NULL,
	[Description] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Fielded] [float] NULL,
	[Scale] [float] NULL,
	[Short] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HeadID] [float] NULL,
	[FollowedBy] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PrecededBy] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddedBy] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddedOn] [datetime] NULL,
	[ModifiedBy] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ModifiedOn] [datetime] NULL,
	[ServID] [float] NULL,
	[ThemID] [float] NULL,
	[RestrictQuestion] [bit] NOT NULL,
	[Tested] [bit] NOT NULL,
	[LevelQuest] [float] NULL,
	[Parent] [float] NULL,
	[FullText] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


