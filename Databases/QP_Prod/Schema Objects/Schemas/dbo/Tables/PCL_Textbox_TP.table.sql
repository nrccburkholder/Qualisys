﻿CREATE TABLE [dbo].[PCL_Textbox_TP](
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
	[BITLANGREVIEW] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


