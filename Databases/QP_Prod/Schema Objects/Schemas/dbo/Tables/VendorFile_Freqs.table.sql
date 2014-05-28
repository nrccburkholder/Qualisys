CREATE TABLE [dbo].[VendorFile_Freqs](
	[VendorFile_Freqs_id] [int] IDENTITY(1,1) NOT NULL,
	[VendorFile_ID] [int] NOT NULL,
	[Field_id] [int] NULL,
	[strField_nm] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[strValue] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Occurrences] [int] NULL,
 CONSTRAINT [PK_VendorFile_Freqs] PRIMARY KEY CLUSTERED 
(
	[VendorFile_Freqs_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


