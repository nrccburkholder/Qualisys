﻿CREATE TABLE [dbo].[DL_SampleUnitSection_BySampleset](
	[SampleSet_ID] [int] NOT NULL,
	[SAMPLEUNITSECTION_ID] [int] NOT NULL,
	[SAMPLEUNIT_ID] [int] NULL,
	[SELQSTNSSECTION] [int] NULL,
	[SELQSTNSSURVEY_ID] [int] NULL,
	[DateCreated] [datetime] NULL CONSTRAINT [DF_DL_SampleUnitSection_BySampleset_DateCreated]  DEFAULT (getdate()),
 CONSTRAINT [pk_SamplesetID_SAMPLEUNITSECTION_ID] PRIMARY KEY CLUSTERED 
(
	[SampleSet_ID] ASC,
	[SAMPLEUNITSECTION_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

