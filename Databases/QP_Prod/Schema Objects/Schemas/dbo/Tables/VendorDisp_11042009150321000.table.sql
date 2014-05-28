CREATE TABLE [dbo].[VendorDisp_11042009150321000](
	[VendorDispositionLog_ID] [int] IDENTITY(1,1) NOT NULL,
	[Vendor_ID] [int] NULL,
	[DL_LithoCode_ID] [int] NULL,
	[VendorDisposition_ID] [int] NULL,
	[SurveyDataLoad_ID] [int] NOT NULL,
	[DispositionDate] [datetime] NULL,
	[DateCreated] [datetime] NULL CONSTRAINT [DF_VendorD_11042009150321003]  DEFAULT (getdate()),
	[IsFinal] [bit] NULL,
 CONSTRAINT [PK_VendorD_11042009150321001] PRIMARY KEY CLUSTERED 
(
	[VendorDispositionLog_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


