﻿CREATE TABLE [dbo].[PCL_Logo_TP](
	[QPC_ID] [int] NOT NULL,
	[COVERID] [int] NOT NULL,
	[SURVEY_ID] [int] NOT NULL,
	[DESCRIPTION] [char](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[X] [int] NULL,
	[Y] [int] NULL,
	[WIDTH] [int] NULL,
	[HEIGHT] [int] NULL,
	[SCALING] [int] NULL,
	[BITMAP] [image] NULL,
	[VISIBLE] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


