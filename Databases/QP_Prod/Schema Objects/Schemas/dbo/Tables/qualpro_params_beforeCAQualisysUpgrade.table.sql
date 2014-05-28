CREATE TABLE [dbo].[qualpro_params_beforeCAQualisysUpgrade](
	[PARAM_ID] [int] IDENTITY(1,1) NOT NULL,
	[STRPARAM_NM] [varchar](75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[STRPARAM_TYPE] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[STRPARAM_GRP] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[STRPARAM_VALUE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NUMPARAM_VALUE] [int] NULL,
	[DATPARAM_VALUE] [datetime] NULL,
	[COMMENTS] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


