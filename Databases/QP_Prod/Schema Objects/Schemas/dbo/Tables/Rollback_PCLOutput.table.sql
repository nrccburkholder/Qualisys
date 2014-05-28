﻿CREATE TABLE [dbo].[Rollback_PCLOutput](
	[ROLLBACK_ID] [int] NOT NULL,
	[SENTMAIL_ID] [int] NULL,
	[INTSHEET_NUM] [int] NULL,
	[PAPERSIZE_ID] [int] NULL,
	[INTPA] [int] NULL,
	[INTPB] [int] NULL,
	[INTPC] [int] NULL,
	[INTPD] [int] NULL,
	[PCLSTREAM] [image] NULL,
	[BITCOVER] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


