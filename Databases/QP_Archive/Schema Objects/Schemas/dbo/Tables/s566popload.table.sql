CREATE TABLE [dbo].[s566popload](
	[MRN] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Addr] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ST] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ZIP5] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DOB] [datetime] NULL,
	[Sex] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Marital] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Age] [int] NULL,
	[AddrStat] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddrErr] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Zip4] [varchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NewRecordDate] [datetime] NULL,
	[LangID] [int] NULL,
	[Del_Pt] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Race] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[pop_id] [int] NOT NULL,
	[NameStat] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AreaCode] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PHONSTAT] [int] NULL,
	[Zip5_Foreign] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


