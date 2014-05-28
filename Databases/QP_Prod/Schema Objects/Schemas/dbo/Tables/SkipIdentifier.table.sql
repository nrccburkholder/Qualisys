CREATE TABLE [dbo].[SkipIdentifier](
	[Skip_id] [int] IDENTITY(1,1) NOT NULL,
	[Survey_id] [int] NOT NULL,
	[datGenerated] [datetime] NOT NULL,
	[QstnCore] [int] NOT NULL,
	[intResponseval] [int] NOT NULL,
 CONSTRAINT [PK_SkipIdentifier] PRIMARY KEY CLUSTERED 
(
	[Skip_id] ASC,
	[Survey_id] ASC,
	[datGenerated] ASC,
	[QstnCore] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]


