CREATE TABLE [dbo].[Sel_Cover](
	[SelCover_id] [int] NOT NULL,
	[Survey_id] [int] NOT NULL,
	[PageType] [int] NULL,
	[Description] [char](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Integrated] [bit] NOT NULL,
	[bitLetterHead] [bit] NOT NULL,
 CONSTRAINT [PK_SEL_COVER] PRIMARY KEY NONCLUSTERED 
(
	[SelCover_id] ASC,
	[Survey_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]


