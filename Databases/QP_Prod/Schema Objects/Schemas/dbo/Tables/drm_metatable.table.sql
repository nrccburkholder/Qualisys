﻿CREATE TABLE [dbo].[drm_metatable](
	[TABLE_ID] [int] IDENTITY(1,1) NOT NULL,
	[STRTABLE_NM] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[STRTABLE_DSC] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[STUDY_ID] [int] NULL,
	[BITUSESADDRESS] [bit] NOT NULL
) ON [PRIMARY]


