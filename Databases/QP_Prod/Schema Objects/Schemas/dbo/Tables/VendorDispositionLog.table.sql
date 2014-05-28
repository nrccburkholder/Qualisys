CREATE TABLE [dbo].[VendorDispositionLog](
	[VendorDispositionLog_ID] [int] IDENTITY(1,1) NOT NULL,
	[Vendor_ID] [int] NULL,
	[DL_LithoCode_ID] [int] NULL,
	[DispositionDate] [datetime] NULL,
	[VendorDisposition_ID] [int] NULL,
	[DateCreated] [datetime] NULL CONSTRAINT [DF_VendorDispositionLog_DateCreated]  DEFAULT (getdate()),
	[SurveyDataLoad_ID] [int] NOT NULL,
	[IsFinal] [bit] NULL,
 CONSTRAINT [PK_VendorDispositionLog] PRIMARY KEY CLUSTERED 
(
	[VendorDispositionLog_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


