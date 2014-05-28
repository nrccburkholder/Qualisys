CREATE TABLE [dbo].[WebPref_ChangeAddress_ParamLog](
	[log_id] [int] IDENTITY(1,1) NOT NULL,
	[log_dt] [datetime] NULL,
	[litho] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Disposition_id] [int] NULL,
	[Addr] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Addr2] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Del_pt] [char](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ST] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Zip4] [char](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ZIP5] [char](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddrStat] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddrErr] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


