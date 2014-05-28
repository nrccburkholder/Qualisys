CREATE TABLE [dbo].[ErrorLog](
	[ErrorLogID] [int] IDENTITY(1,1) NOT NULL,
	[PackageLogID] [int] NULL,
	[PackageName] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TaskName] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PrcocedureName] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ErrorCode] [bigint] NULL,
	[ErrorMsg] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PackageDuration] [int] NULL,
	[ContainerDuration] [int] NULL,
	[ErrorDate] [datetime] NULL CONSTRAINT [DF_ErrorLog_ErrorDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_ErrorLog] PRIMARY KEY CLUSTERED 
(
	[ErrorLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


