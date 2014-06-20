﻿CREATE TABLE [dbo].[TAGFIELD](
	[TAGFIELD_ID] [int] IDENTITY(1,1) NOT NULL,
	[TAG_ID] [int] NOT NULL,
	[TABLE_ID] [int] NULL,
	[FIELD_ID] [int] NULL,
	[STUDY_ID] [int] NULL,
	[REPLACEFIELD_FLG] [bit] NOT NULL,
	[STRREPLACELITERAL] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_TAGFIELD] PRIMARY KEY CLUSTERED 
(
	[TAGFIELD_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

