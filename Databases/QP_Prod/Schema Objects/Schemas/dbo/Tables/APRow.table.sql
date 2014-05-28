CREATE TABLE [dbo].[APRow](
	[APRow_id] [int] IDENTITY(1,1) NOT NULL,
	[ActionPlan_id] [int] NULL,
	[strAPRowType] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[qstncore] [int] NULL,
	[strRollup_nm] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[strLabel] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[numSort] [float] NULL,
	[CoreDepVar] [int] NULL,
	[tinyKeyValueNum] [tinyint] NULL,
	[intRowOrder] [int] NULL
) ON [PRIMARY]


