CREATE TABLE [dbo].[surveystatus](
	[survey_id] [int] NULL,
	[projectnumber] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[samplesinperiod] [int] NULL,
	[sampleset_id] [int] NULL,
	[datsamplecreate_dt] [datetime] NULL,
	[datDateRange_FromDate] [datetime] NULL,
	[datDateRange_ToDate] [datetime] NULL,
	[MailingStep] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datmailed] [datetime] NULL,
	[nummailed] [int] NULL,
	[numsampled] [int] NULL,
	[cutoff_id] [int] NULL,
	[datcutoffstart_dt] [datetime] NULL,
	[datcutoffstop_dt] [datetime] NULL,
	[numexported] [int] NULL
) ON [PRIMARY]


