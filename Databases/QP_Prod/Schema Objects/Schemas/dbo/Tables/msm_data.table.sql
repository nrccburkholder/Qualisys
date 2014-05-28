CREATE TABLE [dbo].[msm_data](
	[strclient_nm] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[employee_id] [int] NULL,
	[firstname] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[lastname] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[study_id] [int] NOT NULL,
	[strstudy_nm] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[survey_id] [int] NOT NULL,
	[strsurvey_nm] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[datsamplecreate_dt] [datetime] NULL,
	[datdaterange_fromdate] [datetime] NULL,
	[datdaterange_todate] [datetime] NULL,
	[Ind] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[surveytype_id] [int] NULL
) ON [PRIMARY]


