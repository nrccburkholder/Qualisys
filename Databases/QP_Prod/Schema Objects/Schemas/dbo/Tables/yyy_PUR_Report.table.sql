CREATE TABLE [dbo].[yyy_PUR_Report](
	[PUReport_ID] [int] IDENTITY(1,1) NOT NULL,
	[PU_ID] [int] NOT NULL,
	[DueDate] [datetime] NOT NULL,
	[Status] [tinyint] NOT NULL,
	[ActivityBeginDate] [datetime] NOT NULL,
	[UiActivityEndDate] [datetime] NOT NULL,
	[ActivityEndDate] [datetime] NULL,
	[RRDetail] [tinyint] NOT NULL,
	[News_ID] [int] NULL,
	[UseWebAccount] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[DateModified] [datetime] NULL,
	[GeneratedBy] [int] NULL,
	[DateGenerated] [datetime] NULL,
	[PostedBy] [int] NULL,
	[DatePosted] [datetime] NULL,
	[SkippedBy] [int] NULL,
	[DateSkipped] [datetime] NULL
) ON [PRIMARY]


