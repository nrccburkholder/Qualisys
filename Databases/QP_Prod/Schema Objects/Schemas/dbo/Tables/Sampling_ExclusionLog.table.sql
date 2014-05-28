CREATE TABLE [dbo].[Sampling_ExclusionLog](
	[SamplingExlusionLog_ID] [int] IDENTITY(1,1) NOT NULL,
	[Survey_ID] [int] NULL,
	[Sampleset_ID] [int] NULL,
	[Sampleunit_ID] [int] NULL,
	[Pop_ID] [int] NULL,
	[Enc_ID] [int] NULL,
	[SamplingExclusionType_ID] [int] NULL,
	[DQ_BusRule_ID] [int] NULL,
	[DateCreated] [datetime] NULL CONSTRAINT [DF_Sampling_ExclusionLog_DateCreated]  DEFAULT (getdate()),
 CONSTRAINT [PK_Sampling_ExclusionLog] PRIMARY KEY CLUSTERED 
(
	[SamplingExlusionLog_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


