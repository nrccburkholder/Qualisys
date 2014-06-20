﻿CREATE TABLE [dbo].[SEL_TEXTBOX](
	[QPC_ID] [int] NOT NULL,
	[SURVEY_ID] [int] NOT NULL,
	[LANGUAGE] [int] NOT NULL,
	[COVERID] [int] NOT NULL,
	[X] [int] NULL,
	[Y] [int] NULL,
	[WIDTH] [int] NULL,
	[HEIGHT] [int] NULL,
	[RICHTEXT] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BORDER] [int] NULL,
	[SHADING] [int] NULL,
	[BITLANGREVIEW] [bit] NOT NULL,
 CONSTRAINT [PK_SEL_TEXTBOX] PRIMARY KEY NONCLUSTERED 
(
	[QPC_ID] ASC,
	[SURVEY_ID] ASC,
	[LANGUAGE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

