CREATE TABLE [dbo].[PU_Plan](
	[PU_ID] [int] IDENTITY(1,1) NOT NULL,
	[Team_ID] [int] NOT NULL,
	[PuName] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PuDescription] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Client_ID] [int] NOT NULL,
	[Frequency] [tinyint] NOT NULL CONSTRAINT [DF__PU_Plan__Frequen__0FB750B3]  DEFAULT (1),
	[ReportDay] [tinyint] NOT NULL CONSTRAINT [DF__PU_Plan__ReportD__10AB74EC]  DEFAULT (6),
	[NRCContact] [int] NOT NULL,
	[MailFrom] [int] NOT NULL,
	[Logo] [tinyint] NOT NULL CONSTRAINT [DF__PU_Plan__Logo__119F9925]  DEFAULT (4),
	[ShowNewsBrief] [bit] NOT NULL CONSTRAINT [DF_PU_Plan_ShowNewsBrief]  DEFAULT (1),
	[TitleType] [tinyint] NOT NULL CONSTRAINT [DF_PU_Plan_TitleType]  DEFAULT (1),
	[LastDueDate] [datetime] NULL,
	[LastUpdateSent] [datetime] NULL,
	[LastPUReport_ID] [int] NULL,
	[NextDueDate] [datetime] NOT NULL,
	[NextPUReport_ID] [int] NULL,
	[Status] [tinyint] NOT NULL CONSTRAINT [DF__PU_Plan__Status__1293BD5E]  DEFAULT (0),
	[CreatedBy] [int] NOT NULL,
	[DateCreated] [datetime] NOT NULL CONSTRAINT [DF__PU_Plan__DateCre__1387E197]  DEFAULT (getdate()),
	[ModifiedBy] [int] NULL,
	[DateModified] [datetime] NULL,
	[StartOverBy] [int] NULL,
	[DateStartOver] [datetime] NULL,
	[DeletedBy] [int] NULL,
	[DateDeleted] [datetime] NULL,
 CONSTRAINT [PK__PU_Plan__0EC32C7A] PRIMARY KEY CLUSTERED 
(
	[PU_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


