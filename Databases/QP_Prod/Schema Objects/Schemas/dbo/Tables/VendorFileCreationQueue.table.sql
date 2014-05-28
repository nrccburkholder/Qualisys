CREATE TABLE [dbo].[VendorFileCreationQueue](
	[VendorFile_ID] [int] IDENTITY(1,1) NOT NULL,
	[SAMPLESET_ID] [int] NULL,
	[MailingStep_ID] [int] NULL,
	[VendorFileStatus_ID] [int] NULL,
	[DateFileCreated] [datetime] NULL,
	[DateDataCreated] [datetime] NULL CONSTRAINT [DF_VendorFileCreationQueue_DateDataCreated]  DEFAULT (getdate()),
	[ArchiveFileName] [varchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecordsInFile] [int] NULL,
	[RecordsNoLitho] [int] NULL,
	[ShowInTree] [bit] NULL CONSTRAINT [DF_VendorFileCreationQueue_ShowInTree]  DEFAULT (1),
	[ErrorDesc] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_VendorFileCreationQueue] PRIMARY KEY CLUSTERED 
(
	[VendorFile_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]


