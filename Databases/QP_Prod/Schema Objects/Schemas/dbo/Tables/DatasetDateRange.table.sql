CREATE TABLE [dbo].[DatasetDateRange](
	[Dataset_id] [int] NOT NULL,
	[Table_id] [int] NOT NULL,
	[Field_id] [int] NOT NULL,
	[MinDate] [datetime] NULL,
	[MaxDate] [datetime] NULL,
 CONSTRAINT [PK_DatasetDateRange] PRIMARY KEY CLUSTERED 
(
	[Dataset_id] ASC,
	[Table_id] ASC,
	[Field_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


