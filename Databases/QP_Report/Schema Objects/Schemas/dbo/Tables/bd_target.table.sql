CREATE TABLE [dbo].[bd_target](
	[strclient_nm] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[client_id] [int] NULL,
	[strstudy_nm] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[study_id] [int] NOT NULL,
	[strsurvey_nm] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[survey_id] [int] NULL,
	[strsampleunit_nm] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sampleunit_id] [int] NULL,
	[PeriodsShort] [int] NULL,
	[TotalPeriods] [int] NULL,
	[AvgShort] [int] NULL,
	[LastNewPeriod] [datetime] NULL
) ON [PRIMARY]


