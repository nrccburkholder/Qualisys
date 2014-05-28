CREATE TABLE [dbo].[HHVisit_ReturnCases](
	[SAMPLEPOP_ID] [int] NOT NULL,
	[STRCLIENT_NM] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CLIENT_ID] [int] NOT NULL,
	[STRSTUDY_NM] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[STUDY_ID] [int] NOT NULL,
	[STRSURVEY_NM] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SURVEY_ID] [int] NOT NULL,
	[MedicareNumber] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MethodologyType] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datDateRange_FromDate] [datetime] NULL,
	[STRLITHOCODE] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DATRETURNED] [datetime] NULL,
	[datResultsImported] [datetime] NULL
) ON [PRIMARY]


