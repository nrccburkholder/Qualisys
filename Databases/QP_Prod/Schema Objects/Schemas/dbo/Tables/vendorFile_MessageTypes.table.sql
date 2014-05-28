CREATE TABLE [dbo].[vendorFile_MessageTypes](
	[VendorFile_MessageType_Id] [int] IDENTITY(1,1) NOT NULL,
	[MessageType_Value] [varchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_vendorFile_MessageTypes] PRIMARY KEY CLUSTERED 
(
	[VendorFile_MessageType_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


