CREATE TABLE [dbo].[VendorFileTracking](
	[VendorFileTracking_ID] [int] IDENTITY(1,1) NOT NULL,
	[Member_ID] [int] NULL,
	[ActionDesc] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[VendorFile_ID] [int] NULL,
	[ActionDate] [datetime] NULL CONSTRAINT [DF_VendorFileTracking_ActionDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_VendorFileTracking] PRIMARY KEY CLUSTERED 
(
	[VendorFileTracking_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]


