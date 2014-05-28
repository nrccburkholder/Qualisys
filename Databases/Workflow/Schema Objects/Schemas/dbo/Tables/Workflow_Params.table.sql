CREATE TABLE [dbo].[Workflow_Params](
	[Param_ID] [int] IDENTITY(1,1) NOT NULL,
	[strParam_NM] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[strParam_Type] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[strParam_Grp] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[strParam_Value] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[numParam_Value] [int] NULL,
	[datParam_Value] [datetime] NULL,
	[Comments] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED 
(
	[Param_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


