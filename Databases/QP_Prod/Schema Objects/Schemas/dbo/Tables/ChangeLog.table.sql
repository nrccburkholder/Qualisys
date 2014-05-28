CREATE TABLE [dbo].[ChangeLog](
	[ChangeLog_id] [int] IDENTITY(1,1) NOT NULL,
	[IDValue] [int] NOT NULL,
	[IDName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Property] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[OldValue] [varchar](3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NewValue] [varchar](3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datChanged] [datetime] NOT NULL,
	[ChangedBy] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ActionType] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]


