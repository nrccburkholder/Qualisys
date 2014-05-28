CREATE TABLE [dbo].[PaperConfigSheet](
	[paperconfig_id] [int] NOT NULL,
	[intSheet_num] [int] NOT NULL,
	[papersize_id] [int] NOT NULL,
	[intpa] [int] NULL,
	[intpb] [int] NULL,
	[intpc] [int] NULL,
	[intpd] [int] NULL,
 CONSTRAINT [PK_PaperConfigSheet] PRIMARY KEY NONCLUSTERED 
(
	[paperconfig_id] ASC,
	[intSheet_num] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]


