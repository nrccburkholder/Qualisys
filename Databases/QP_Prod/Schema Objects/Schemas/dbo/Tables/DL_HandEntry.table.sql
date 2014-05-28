CREATE TABLE [dbo].[DL_HandEntry](
	[DL_HandEntry_ID] [int] IDENTITY(1,1) NOT NULL,
	[DL_LithoCode_ID] [int] NULL,
	[DL_Error_ID] [int] NULL,
	[QstnCore] [int] NULL,
	[ItemNumber] [int] NULL,
	[LineNumber] [int] NULL,
	[HandEntryText] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_DL_HandEntry] PRIMARY KEY CLUSTERED 
(
	[DL_HandEntry_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


