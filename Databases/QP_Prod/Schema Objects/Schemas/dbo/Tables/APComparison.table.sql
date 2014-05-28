CREATE TABLE [dbo].[APComparison](
	[APComparison_id] [int] IDENTITY(1,1) NOT NULL,
	[ActionPlan_id] [int] NULL,
	[strColumn_nm] [char](7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[strDescription] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bitInternal] [bit] NULL,
	[bitOtherSurveys] [bit] NOT NULL,
	[ExternalComp_id] [int] NULL,
	[SigTest_id] [tinyint] NULL,
	[bitInGraph] [bit] NULL,
	[bitInTable] [bit] NULL,
	[UnitFilter_id] [int] NULL,
	[bitExcludeCurrentUnit] [bit] NULL
) ON [PRIMARY]


