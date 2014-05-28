CREATE TABLE [dbo].[s76popload](
	[NewRecordDate] [datetime] NULL,
	[LangID] [int] NULL,
	[pop_id] [int] NOT NULL,
	[Zip5] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddrErr] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ST] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddrStat] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Zip4] [varchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Addr] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Del_Pt] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DepartmentNum] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DOB] [datetime] NULL,
	[FacilityNum] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DrFirstName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DrLastName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Age] [int] NULL,
	[Sex] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DrSpec] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DrID] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Title] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceIndicator] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NameStat] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


