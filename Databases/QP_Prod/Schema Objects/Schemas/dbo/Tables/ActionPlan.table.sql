CREATE TABLE [dbo].[ActionPlan](
	[ActionPlan_id] [int] IDENTITY(1,1) NOT NULL,
	[survey_id] [int] NULL,
	[strActionPlan_nm] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[strFieldOrder] [varchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bitCorrelateRootOnly] [bit] NOT NULL
) ON [PRIMARY]


