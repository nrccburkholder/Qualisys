CREATE TABLE [dbo].[mb_TempBk_vendordispositionlog_BeforeDelete](
	[VendorDispositionLog_ID] [int] NOT NULL,
	[Vendor_ID] [int] NULL,
	[DL_LithoCode_ID] [int] NULL,
	[VendorDisposition_ID] [int] NULL,
	[SurveyDataLoad_ID] [int] NOT NULL,
	[DispositionDate] [datetime] NULL,
	[DateCreated] [datetime] NULL,
	[IsFinal] [bit] NULL
) ON [PRIMARY]


