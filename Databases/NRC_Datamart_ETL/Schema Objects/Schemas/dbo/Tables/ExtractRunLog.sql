CREATE TABLE [dbo].[ExtractRunLog](
	[ExtractRunLogID] [int] IDENTITY(1,1) NOT NULL,
	[ExtractFileID] [int] NOT NULL,
	[Task] [varchar](200) NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NULL,
 CONSTRAINT [PK_ExtractRunLog] PRIMARY KEY CLUSTERED 
(
	[ExtractRunLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO