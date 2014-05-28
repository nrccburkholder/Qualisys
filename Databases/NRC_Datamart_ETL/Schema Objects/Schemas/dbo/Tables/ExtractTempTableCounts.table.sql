CREATE TABLE [dbo].[ExtractTempTableCounts](
	[ExtractFileID] [int] NOT NULL,
	[TableName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Count] [int] NULL,
	[Deletes] [int] NULL,
 CONSTRAINT [PK_ExtractTempTableCounts] PRIMARY KEY CLUSTERED 
(
	[ExtractFileID] ASC,
	[TableName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


