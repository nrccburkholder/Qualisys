CREATE TABLE [dbo].[WebPrefLog](
	[WebPrefLog_id] [int] IDENTITY(1,1) NOT NULL,
	[strLithoCode] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Disposition_id] [int] NULL,
	[datLogged] [datetime] NULL,
	[strComment] [varchar](300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


