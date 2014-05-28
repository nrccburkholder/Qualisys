CREATE TABLE [dbo].[PUR_Report](
	[PUReport_ID] [int] IDENTITY(1,1) NOT NULL,
	[PU_ID] [int] NOT NULL,
	[DueDate] [datetime] NOT NULL,
	[Status] [tinyint] NOT NULL CONSTRAINT [DF__PUR_Repor__Statu__1FEDB87C]  DEFAULT (1),
	[ActivityBeginDate] [datetime] NOT NULL,
	[UiActivityEndDate] [datetime] NOT NULL,
	[ActivityEndDate] [datetime] NULL,
	[RRDetail] [tinyint] NOT NULL CONSTRAINT [DF__PUR_Repor__RRDet__20E1DCB5]  DEFAULT (1),
	[News_ID] [int] NULL,
	[UseWebAccount] [bit] NOT NULL CONSTRAINT [DF_PUR_Report_UseWebAccount]  DEFAULT (0),
	[CreatedBy] [int] NOT NULL,
	[DateCreated] [datetime] NOT NULL CONSTRAINT [DF__PUR_Repor__DateC__21D600EE]  DEFAULT (getdate()),
	[ModifiedBy] [int] NULL,
	[DateModified] [datetime] NULL,
	[GeneratedBy] [int] NULL,
	[DateGenerated] [datetime] NULL,
	[PostedBy] [int] NULL,
	[DatePosted] [datetime] NULL,
	[SkippedBy] [int] NULL,
	[DateSkipped] [datetime] NULL,
 CONSTRAINT [PK__PUR_Report__1EF99443] PRIMARY KEY CLUSTERED 
(
	[PUReport_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


