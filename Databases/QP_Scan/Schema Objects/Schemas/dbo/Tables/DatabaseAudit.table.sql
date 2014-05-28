CREATE TABLE [dbo].[DatabaseAudit](
	[AuditDate] [datetime] NOT NULL,
	[LoginName] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[EventType] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SchemaName] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ObjectName] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TSQLCommand] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[XMLEventData] [xml] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


