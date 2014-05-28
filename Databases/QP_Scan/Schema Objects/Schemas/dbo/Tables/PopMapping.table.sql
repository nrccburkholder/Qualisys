﻿CREATE TABLE [dbo].[PopMapping](
	[Survey_id] [int] NOT NULL,
	[QstnCore] [int] NOT NULL,
	[Table_id] [int] NULL,
	[Field_id] [int] NULL,
 CONSTRAINT [PK_PopMapping] PRIMARY KEY CLUSTERED 
(
	[Survey_id] ASC,
	[QstnCore] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]


