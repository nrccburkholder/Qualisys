CREATE TABLE [dbo].[VendorFile_VoviciDetails](
	[VendorFile_VoviciDetail_ID] [int] IDENTITY(1,1) NOT NULL,
	[Survey_ID] [int] NULL,
	[MailingStep_ID] [int] NULL,
	[VoviciSurvey_ID] [int] NULL,
	[VoviciSurvey_nm] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_VendorFile_VoviciDetails] PRIMARY KEY CLUSTERED 
(
	[VendorFile_VoviciDetail_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]


