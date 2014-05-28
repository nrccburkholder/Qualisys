CREATE TABLE [dbo].[VendorPhoneFile_Data](
	[VendorFile_Data_ID] [int] IDENTITY(1,1) NOT NULL,
	[VendorFile_ID] [int] NULL,
	[HCAHPSSamp] [int] NULL,
	[Litho] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Survey_ID] [int] NULL,
	[Sampleset_ID] [int] NULL,
	[Phone] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AltPhone] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Addr] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Addr2] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[St] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Zip5] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhServDate] [datetime] NULL,
	[LangID] [int] NULL,
	[Telematch] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhFacName] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhServInd1] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhServInd2] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhServInd3] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhServInd4] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhServInd5] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhServInd6] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhServInd7] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhServInd8] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhServInd9] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhServInd10] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhServInd11] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhServInd12] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_VendorFile_Data] PRIMARY KEY CLUSTERED 
(
	[VendorFile_Data_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


