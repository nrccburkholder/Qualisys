CREATE TABLE [dbo].[VendorFile_NULLCounts](
	[VendorFile_NULLCounts_id] [int] IDENTITY(1,1) NOT NULL,
	[VendorFile_ID] [int] NOT NULL,
	[Field_id] [int] NOT NULL,
	[strField_nm] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Occurrences] [int] NOT NULL,
 CONSTRAINT [PK_VendorFile_NULLCounts] PRIMARY KEY CLUSTERED 
(
	[VendorFile_NULLCounts_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]


