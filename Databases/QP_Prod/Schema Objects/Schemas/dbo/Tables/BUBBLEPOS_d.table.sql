﻿CREATE TABLE [dbo].[BUBBLEPOS_d](
	[QUESTIONFORM_ID] [int] NOT NULL,
	[SAMPLEUNIT_ID] [int] NOT NULL,
	[INTPAGE_NUM] [int] NOT NULL,
	[QSTNCORE] [int] NOT NULL,
	[INTBEGCOLUMN] [int] NULL,
	[READMETHOD_ID] [int] NULL,
	[INTRESPCOL] [int] NOT NULL,
 CONSTRAINT [PK_BUBBLEPOS] PRIMARY KEY CLUSTERED 
(
	[QUESTIONFORM_ID] ASC,
	[SAMPLEUNIT_ID] ASC,
	[INTPAGE_NUM] ASC,
	[QSTNCORE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

