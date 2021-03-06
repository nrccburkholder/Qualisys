﻿CREATE TABLE [dbo].[Stephanie911_a](
	[SampSet] [int] NULL,
	[Samp_dt] [datetime] NULL,
	[SampUnit] [int] NULL,
	[Unit_nm] [char](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SampType] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SampPop] [int] NULL,
	[QstnForm] [int] NULL,
	[lithocd] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Rtrn_dt] [datetime] NULL,
	[Undel_dt] [datetime] NULL,
	[MRN] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ADMTTIME] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LNAME] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FNAME] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ADDR] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CITY] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ST] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ZIP5] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SEX] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AGE] [int] NULL,
	[DRG] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NEWFLAG] [int] NULL,
	[ADDRSTAT] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ADDRERR] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ZIP4] [varchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NEWDATE] [datetime] NULL,
	[LANGID] [int] NULL,
	[DEL_PT] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FACNUM] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GFNAME] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GLNAME] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DRID] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ADMTDATE] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FINCLASS] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DISDATE] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DISUNIT] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ICD9] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PHONE] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PLANNAME] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[VISITNUM] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DRSPEC] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ICD9_2] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ICD9_3] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CLINICNM] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FACNAME] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SERDATE] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DRLNAME] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DRFNAME] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PHONSTAT] [int] NULL,
	[pop_id] [int] NULL,
	[enc_id] [int] NULL,
	[AREACODE] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[VISTYPE] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SERVICE1] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ICD9_4] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UnitNum] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PLANTYPE] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Flag_Pik] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HOSP_ID] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StratVar] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NameStat] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DrNmStat] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[clncnmid] [int] NULL,
	[q008562] [int] NULL,
	[q008563] [int] NULL,
	[q008564] [int] NULL,
	[q008565] [int] NULL,
	[q008566] [int] NULL,
	[q008567] [int] NULL,
	[q008568] [int] NULL,
	[q008569] [int] NULL,
	[q008570] [int] NULL,
	[q008571] [int] NULL,
	[q008608] [int] NULL,
	[q008572] [int] NULL,
	[q008609] [int] NULL,
	[q008610] [int] NULL,
	[q008611] [int] NULL,
	[q008612] [int] NULL,
	[q008613] [int] NULL,
	[q008575] [int] NULL,
	[q008614] [int] NULL,
	[q008615] [int] NULL,
	[q008616] [int] NULL,
	[q008617] [int] NULL,
	[q008576] [int] NULL,
	[q008577] [int] NULL,
	[q008579] [int] NULL,
	[q008578] [int] NULL,
	[q008580] [int] NULL,
	[q008581] [int] NULL,
	[q008582] [int] NULL,
	[q008583] [int] NULL,
	[q008587] [int] NULL,
	[q008618] [int] NULL,
	[q008631] [int] NULL,
	[q008619] [int] NULL,
	[q008584] [int] NULL,
	[q008585] [int] NULL,
	[q008588] [int] NULL,
	[q008589] [int] NULL,
	[q008590] [int] NULL,
	[q008591] [int] NULL,
	[q008592] [int] NULL,
	[q008593] [int] NULL,
	[q008594] [int] NULL,
	[q008595] [int] NULL,
	[q008596] [int] NULL,
	[q008597] [int] NULL,
	[q008598] [int] NULL,
	[q008599] [int] NULL,
	[q008620] [int] NULL,
	[q008621] [int] NULL,
	[q008600] [int] NULL,
	[q008622] [int] NULL,
	[q008623] [int] NULL,
	[q008624] [int] NULL,
	[q008625] [int] NULL,
	[q008626] [int] NULL,
	[q008627] [int] NULL,
	[q008628] [int] NULL,
	[q008629] [int] NULL,
	[q008630] [int] NULL,
	[q008229] [int] NULL,
	[q008230] [int] NULL,
	[q008231] [int] NULL,
	[q008232] [int] NULL,
	[q008233] [int] NULL,
	[q008234] [int] NULL,
	[q008235] [int] NULL,
	[q008236] [int] NULL,
	[q008237] [int] NULL,
	[q008238] [int] NULL,
	[q008239] [int] NULL,
	[q008240] [int] NULL,
	[q008241] [int] NULL,
	[q008242] [int] NULL,
	[q008243] [int] NULL,
	[q008326] [int] NULL,
	[q008244] [int] NULL,
	[q008245] [int] NULL,
	[q008246] [int] NULL,
	[q008327] [int] NULL,
	[q008328] [int] NULL,
	[q008329] [int] NULL,
	[q008248] [int] NULL,
	[q008247] [int] NULL,
	[q008249] [int] NULL,
	[q008250] [int] NULL,
	[q008251] [int] NULL,
	[q008284] [int] NULL,
	[q008252] [int] NULL,
	[q008253] [int] NULL,
	[q008254] [int] NULL,
	[q008255] [int] NULL,
	[q008256] [int] NULL,
	[q008257] [int] NULL,
	[q008258] [int] NULL,
	[q008259] [int] NULL,
	[q008260] [int] NULL,
	[q008261] [int] NULL,
	[q008262] [int] NULL,
	[q008263] [int] NULL,
	[q008264] [int] NULL,
	[q008266] [int] NULL,
	[q008267] [int] NULL,
	[q008268] [int] NULL,
	[q008269] [int] NULL,
	[q008271] [int] NULL,
	[q008272] [int] NULL,
	[q008273] [int] NULL,
	[q008331] [int] NULL,
	[q008274] [int] NULL,
	[q008275] [int] NULL,
	[q008276a] [int] NULL,
	[q008276b] [int] NULL,
	[q008276c] [int] NULL,
	[q008276d] [int] NULL,
	[q008276e] [int] NULL,
	[q008276f] [int] NULL,
	[q008276g] [int] NULL,
	[q008285] [int] NULL,
	[q008286] [int] NULL,
	[q008277] [int] NULL,
	[q008287] [int] NULL
) ON [PRIMARY]


