﻿CREATE TABLE [dbo].[QUALPRO_PARAMS](
	[PARAM_ID] [int] IDENTITY(1,1) NOT NULL,
	[STRPARAM_NM] [varchar](75) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[STRPARAM_TYPE] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[STRPARAM_GRP] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[STRPARAM_VALUE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NUMPARAM_VALUE] [int] NULL,
	[DATPARAM_VALUE] [datetime] NULL,
	[COMMENTS] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_QUALPRO_PARAMS] PRIMARY KEY CLUSTERED 
(
	[PARAM_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

