﻿CREATE TABLE [dbo].[QUESTIONRESULT](
	[QUESTIONRESULT_ID] [int] IDENTITY(1,1) NOT NULL,
	[QUESTIONFORM_ID] [int] NOT NULL,
	[SAMPLEUNIT_ID] [int] NOT NULL,
	[QSTNCORE] [int] NOT NULL,
	[INTRESPONSEVAL] [int] NOT NULL,
	[QPC_TIMESTAMP] [timestamp] NULL,
 CONSTRAINT [PK_QUESTIONRESULT] PRIMARY KEY CLUSTERED 
(
	[QUESTIONRESULT_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]


