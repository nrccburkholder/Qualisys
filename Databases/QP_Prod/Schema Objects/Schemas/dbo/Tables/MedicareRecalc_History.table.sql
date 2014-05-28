CREATE TABLE [dbo].[MedicareRecalc_History](
	[MedicareReCalcLog_ID] [int] IDENTITY(1,1) NOT NULL,
	[MedicareNumber] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MedicareName] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MedicarePropCalcType_ID] [int] NULL,
	[MedicarePropDataType_ID] [int] NULL,
	[EstRespRate] [decimal](8, 4) NULL,
	[EstIneligibleRate] [decimal](8, 4) NULL,
	[EstAnnualVolume] [int] NULL,
	[SwitchToCalcDate] [datetime] NULL,
	[AnnualReturnTarget] [int] NULL,
	[ProportionCalcPct] [decimal](8, 4) NULL,
	[SamplingLocked] [tinyint] NULL,
	[ProportionChangeThreshold] [decimal](8, 4) NULL,
	[CensusForced] [tinyint] NULL,
	[Member_ID] [int] NULL,
	[DateCalculated] [datetime] NULL,
	[HistoricRespRate] [decimal](8, 4) NULL,
	[HistoricAnnualVolume] [int] NULL,
	[ForcedCalculation] [tinyint] NULL,
	[PropSampleCalcDate] [datetime] NULL,
 CONSTRAINT [PK_MedicareRecalc_History] PRIMARY KEY CLUSTERED 
(
	[MedicareReCalcLog_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


