CREATE TABLE [dbo].[pop1000_load](
	[Sex] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Age] [int] NULL,
	[NewRecordDate] [datetime] NULL,
	[LangID] [int] NULL,
	[pop_id] [int] IDENTITY(1,1) NOT NULL,
	[Addr] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ST] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ZIP5] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddrStat] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddrErr] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Zip4] [varchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Del_Pt] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Province] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Postal_Code] [varchar](7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NameStat] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MRN] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PIN_NUM] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Pop_Mtch] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Pop_Mtch_Err] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UnitName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


