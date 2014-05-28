CREATE TABLE [dbo].[ConcurrencyLock](
	[ConcurrencyLock_id] [int] IDENTITY(1,1) NOT NULL,
	[LockCategory_id] [int] NULL,
	[LockValue_id] [int] NULL,
	[UserName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MachineName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProcessName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AcquisitionTime] [datetime] NULL,
	[ExpirationTime] [datetime] NULL
) ON [PRIMARY]


