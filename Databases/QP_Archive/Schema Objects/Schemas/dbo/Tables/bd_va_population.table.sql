﻿CREATE TABLE [dbo].[bd_va_population](
	[litho] [int] NULL,
	[LNAME] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FNAME] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MIDDLE] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ADDR] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CITY] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ST] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ZIP5] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DOB] [datetime] NULL,
	[SEX] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AGE] [int] NULL,
	[ADDRSTAT] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ADDRERR] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ZIP4] [varchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NEWDATE] [datetime] NULL,
	[LANGID] [int] NULL,
	[DEL_PT] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FACNUM] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SSN] [varchar](9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DISDATE] [datetime] NULL,
	[DISUNIT] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FACNAME] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SERDATE] [datetime] NULL,
	[pop_id] [int] NULL,
	[VISTYPE] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UTILCODE] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SERVICE1] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SERVICE4] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SERVICE9] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SERV10] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SERV11] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SERV12] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SERV13] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SERV14] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SERV15] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SERV17] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SERV20] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SERV21] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SERV30] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SERV31] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SERV32] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Country] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UnitName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MBR_TYPE] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SVY_TYPE] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SVC_AREA] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Addr2] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HOSP_ID] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NameStat] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Serv33] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Serv34] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Serv35] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[VISN] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SampWt] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RespWt] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TOCL] [int] NULL,
	[TestInd] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WebRtn] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Serv36] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


