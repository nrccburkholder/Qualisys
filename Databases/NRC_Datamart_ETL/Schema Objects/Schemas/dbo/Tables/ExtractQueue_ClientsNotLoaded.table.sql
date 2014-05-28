CREATE TABLE [dbo].[ExtractQueue_ClientsNotLoaded](
	[ExtractQueueID] [int] NOT NULL,
	[EntityTypeID] [int] NOT NULL,
	[PKey1] [int] NOT NULL,
	[PKey2] [int] NULL,
	[IsMetaData] [bit] NOT NULL,
	[ExtractFileID] [int] NULL,
	[IsDeleted] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[source] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_ExtractQueue_ClientsNotLoaded] PRIMARY KEY CLUSTERED 
(
	[ExtractQueueID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


