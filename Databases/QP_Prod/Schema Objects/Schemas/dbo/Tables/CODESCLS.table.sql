﻿CREATE TABLE [dbo].[CODESCLS](
	[SURVEY_ID] [int] NOT NULL,
	[QPC_ID] [int] NOT NULL,
	[ITEM] [int] NOT NULL,
	[LANGUAGE] [int] NOT NULL,
	[CODE] [int] NOT NULL,
	[INTSTARTPOS] [int] NOT NULL,
	[INTLENGTH] [int] NOT NULL,
 CONSTRAINT [PK_CODESCLS] PRIMARY KEY CLUSTERED 
(
	[SURVEY_ID] ASC,
	[QPC_ID] ASC,
	[ITEM] ASC,
	[LANGUAGE] ASC,
	[CODE] ASC,
	[INTSTARTPOS] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

