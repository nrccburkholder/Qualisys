CREATE TABLE [dbo].[SampleSetMedicareCalcLookup](
	[SampleSetMedicareCalc_ID] [int] IDENTITY(1,1) NOT NULL,
	[Sampleset_ID] [int] NULL,
	[Sampleunit_ID] [int] NULL,
	[MedicareReCalcLog_ID] [int] NULL,
 CONSTRAINT [PK_SampleSetMedicareCalcLookup] PRIMARY KEY CLUSTERED 
(
	[SampleSetMedicareCalc_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


