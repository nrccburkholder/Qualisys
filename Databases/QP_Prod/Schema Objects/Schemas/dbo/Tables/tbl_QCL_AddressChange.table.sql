CREATE TABLE [dbo].[tbl_QCL_AddressChange](
	[AddressChange_id] [int] IDENTITY(1,1) NOT NULL,
	[Litho] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Disposition_id] [int] NULL,
	[Addr] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Addr2] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Del_Pt] [char](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ST] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Zip4] [char](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ZIP5] [char](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddrStat] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddrErr] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryID] [int] NULL,
	[Province] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PostalCode] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReceiptTypeID] [int] NULL,
	[UserName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


