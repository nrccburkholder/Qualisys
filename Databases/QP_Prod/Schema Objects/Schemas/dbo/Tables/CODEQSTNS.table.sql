﻿CREATE TABLE [dbo].[CODEQSTNS](
	[SELQSTNS_ID] [int] NOT NULL,
	[SURVEY_ID] [int] NOT NULL,
	[LANGUAGE] [int] NOT NULL,
	[CODE] [int] NOT NULL,
	[INTSTARTPOS] [int] NOT NULL,
	[INTLENGTH] [int] NOT NULL,
 CONSTRAINT [PK_CODEQSTNS] PRIMARY KEY CLUSTERED 
(
	[SELQSTNS_ID] ASC,
	[SURVEY_ID] ASC,
	[LANGUAGE] ASC,
	[CODE] ASC,
	[INTSTARTPOS] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]


