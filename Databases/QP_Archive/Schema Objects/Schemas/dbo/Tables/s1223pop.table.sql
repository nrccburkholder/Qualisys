﻿CREATE TABLE [dbo].[s1223pop](
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
	[SSN] [varchar](9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Suffix] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConsultDrID] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PlanName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PlanEnrollCode] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[pop_id] [int] NOT NULL,
	[MemberID] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceIndicator] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Restriction] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_2] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_3] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RoomNum] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BenefitPkg] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_16] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_19] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_21] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_22] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_23] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_29] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_30] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_31] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Country] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RankName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Service] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Region] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BeneficiaryGrp] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Children] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PLANNUM2] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PLANNUM3] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PLANNUM4] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConsultDRID2] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConsultDRID3] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PlanName2] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FLAG_FIN] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Addr2] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddrAlt1] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Adr2Alt1] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CityAlt1] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[STAlt1] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Zip5Alt1] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Zip4Alt1] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddrAlt2] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Adr2Alt2] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CityAlt2] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[STAlt2] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Zip5Alt2] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Zip4Alt2] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddrAlt3] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CityAlt3] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[STAlt3] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Zip5Alt3] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Zip4Alt3] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddrErrA1] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddrErrA2] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddrErrA3] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddrStatA1] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddrStatA2] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddrStatA3] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Del_PtA1] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Del_PtA2] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Del_PtA3] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NameStat] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Province] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Postal_Code] [varchar](7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_35] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClinicName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClinicNum] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DMISID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FinClass] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GuarSSN] [varchar](9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mbrtype] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MRN] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Race] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RankNum] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RegionCustom] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_10] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_11] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_12] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_13] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_14] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_15] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_18] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_20] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_24] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_25] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_26] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_27] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_28] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_5] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInd_6] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]

