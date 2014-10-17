/****** Object:  Table [dbo].[USPS_ACS_ExtractFile_Work]    Script Date: 8/21/2014 10:55:15 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO


CREATE TABLE [dbo].[USPS_ACS_ExtractFile_Work](
	[USPS_ACS_ExtractFile_Work_ID] [int] IDENTITY(1,1) NOT NULL,
	[USPS_ACS_ExtractFile_ID] [int],
	FName varchar(15),
	LName varchar(20),
	PrimaryNumberOld varchar(10),
	PreDirectionalOld varchar(2),
	StreetNameOld varchar(28),
	StreetSuffixOld varchar(4),
	PostDirectionalOld varchar(2),
	UnitDesignatorOld varchar(4),
	SecondaryNumberOld varchar(10),
	CityOld varchar(28),
	StateOld varchar(2),
	Zip5Old varchar(5),
	PrimaryNumberNew varchar(10),
	PreDirectionalNew varchar(2),
	StreetNameNew varchar(28),
	StreetSuffixNew varchar(4),
	PostDirectionalNew varchar(2),
	UnitDesignatorNew varchar(4),
	SecondaryNumberNew varchar(10),
	CityNew varchar(28),
	StateNew varchar(2),
	Zip5New varchar(5),
	Plus4ZipNew varchar(4),
	AddressNew varchar(66),
	Address2New varchar(14)
	
 CONSTRAINT [PK_USPS_ACS_ExtractFile_Work] PRIMARY KEY CLUSTERED 
(
	[USPS_ACS_ExtractFile_Work_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO