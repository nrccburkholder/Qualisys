CREATE TABLE [dbo].[DispositionList](
	[DispositionList_id] [int] IDENTITY(1,1) NOT NULL,
	[Country_id] [int] NOT NULL,
	[strDispositionList_nm] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Author] [int] NOT NULL,
	[datOccurred] [datetime] NOT NULL,
	[bitDefault] [bit] NOT NULL CONSTRAINT [DF_DispositionList_bitDefault]  DEFAULT (0),
 CONSTRAINT [PK__DispositionList__5469062F] PRIMARY KEY CLUSTERED 
(
	[DispositionList_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


