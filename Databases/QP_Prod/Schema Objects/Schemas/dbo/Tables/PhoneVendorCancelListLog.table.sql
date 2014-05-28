CREATE TABLE [dbo].[PhoneVendorCancelListLog](
	[Survey_Id] [int] NOT NULL,
	[StrLithoCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Vendor_Id] [int] NOT NULL,
	[datSentToVendor] [datetime] NULL
) ON [PRIMARY]


