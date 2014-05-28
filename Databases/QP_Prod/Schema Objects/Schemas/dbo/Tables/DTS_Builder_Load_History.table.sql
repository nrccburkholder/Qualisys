CREATE TABLE [dbo].[DTS_Builder_Load_History](
	[Load_ID] [int] IDENTITY(1,1) NOT NULL,
	[TeamNumber] [varchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Study_ID] [varchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Project_ID] [varchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientName] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientShortName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[ExpectedRecordCount] [int] NULL,
	[ActualRecordCount] [int] NULL,
	[LoadTablesCleared] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LoadTimeInSeconds] [float] NULL,
	[ComputerName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UserName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InputFilePath] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ArchiveFilePath] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ErrorNumber] [int] NULL,
	[ErrorDescription] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ErrorSource] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MinEncounterDate] [datetime] NULL,
	[MaxEncounterDate] [datetime] NULL
) ON [PRIMARY]


