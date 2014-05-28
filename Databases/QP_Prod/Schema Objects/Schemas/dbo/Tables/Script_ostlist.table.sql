CREATE TABLE [dbo].[Script_ostlist](
	[database_name] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[objecttype] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[objectsubtype] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[scriptfolder] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_Script_ostlist] PRIMARY KEY CLUSTERED 
(
	[database_name] ASC,
	[objecttype] ASC,
	[objectsubtype] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


