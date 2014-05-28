CREATE TABLE [dbo].[VendorDispositions](
	[VendorDisposition_ID] [int] IDENTITY(1,1) NOT NULL,
	[Vendor_ID] [int] NULL,
	[Disposition_ID] [int] NULL,
	[VendorDispositionCode] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[VendorDispositionLabel] [varchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[VendorDispositionDesc] [varchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DateCreated] [datetime] NULL CONSTRAINT [DF_VendorDispositions_DateCreated]  DEFAULT (getdate()),
 CONSTRAINT [PK_VendorDispositions] PRIMARY KEY CLUSTERED 
(
	[VendorDisposition_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]


