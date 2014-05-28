CREATE TABLE [dbo].[DashBoardLog](
	[Report] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Associate] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Client] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Study] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Survey] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Sampleset] [datetime] NULL,
	[FirstSampleset] [datetime] NULL,
	[LastSampleset] [datetime] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Days] [int] NULL,
	[Status] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProcedureBegin] [datetime] NULL,
	[ProcedureEnd] [datetime] NULL,
	[procedurelength]  AS (datediff(second,[procedurebegin],[procedureend]))
) ON [PRIMARY]


