CREATE TABLE [dbo].[HHCAHPS_PatInfileCount](
	[PatInFileID] [int] IDENTITY(1,1) NOT NULL,
	[Sampleset_ID] [int] NOT NULL,
	[Sampleunit_ID] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MedicareNumber] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NumPatInFile] [int] NULL,
	[DateCreated] [datetime] NULL CONSTRAINT [DF_HHCHAPS_PatInfileCount_DateCreated]  DEFAULT (getdate()),
 CONSTRAINT [PK_HHCHAPS_PatInfileCount] PRIMARY KEY CLUSTERED 
(
	[Sampleset_ID] ASC,
	[Sampleunit_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


