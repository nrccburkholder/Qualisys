CREATE TABLE [dbo].[BLOCKKILL_LOG](
	[spid] [int] NULL,
	[status] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[login] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[hostname] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[blkby] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[dbname] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[command] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cputime] [int] NULL,
	[diskio] [int] NULL,
	[lastbatch] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[programname] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[spid2] [int] NULL,
	[KillDate] [datetime] NULL
) ON [PRIMARY]


