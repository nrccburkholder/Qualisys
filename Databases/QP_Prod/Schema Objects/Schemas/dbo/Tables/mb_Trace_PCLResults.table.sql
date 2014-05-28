CREATE TABLE [dbo].[mb_Trace_PCLResults](
	[RowNumber] [int] IDENTITY(0,1) NOT NULL,
	[EventClass] [int] NULL,
	[TextData] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ApplicationName] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NTUserName] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LoginName] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CPU] [int] NULL,
	[Reads] [bigint] NULL,
	[Writes] [bigint] NULL,
	[Duration] [bigint] NULL,
	[ClientProcessID] [int] NULL,
	[SPID] [int] NULL,
	[StartTime] [datetime] NULL,
	[DatabaseID] [int] NULL,
	[Error] [int] NULL,
	[EventSubClass] [int] NULL,
	[HostName] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LoginSid] [image] NULL,
	[NTDomainName] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServerName] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Severity] [int] NULL,
	[State] [int] NULL,
	[EndTime] [datetime] NULL,
	[NestLevel] [int] NULL,
	[ObjectID] [int] NULL,
	[ObjectType] [int] NULL,
	[DatabaseName] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IntegerData] [int] NULL,
	[TransactionID] [bigint] NULL,
	[BinaryData] [image] NULL,
	[ObjectName] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED 
(
	[RowNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


