CREATE TABLE [dbo].[Vendors](
	[Vendor_ID] [int] IDENTITY(1,1) NOT NULL,
	[VendorCode] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Vendor_nm] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Addr1] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Addr2] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateCode] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Province] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Zip5] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Zip4] [varchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DateCreated] [datetime] NULL CONSTRAINT [DF_Vendors_DateCreated]  DEFAULT (getdate()),
	[DateModified] [datetime] NULL CONSTRAINT [DF_Vendors_DateModified]  DEFAULT (getdate()),
	[bitAcceptFilesFromVendor] [bit] NULL CONSTRAINT [DF_Vendors_bitAcceptFilesFromVendor]  DEFAULT (1),
	[NoResponseChar] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SkipResponseChar] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MultiRespItemNotPickedChar] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LocalFTPLoginName] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[VendorFileOutgoType_ID] [int] NULL,
	[DontKnowResponseChar] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT ('D'),
	[RefusedResponseChar] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT ('R'),
 CONSTRAINT [PK_Vendors] PRIMARY KEY CLUSTERED 
(
	[Vendor_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


