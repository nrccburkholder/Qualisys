/*
dropped 2/19/2015 in favor of using EligibleEncLoc table instead - Chris Burkholder

CREATE TABLE [dbo].[HHCAHPSEligibleEncLog](
	[sampleset_id] [int] NOT NULL,
	[sampleunit_id] [int] NOT NULL,
	[pop_id] [int] NOT NULL,
	[enc_id] [int] NULL,
	[SampleEncounterDate] [datetime] NOT NULL,
 CONSTRAINT [UniqueHHCAHPSEligibleEncLog] UNIQUE NONCLUSTERED 
(
	[sampleset_id] ASC,
	[sampleunit_id] ASC,
	[pop_id] ASC,
	[enc_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


*/