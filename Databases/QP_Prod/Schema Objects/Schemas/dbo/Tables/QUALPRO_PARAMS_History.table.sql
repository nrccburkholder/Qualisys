CREATE TABLE [dbo].[QUALPRO_PARAMS_History](
	[jn_operation] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[jn_user] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[jn_datetime] [datetime] NULL,
	[jn_endtime] [datetime] NULL,
	[jn_notes] [varchar](240) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[jn_SPID] [smallint] NULL,
	[PARAM_ID] [int] NOT NULL,
	[STRPARAM_NM] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[STRPARAM_TYPE] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[STRPARAM_GRP] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[STRPARAM_VALUE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NUMPARAM_VALUE] [int] NULL,
	[DATPARAM_VALUE] [datetime] NULL,
	[COMMENTS] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


