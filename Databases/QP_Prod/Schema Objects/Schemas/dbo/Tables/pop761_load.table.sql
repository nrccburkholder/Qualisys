﻿CREATE TABLE [dbo].[pop761_load](
	[MRN] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Middle] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Addr] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
	[GuarFirstName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GuarMiddle] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GuarLastName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Suffix] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Title] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Race] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FinClass] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GuarAddr] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GuarCity] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GuarSex] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GuarState] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GuarTitle] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GuarZip5] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PlanNumber] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PHONSTAT] [int] NULL,
	[pop_id] [int] IDENTITY(1,1) NOT NULL,
	[AreaCode] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Employer] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GuarSuffix] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GuarRelation] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GuarZip4] [varchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GuarDel_Pt] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GuarAddrStat] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GuarAddrErr] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NameStat] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GuarNameStat] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


