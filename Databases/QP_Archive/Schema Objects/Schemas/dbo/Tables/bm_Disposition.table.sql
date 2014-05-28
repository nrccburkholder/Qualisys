CREATE TABLE [dbo].[bm_Disposition](
	[Disposition_id] [int] NOT NULL,
	[strDispositionLabel] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Action_id] [int] NULL,
	[HCAHPSValue] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[strReportLabel] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HCAHPSHierarchy] [int] NULL
) ON [PRIMARY]


