CREATE TABLE [dbo].[VendorWebFile_Data](
	[VendorWebFile_Data_ID] [int] IDENTITY(1,1) NOT NULL,
	[VendorFile_ID] [int] NULL,
	[Survey_ID] [int] NULL,
	[Sampleset_ID] [int] NULL,
	[Litho] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WAC] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LangID] [int] NULL,
	[Email_Address] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WbServDate] [datetime] NULL,
	[wbServInd1] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[wbServInd2] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[wbServInd3] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[wbServInd4] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[wbServInd5] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[wbServInd6] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExternalRespondentID] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bitSentToVendor] [bit] NULL,
 CONSTRAINT [PK_VendorWebFile_Data] PRIMARY KEY CLUSTERED 
(
	[VendorWebFile_Data_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


