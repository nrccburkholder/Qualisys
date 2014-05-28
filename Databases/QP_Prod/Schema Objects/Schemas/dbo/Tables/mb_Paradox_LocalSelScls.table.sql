CREATE TABLE [dbo].[mb_Paradox_LocalSelScls](
	[Survey_ID] [int] NULL,
	[QPC_ID] [int] NULL,
	[Item] [int] NULL,
	[Language] [int] NULL,
	[Type] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Label] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CharSet] [int] NULL,
	[Val] [int] NULL,
	[ScaleOrder] [int] NULL,
	[intRespType] [int] NULL,
	[Missing] [bit] NOT NULL
) ON [PRIMARY]


