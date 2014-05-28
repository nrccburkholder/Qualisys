CREATE TABLE [dbo].[Norms_FacilitiesbyService](
	[client] [varchar](73) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AHA_ID] [int] NULL,
	[HospitalName] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[city] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[state] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Country] [varchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[region] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Admissions] [int] NULL,
	[BedSize] [int] NULL,
	[BedSizeGroups] [varchar](7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TraumaHospital] [bit] NULL,
	[Government] [bit] NULL,
	[ForProfit] [bit] NULL,
	[ReligiousAffiliation] [bit] NULL,
	[Teaching] [bit] NULL,
	[RURAL] [bit] NULL,
	[service_id] [int] NULL,
	[service_name] [varchar](84) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PickervsLegacy] [varchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


