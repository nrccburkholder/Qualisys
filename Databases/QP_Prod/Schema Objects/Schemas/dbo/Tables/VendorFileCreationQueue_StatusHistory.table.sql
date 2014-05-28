CREATE TABLE [dbo].[VendorFileCreationQueue_StatusHistory](
	[VendorFileHistory_ID] [int] IDENTITY(1,1) NOT NULL,
	[VendorFile_ID] [int] NULL,
	[Sampleset_ID] [int] NULL,
	[mailingStep_ID] [int] NULL,
	[VendorFileStatus_ID] [int] NULL,
	[DateCreated] [datetime] NULL CONSTRAINT [DF_VendorFileCreationQueue_StatusHistory_DateCreated]  DEFAULT (getdate()),
	[LoggedInUser] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_VendorFileCreationQueue_StatusHistory] PRIMARY KEY CLUSTERED 
(
	[VendorFileHistory_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


