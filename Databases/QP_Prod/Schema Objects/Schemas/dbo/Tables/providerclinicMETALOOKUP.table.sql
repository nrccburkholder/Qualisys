﻿CREATE TABLE [dbo].[providerclinicMETALOOKUP](
	[NUMMASTERTABLE_ID] [int] NOT NULL,
	[NUMMASTERFIELD_ID] [int] NOT NULL,
	[NUMLKUPTABLE_ID] [int] NOT NULL,
	[NUMLKUPFIELD_ID] [int] NOT NULL,
	[STRLKUP_TYPE] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]

