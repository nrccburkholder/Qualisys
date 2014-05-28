CREATE TABLE [dbo].[QDELog](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[datEntered] [datetime] NOT NULL,
	[Username] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LogType] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LogText] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


