﻿CREATE TABLE [dbo].[SEL_SCLS](
	[SURVEY_ID] [int] NOT NULL,
	[QPC_ID] [int] NOT NULL,
	[ITEM] [int] NOT NULL,
	[LANGUAGE] [int] NOT NULL,
	[VAL] [int] NOT NULL,
	[LABEL] [char](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RICHTEXT] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MISSING] [bit] NOT NULL,
	[CHARSET] [int] NULL,
	[SCALEORDER] [int] NULL,
	[INTRESPTYPE] [int] NULL,
 CONSTRAINT [PK_SEL_SCLS] PRIMARY KEY NONCLUSTERED 
(
	[SURVEY_ID] ASC,
	[QPC_ID] ASC,
	[ITEM] ASC,
	[LANGUAGE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


