﻿CREATE TABLE [dbo].[s562popload](
	[MRN] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Middle] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Addr] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ST] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ZIP5] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DOB] [datetime] NULL,
	[Sex] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Marital] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddrStat] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddrErr] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Zip4] [varchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NewRecordDate] [datetime] NULL,
	[LangID] [int] NULL,
	[Del_Pt] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GuarFirstName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GuarMiddle] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GuarLastName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Race] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FinClass] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GuarAddr] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GuarCity] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GuarSex] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GuarState] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GuarZip5] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PlanNumber] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PHONSTAT] [int] NULL,
	[AreaCode] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Employer] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GuarRelation] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_11] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_13] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PLANNUM2] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PLANNUM3] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Addr2] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GuarZip4] [varchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GuarDel_Pt] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GuarAddrStat] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GuarAddrErr] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NameStat] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GuarNameStat] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Age] [int] NULL,
	[Pop_Mtch] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Pop_Mtch_Err] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_34] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_35] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Zip5_Foreign] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[pop_id] [int] NOT NULL,
	[GuarAddr2] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


