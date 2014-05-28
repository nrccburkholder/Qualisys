CREATE TABLE [dbo].[LockedModules](
	[UserName] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Table_nm] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Group_id] [int] NULL,
	[Module] [varchar](75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DATLocked_DT] [smalldatetime] NULL
) ON [PRIMARY]


