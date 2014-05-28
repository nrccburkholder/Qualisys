CREATE TABLE [dbo].[Scriptlist](
	[SEQ] [int] IDENTITY(1,1) NOT NULL,
	[ObjectType] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ObjectSubType] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServerName] [varchar](130) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DBName] [varchar](130) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OwnerName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ObjectName] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TableName] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ScriptFile] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[id] [int] NULL,
	[uid] [smallint] NULL,
	[name] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[xtype] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[schema_ver] [int] NULL,
	[tiScript] [tinyint] NULL,
	[bitAddedVSS] [bit] NULL CONSTRAINT [DF__Scriptlis__bitAd__786FC5CD]  DEFAULT (0),
	[script_dt] [datetime] NULL
) ON [PRIMARY]


