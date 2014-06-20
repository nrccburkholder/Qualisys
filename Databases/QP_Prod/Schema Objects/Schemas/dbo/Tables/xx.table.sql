﻿CREATE TABLE [dbo].[xx](
	[SELQSTNS_ID] [int] NOT NULL,
	[SURVEY_ID] [int] NOT NULL,
	[LANGUAGE] [int] NOT NULL,
	[SCALEID] [int] NOT NULL,
	[SECTION_ID] [int] NULL,
	[LABEL] [char](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PLUSMINUS] [char](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SUBSECTION] [int] NULL,
	[ITEM] [int] NULL,
	[SUBTYPE] [int] NULL,
	[WIDTH] [int] NULL,
	[HEIGHT] [int] NULL,
	[RICHTEXT] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SCALEPOS] [int] NULL,
	[SCALEFLIPPED] [int] NULL,
	[NUMMARKCOUNT] [int] NULL,
	[BITMEANABLE] [bit] NOT NULL,
	[NUMBUBBLECOUNT] [int] NULL,
	[QSTNCORE] [int] NOT NULL,
	[BITLANGREVIEW] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

