﻿CREATE TABLE [dbo].[SEL_SKIP](
	[SURVEY_ID] [int] NOT NULL,
	[SELQSTNS_ID] [int] NOT NULL,
	[SELSCLS_ID] [int] NOT NULL,
	[SCALEITEM] [int] NOT NULL,
	[NUMSKIP] [int] NULL,
	[NUMSKIPTYPE] [int] NULL,
 CONSTRAINT [PK_SEL_SKIP] PRIMARY KEY CLUSTERED 
(
	[SURVEY_ID] ASC,
	[SELQSTNS_ID] ASC,
	[SELSCLS_ID] ASC,
	[SCALEITEM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]


