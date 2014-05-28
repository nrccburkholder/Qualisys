CREATE TABLE [dbo].[qp_defrag](
	[table_id] [int] NULL,
	[table_nm] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Start_defrag] [datetime] NULL,
	[End_defrag] [datetime] NULL,
	[Frag] [decimal](5, 2) NULL,
	[Pages] [int] NULL,
	[DefragIt] [bit] NULL
) ON [PRIMARY]


