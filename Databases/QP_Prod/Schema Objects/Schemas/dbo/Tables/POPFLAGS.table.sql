﻿CREATE TABLE [dbo].[POPFLAGS](
	[STUDY_ID] [int] NOT NULL,
	[POP_ID] [int] NOT NULL,
	[AGE] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SEX] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DOC] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]


