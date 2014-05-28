CREATE TABLE [dbo].[ZIPCodes](
	[ZIPCode] [char](5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ZIPCodeType] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[City] [varchar](28) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CityType] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[County] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CountyFIPS] [char](5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[State] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[StateCode] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[StateFIPS] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MSA] [char](4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AreaCode] [char](3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TimeZone] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[GMTOffset] [smallint] NOT NULL,
	[DST] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Latitude] [decimal](8, 6) NOT NULL,
	[Longitude] [decimal](9, 6) NOT NULL
) ON [PRIMARY]


