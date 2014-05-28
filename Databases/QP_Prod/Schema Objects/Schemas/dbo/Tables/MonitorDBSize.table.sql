CREATE TABLE [dbo].[MonitorDBSize](
	[MonitorDBSize_id] [int] IDENTITY(1,1) NOT NULL,
	[datMonitored] [datetime] NULL,
	[DBName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SizeInMB] [int] NULL,
	[DriveLetter] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


