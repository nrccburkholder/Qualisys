CREATE TABLE [dbo].[HandWrittenField](
	[Survey_id] [int] NOT NULL,
	[QstnCore] [int] NOT NULL,
	[Item] [int] NOT NULL,
	[SampleUnit_id] [int] NOT NULL,
	[Line_id] [tinyint] NOT NULL,
	[Table_id] [int] NOT NULL,
	[Field_id] [int] NOT NULL,
 CONSTRAINT [PK_HandWrittenField] PRIMARY KEY CLUSTERED 
(
	[Survey_id] ASC,
	[QstnCore] ASC,
	[Item] ASC,
	[SampleUnit_id] ASC,
	[Line_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


