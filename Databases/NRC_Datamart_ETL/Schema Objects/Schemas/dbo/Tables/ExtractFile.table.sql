CREATE TABLE [dbo].[ExtractFile](
	[ExtractFileID] [int] IDENTITY(1,1) NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NULL,
	[IncludeMetaData] [bit] NOT NULL,
	[IncludeEventData] [bit] NOT NULL,
	[MaxExtractQueueID] [int] NOT NULL,
	[ErrorMessage] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_ExtractFile] PRIMARY KEY CLUSTERED 
(
	[ExtractFileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


