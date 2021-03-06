﻿CREATE TABLE [dbo].[SEL_LOGO](
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
	[VISIBLE] [bit] NOT NULL,
 CONSTRAINT [PK_SEL_LOGO] PRIMARY KEY NONCLUSTERED 
(
	[QPC_ID] ASC,
	[COVERID] ASC,
	[SURVEY_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


