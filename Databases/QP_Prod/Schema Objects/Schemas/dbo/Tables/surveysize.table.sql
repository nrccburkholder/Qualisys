CREATE TABLE [dbo].[surveysize](
	[genYear] [int] NULL,
	[genMonth] [int] NULL,
	[client_id] [int] NULL,
	[strclient_nm] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[study_id] [int] NULL,
	[PaperSize] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NumberofSurveys] [int] NULL,
	[TotalPages] [int] NULL,
	[Returns] [int] NULL,
	[ReturnRate]  AS ([returns] * 1.0 / [numberofsurveys] * 100),
	[Undeliverable] [int] NULL,
	[TargetUnits] [int] NULL,
	[NoTargetUnits] [int] NULL
) ON [PRIMARY]


