CREATE TABLE [dbo].[GHS_MailMergeFileLog](
	[Job_ID] [int] NOT NULL,
	[FileType] [tinyint] NOT NULL,
	[SeqNum] [smallint] NOT NULL,
	[FileName] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FileSize] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Job_ID] ASC,
	[FileType] ASC,
	[SeqNum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


