CREATE TABLE [dbo].[SamplePlanWorksheet](
	[SamplePlanWorksheet_id] [int] IDENTITY(1,1) NOT NULL,
	[Sampleset_id] [int] NULL,
	[SampleUnit_id] [int] NULL,
	[strSampleUnit_nm] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ParentSampleUnit_id] [int] NULL,
	[intTier] [int] NULL,
	[intUniverseCount] [int] NULL CONSTRAINT [DF__SamplePla__intUn__617DE6BC]  DEFAULT (0),
	[intDQ] [int] NULL,
	[intAvailableUniverse] [int] NULL,
	[intPeriodReturnTarget] [int] NULL,
	[numDefaultResponseRate] [real] NULL,
	[numHistoricResponseRate] [real] NULL,
	[intTotalPriorPeriodOutgo] [int] NULL,
	[intAnticipatedTPPOReturns] [int] NULL,
	[intAdditionalReturnsNeeded] [int] NULL,
	[intSamplesAlreadyPulled] [int] NULL,
	[intSamplesInPeriod] [int] NULL,
	[intSamplesLeftInPeriod] [int] NULL,
	[numAdditionalPeriodOutgoNeeded] [real] NULL,
	[intOutgoNeededNow] [int] NULL,
	[intSampledNow] [int] NULL,
	[intIndirectSampledNow] [int] NULL,
	[intShortfall] [int] NULL,
	[strCriteria] [varchar](3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[minenc_dt] [datetime] NULL,
	[maxenc_dt] [datetime] NULL,
	[badphonecount] [int] NOT NULL DEFAULT (0),
	[BadAddressCount] [int] NOT NULL DEFAULT (0),
	[HcahpsDirectSampledCount] [int] NOT NULL DEFAULT (0),
PRIMARY KEY CLUSTERED 
(
	[SamplePlanWorksheet_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


