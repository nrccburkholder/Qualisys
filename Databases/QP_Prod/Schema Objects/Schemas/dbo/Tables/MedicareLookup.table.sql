CREATE TABLE [dbo].[MedicareLookup](
	[MedicareNumber] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MedicareName] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Active] [bit] NULL CONSTRAINT [DF_MedicareLookup_Active]  DEFAULT ((1)),
	[MedicarePropCalcType_ID] [int] NOT NULL CONSTRAINT [DF_MedicareLookup_MedicarePropCalcType_ID]  DEFAULT ((2)),
	[EstAnnualVolume] [int] NULL,
	[EstRespRate] [decimal](8, 4) NULL,
	[EstIneligibleRate] [decimal](8, 4) NULL,
	[SwitchToCalcDate] [datetime] NULL,
	[AnnualReturnTarget] [int] NULL,
	[SamplingLocked] [tinyint] NULL CONSTRAINT [DF_MedicareLookup_SamplingLocked]  DEFAULT ((0)),
	[ProportionChangeThreshold] [decimal](8, 4) NULL,
	[CensusForced] [tinyint] NULL,
	[PENumber] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_ML_MedicareNumber] PRIMARY KEY CLUSTERED 
(
	[MedicareNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


