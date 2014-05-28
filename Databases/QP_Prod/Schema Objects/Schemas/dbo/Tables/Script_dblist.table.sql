CREATE TABLE [dbo].[Script_dblist](
	[seq] [int] IDENTITY(1,1) NOT NULL,
	[database_name] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[scriptbit] [bit] NULL DEFAULT (0),
	[bitTable] [bit] NULL DEFAULT (0),
	[bitView] [bit] NULL DEFAULT (0),
	[bitFunction] [bit] NULL DEFAULT (0),
	[bitProcedure] [bit] NULL DEFAULT (0),
	[bitDatabase] [bit] NULL DEFAULT (0),
	[bitJob] [bit] NULL DEFAULT (0),
	[bitIndex] [bit] NULL DEFAULT (0),
	[bitKey] [bit] NULL DEFAULT (0),
	[bitCheck] [bit] NULL DEFAULT (0),
	[bitTrigger] [bit] NULL DEFAULT (0)
) ON [PRIMARY]


