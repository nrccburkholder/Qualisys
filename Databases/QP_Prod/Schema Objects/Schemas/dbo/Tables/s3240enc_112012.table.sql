﻿CREATE TABLE [dbo].[s3240enc_112012](
	[NewRecordDate] [datetime] NULL,
	[AdmitSource] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DischargeDate] [datetime] NULL,
	[ICD9] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ICD9_2] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ICD9_3] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceDate] [datetime] NULL,
	[pop_id] [int] NULL,
	[enc_id] [int] NOT NULL,
	[VisitType] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_2] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_3] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_4] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_5] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_6] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_7] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_8] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_9] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_10] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_11] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ICD9_4] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ICD9_5] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ICD9_6] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ICD9_7] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ICD9_8] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ICD9_9] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ICD9_10] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ICD9_11] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ICD9_12] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ICD9_13] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ICD9_14] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ICD9_15] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ICD9_16] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Enc_Mtch] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ICD9_17] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ICD9_18] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NPI] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHAgencyNm] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHSampleMonth] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHSampleYear] [varchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHPatServed] [int] NULL,
	[HHPatInFile] [int] NULL,
	[HHVisitCnt] [int] NULL,
	[HHLookbackCnt] [int] NULL,
	[HHAdm_Hosp] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHAdm_Rehab] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHAdm_SNF] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHAdm_OthLTC] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHAdm_OthIP] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHAdm_Comm] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHPay_Mcare] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHPay_Mcaid] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHPay_Ins] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHPay_Other] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHHMO] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHDual] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHSurg] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHESRD] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHADL_Deficit] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHADL_DressUp] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHADL_DressLow] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHADL_Bath] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHADL_Toilet] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHADL_Transfer] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHADL_Feed] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHBranchNum] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHEOMAge] [int] NULL,
	[HHCatAge] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHMaternity] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHHospice] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHDeceased] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHDischargeStat] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHNQL] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHOASISPatID] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHSOCDate] [datetime] NULL,
	[HHAssesReason] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CCN] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Enc_mtch_Val] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


