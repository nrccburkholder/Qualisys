CREATE TABLE [dbo].[VendorFile_Messages](
	[VendorFile_Message_ID] [int] IDENTITY(1,1) NOT NULL,
	[VendorFile_ID] [int] NULL,
	[VendorFile_MessageType_ID] [int] NULL,
	[Message] [varchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_VendorFile_Messages] PRIMARY KEY CLUSTERED 
(
	[VendorFile_Message_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]


