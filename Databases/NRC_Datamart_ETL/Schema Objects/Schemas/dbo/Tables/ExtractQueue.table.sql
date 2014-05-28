CREATE TABLE [dbo].[ExtractQueue](
	[ExtractQueueID] [int] IDENTITY(1,1) NOT NULL,
	[EntityTypeID] [int] NOT NULL,
	[PKey1] [int] NOT NULL,
	[PKey2] [int] NULL,
	[IsMetaData] [bit] NOT NULL,
	[ExtractFileID] [int] NULL,
	[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_ExtractQueue_IsDeleted]  DEFAULT (0),
	[Created] [datetime] NOT NULL CONSTRAINT [DF_ExtractQueue_Created]  DEFAULT (getdate()),
	[Source] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_ExtractQueue] PRIMARY KEY CLUSTERED 
(
	[ExtractQueueID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]


