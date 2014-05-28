﻿CREATE TABLE [dbo].[Billians_AssistedLivingFacility](
	[Directory Code] [nvarchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Name] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Former Name] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Memo Line] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Street Address] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mail Address] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State] [nvarchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Street Zip] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mail Zip] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[County] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Fax] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[800 Number] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Website] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[General Facility Email] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[System Type] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Environmental Services Contract] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Food Services Contract] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Non-Reporting] [nvarchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[New ALF] [nvarchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Date Closed] [nvarchar](12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Non-Count] [nvarchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Total Beds] [float] NULL,
	[Total Units] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Private Beds] [nvarchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Medicare Beds] [nvarchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Medicaid Beds] [nvarchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ALF Care] [nvarchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Alzheimers Care] [nvarchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Sheltered Care] [nvarchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Personal Care] [nvarchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Residential Care] [nvarchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Independent Care] [nvarchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Latitude] [float] NULL,
	[Longitude] [float] NULL,
	[FIPS County] [nvarchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MSA] [nvarchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MSA Description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


