CREATE TABLE [dbo].[DispositionListDef](
	[DispositionList_id] [int] NOT NULL,
	[Disposition_id] [int] NOT NULL,
	[Author] [int] NOT NULL,
	[datOccurred] [datetime] NOT NULL,
 CONSTRAINT [PK_DispositionListDef] PRIMARY KEY CLUSTERED 
(
	[DispositionList_id] ASC,
	[Disposition_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


