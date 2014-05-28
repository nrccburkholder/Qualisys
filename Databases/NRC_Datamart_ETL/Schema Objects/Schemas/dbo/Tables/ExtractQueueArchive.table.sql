CREATE TABLE [dbo].[ExtractQueueArchive](
	[ExtractQueueArchiveID] [int] NOT NULL,
	[ExtractFileID] [int] NOT NULL,
	[EntityTypeID] [int] NOT NULL,
	[PKey1] [int] NOT NULL,
	[PKey2] [int] NULL,
	[IsMetaData] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Source] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ArchivedDate] [datetime] NULL CONSTRAINT [DF_ExtractQueueArchive_ArchivedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_ExtractQueueArchive] PRIMARY KEY CLUSTERED 
(
	[ExtractQueueArchiveID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


