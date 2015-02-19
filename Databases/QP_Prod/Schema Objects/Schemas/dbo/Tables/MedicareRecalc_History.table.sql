USE [QP_Prod]
GO

/****** Object:  Table [dbo].[MedicareRecalc_History]    Script Date: 2/19/2015 2:33:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MedicareRecalc_History](
	[MedicareReCalcLog_ID] [int] IDENTITY(1,1) NOT NULL,
	[MedicareNumber] [varchar](20) NULL,
	[MedicareName] [varchar](200) NULL,
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
	[UserCensusForced] [int] NULL,
 CONSTRAINT [PK_MedicareRecalc_History] PRIMARY KEY CLUSTERED 
(
	[MedicareReCalcLog_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[MedicareRecalc_History] ADD  DEFAULT (NULL) FOR [UserCensusForced]
GO

ALTER TABLE [dbo].[MedicareRecalc_History]  WITH CHECK ADD  CONSTRAINT [FK_MedicareRecalc_History_MedicarePropDataType] FOREIGN KEY([MedicarePropDataType_ID])
REFERENCES [dbo].[MedicarePropDataType] ([MedicarePropDataType_ID])
GO

ALTER TABLE [dbo].[MedicareRecalc_History] CHECK CONSTRAINT [FK_MedicareRecalc_History_MedicarePropDataType]
GO

