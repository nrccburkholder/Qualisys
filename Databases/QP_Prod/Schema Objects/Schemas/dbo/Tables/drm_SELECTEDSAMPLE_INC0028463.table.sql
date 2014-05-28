CREATE TABLE [dbo].[drm_SELECTEDSAMPLE_INC0028463](
	[SELECTEDSAMPLE_ID] [int] IDENTITY(1,1) NOT NULL,
	[SAMPLESET_ID] [int] NOT NULL,
	[STUDY_ID] [int] NULL,
	[POP_ID] [int] NOT NULL,
	[SAMPLEUNIT_ID] [int] NOT NULL,
	[STRUNITSELECTTYPE] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[intExtracted_flg] [int] NULL,
	[enc_id] [int] NULL,
	[ReportDate] [datetime] NULL,
	[SampleEncounterDate] [datetime] NULL
) ON [PRIMARY]


