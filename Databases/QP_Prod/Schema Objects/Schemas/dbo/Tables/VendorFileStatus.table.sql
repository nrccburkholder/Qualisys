﻿CREATE TABLE [dbo].[VendorFileStatus](
	[VendorFileStatus_ID] [int] IDENTITY(1,1) NOT NULL,
	[VendorFileStatus_nm] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_VendorFileStatus] PRIMARY KEY CLUSTERED 
(
	[VendorFileStatus_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


