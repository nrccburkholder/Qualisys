/****** Object:  Table [dbo].[USPS_ACS_ExtractFile_PartialMatch]    Script Date: 9/23/2014 10:36:37 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[USPS_ACS_ExtractFile_PartialMatch](
	[USPS_ACS_ExtractFile_PartialMatch_id] [int] IDENTITY(1,1) NOT NULL,
	[Study_id] [int] NULL,
	[Pop_id] [int] NULL,
	[Status] [varchar](20) NULL,
	[FullMatch] [bit] NULL,
	[popFname] [varchar](42) NULL,
	[popLname] [varchar](42) NULL,
	[popAddr] [varchar](60) NULL,
	[popAddr2] [varchar](42) NULL,
	[popCity] [varchar](42) NULL,
	[popSt] [varchar](2) NULL,
	[popZip5] [varchar](5) NULL,
	[USPS_ACS_ExtractFile_Work_ID] [int] NOT NULL,
	[USPS_ACS_ExtractFile_ID] [int] NULL,
	[FName] [varchar](15) NULL,
	[LName] [varchar](20) NULL,
	[PrimaryNumberOld] [varchar](10) NULL,
	[PreDirectionalOld] [varchar](2) NULL,
	[StreetNameOld] [varchar](28) NULL,
	[StreetSuffixOld] [varchar](4) NULL,
	[PostDirectionalOld] [varchar](2) NULL,
	[UnitDesignatorOld] [varchar](4) NULL,
	[SecondaryNumberOld] [varchar](10) NULL,
	[CityOld] [varchar](28) NULL,
	[StateOld] [varchar](2) NULL,
	[Zip5Old] [varchar](5) NULL,
	[PrimaryNumberNew] [varchar](10) NULL,
	[PreDirectionalNew] [varchar](2) NULL,
	[StreetNameNew] [varchar](28) NULL,
	[StreetSuffixNew] [varchar](4) NULL,
	[PostDirectionalNew] [varchar](2) NULL,
	[UnitDesignatorNew] [varchar](4) NULL,
	[SecondaryNumberNew] [varchar](10) NULL,
	[CityNew] [varchar](28) NULL,
	[StateNew] [varchar](2) NULL,
	[Zip5New] [varchar](5) NULL,
	[Plus4ZipNew] [varchar](4) NULL,
	[AddressNew] [varchar](66) NULL,
	[Address2New] [varchar](14) NULL,
	[strLithocode] [varchar](10) NULL,
 CONSTRAINT [PK_USPS_ACS_ExtractFile_PartialMatch_id] PRIMARY KEY CLUSTERED 
(
	[USPS_ACS_ExtractFile_PartialMatch_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

