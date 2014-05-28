CREATE TABLE [dbo].[MedicareLo_07062010194756000](
	[MedicareNumber] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MedicareName] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MedicarePropCalcType_ID] [int] NOT NULL CONSTRAINT [DF_Medicar_07062010194756003]  DEFAULT (2),
	[EstAnnualVolume] [int] NULL,
	[EstRespRate] [decimal](8, 4) NULL,
	[EstIneligibleRate] [decimal](8, 4) NULL,
	[SwitchToCalcDate] [datetime] NULL,
	[AnnualReturnTarget] [int] NULL,
	[SamplingLocked] [tinyint] NULL CONSTRAINT [DF_Medicar_07062010194756002]  DEFAULT (0),
	[ProportionChangeThreshold] [decimal](8, 4) NULL,
	[CensusForced] [tinyint] NULL,
	[PENumber] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_ML_Medi_07062010194756001] PRIMARY KEY CLUSTERED 
(
	[MedicareNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


