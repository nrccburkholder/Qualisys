CREATE TABLE [dbo].[HCAHPSEligibleEncLog](
	[sampleset_id] [int] NOT NULL,
	[sampleunit_id] [int] NOT NULL,
	[pop_id] [int] NOT NULL,
	[enc_id] [int] NULL,
	[SampleEncounterDate] [datetime] NOT NULL,
 CONSTRAINT [UniqueHCAHPSEligibleEncLog] UNIQUE NONCLUSTERED 
(
	[sampleset_id] ASC,
	[sampleunit_id] ASC,
	[pop_id] ASC,
	[enc_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


