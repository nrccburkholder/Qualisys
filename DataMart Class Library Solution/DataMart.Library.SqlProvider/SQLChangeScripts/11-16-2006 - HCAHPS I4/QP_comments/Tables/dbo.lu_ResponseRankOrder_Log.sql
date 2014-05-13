CREATE TABLE [dbo].[lu_ResponseRankOrder_Log](
	[QstnCore] [int] NULL,
	[Val] [int] NULL,
	[RankOrder] [smallint] NULL,
	[Operation] [char] NULL,
	[datChange] [smalldatetime] NULL,
	[strUser_nm] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
