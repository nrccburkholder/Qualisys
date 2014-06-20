﻿CREATE TABLE [dbo].[DavidQueryResults](
	[Country_ID] [int] NULL,
	[Client_ID] [int] NULL,
	[Study_ID] [int] NULL,
	[Survey_ID] [int] NULL,
	[strClient_NM] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PARENTSAMPLEUNIT_ID] [int] NULL,
	[SampleUnit_ID] [int] NULL,
	[STRSAMPLEUNIT_NM] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SUFacility_id] [int] NULL,
	[strFacility_nm] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MedicareNumber] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BedSize] [int] NULL,
	[bitPicker] [int] NULL,
	[bitPeds] [int] NULL,
	[bitTeaching] [int] NULL,
	[bitTrauma] [int] NULL,
	[bitReligious] [int] NULL,
	[bitGovernment] [int] NULL,
	[bitRural] [int] NULL,
	[bitForProfit] [int] NULL,
	[bitRehab] [int] NULL,
	[bitCancerCenter] [int] NULL,
	[bitFreeStanding] [int] NULL,
	[Region_id] [int] NULL,
	[State] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SamplePop_ID] [int] NULL,
	[bitComplete] [int] NULL,
	[datReturned] [datetime] NULL,
	[QstnCore] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[intResponseVal] [int] NULL,
	[DOB] [datetime] NULL,
	[DRG] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MSDRG] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Sex] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DischargeDate] [datetime] NULL,
	[Age] [int] NULL
) ON [PRIMARY]

