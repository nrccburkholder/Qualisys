CREATE TABLE [dbo].[dc_facilityInfo](
	[AHA_ID] [int] NULL,
	[sampleunit_id] [int] NULL,
	[HospitalName] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[city] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[state] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Country] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[region] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ControlledBy] [varchar](26) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Admissions] [int] NULL,
	[BedSize] [int] NULL,
	[TraumaHospital] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TraumaLevel] [int] NULL,
	[Government] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ForProfit] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReligiousAffiliation] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Teaching] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RURAL] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CATHOLIC] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


