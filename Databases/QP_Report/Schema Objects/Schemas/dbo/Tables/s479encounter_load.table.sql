﻿CREATE TABLE [dbo].[s479encounter_load](
	[DischargeStatus] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AdmitTime] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NewRecordDate] [datetime] NULL,
	[FacilityNum] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DrID] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AdmitDate] [datetime] NULL,
	[DischargeDate] [datetime] NULL,
	[DischargeUnit] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PlanName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[VisitNum] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceDate] [datetime] NULL,
	[pop_id] [int] NULL,
	[enc_id] [int] IDENTITY(1,1) NOT NULL,
	[VisitType] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UtilizationCode] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceIndicator] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_2] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NetIncome] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DRG] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FinClass] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DepartmentName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DepartmentNum] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LengthOfStay] [int] NULL,
	[AdmitDrID] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AdmitSource] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RefDRID] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_3] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ICD9] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_7] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_8] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_9] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_10] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_11] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_12] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_13] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_14] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_15] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_16] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_17] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_18] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_19] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_20] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


