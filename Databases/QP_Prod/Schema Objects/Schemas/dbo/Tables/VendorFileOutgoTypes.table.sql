CREATE TABLE [dbo].[VendorFileOutgoTypes](
	[VendorFileOutgoType_ID] [int] IDENTITY(1,1) NOT NULL,
	[OutgoType_nm] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OutgoType_desc] [varchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FileExtension] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_VendorFileOutgoTypes] PRIMARY KEY CLUSTERED 
(
	[VendorFileOutgoType_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


