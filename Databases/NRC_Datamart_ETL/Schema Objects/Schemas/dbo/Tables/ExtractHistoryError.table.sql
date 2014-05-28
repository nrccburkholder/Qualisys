CREATE TABLE [dbo].[ExtractHistoryError](
	[ExtractHistoryID] [int] NOT NULL,
	[ExtractFileID] [int] NOT NULL,
	[EntityTypeID] [int] NOT NULL,
	[PKey1] [int] NOT NULL,
	[PKey2] [int] NULL,
	[IsMetaData] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_ExtractHistoryError_IsDeleted]  DEFAULT (0),
	[Created] [datetime] NOT NULL CONSTRAINT [DF_ExtractHistoryError_Created]  DEFAULT (getdate()),
	[TriggerSource] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Source] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Comment] [nvarchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]


