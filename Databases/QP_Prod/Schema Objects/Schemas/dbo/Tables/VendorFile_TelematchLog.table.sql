CREATE TABLE [dbo].[VendorFile_TelematchLog](
	[VendorFile_TelematchLog_ID] [int] IDENTITY(1,1) NOT NULL,
	[VendorFile_ID] [int] NULL,
	[datSent] [datetime] NULL,
	[datReturned] [datetime] NULL,
	[intRecordsReturned] [int] NULL,
	[datOverdueNoticeSent] [datetime] NULL,
 CONSTRAINT [PK_VendorFile_TelematchLog] PRIMARY KEY CLUSTERED 
(
	[VendorFile_TelematchLog_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]


