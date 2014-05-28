CREATE TABLE [dbo].[QueueManager](
	[RowNumber] [int] IDENTITY(1,1) NOT NULL,
	[EventClass] [int] NULL,
	[TextData] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NTUserName] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HostName] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientProcessID] [int] NULL,
	[ApplicationName] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LoginName] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SPID] [int] NULL,
	[Duration] [bigint] NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[Reads] [bigint] NULL,
	[Writes] [bigint] NULL,
	[CPU] [int] NULL,
	[DatabaseName] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED 
(
	[RowNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


