CREATE TABLE [dbo].[SAMPLESET](
	[SAMPLESET_ID] [int] IDENTITY(1,1) NOT NULL,
	[SAMPLEPLAN_ID] [int] NOT NULL,
	[SURVEY_ID] [int] NULL,
	[EMPLOYEE_ID] [int] NOT NULL,
	[DATSAMPLECREATE_DT] [datetime] NULL,
	[intDateRange_Table_id] [int] NULL,
	[intDateRange_Field_id] [int] NULL,
	[datDateRange_FromDate] [datetime] NULL,
	[datDateRange_ToDate] [datetime] NULL,
	[tiOversample_flag] [tinyint] NULL CONSTRAINT [DF__SampleSet__tiOve__4D555BD0]  DEFAULT (0),
	[tiNewPeriod_flag] [tinyint] NULL CONSTRAINT [DF__SampleSet__tiNew__4E498009]  DEFAULT (0),
	[strSampleSurvey_nm] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[extract_flg] [tinyint] NULL,
	[datLastMailed] [datetime] NULL,
	[tiUnikeysDeled] [tinyint] NULL,
	[web_extract_flg] [tinyint] NULL,
	[intSample_Seed] [int] NULL,
	[PreSampleTime] [int] NULL,
	[PostSampleTime] [int] NULL,
	[datScheduled] [datetime] NULL,
	[SamplingAlgorithmId] [int] NULL,
	[SurveyType_Id] [int] NULL,
	[HCAHPSOverSample] [tinyint] NOT NULL CONSTRAINT [DF_sampleset_HCAHPSOverSample]  DEFAULT (0),
 CONSTRAINT [PK_SAMPLESET] PRIMARY KEY CLUSTERED 
(
	[SAMPLESET_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


