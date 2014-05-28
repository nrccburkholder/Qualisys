CREATE TABLE [dbo].[MedicareGlobalCalcDefaults](
	[MedicareGlobalCalcDefault_id] [int] IDENTITY(1,1) NOT NULL,
	[RespRate] [decimal](8, 4) NOT NULL,
	[IneligibleRate] [decimal](8, 4) NOT NULL,
	[ProportionChangeThreshold] [decimal](8, 4) NOT NULL,
	[AnnualReturnTarget] [int] NOT NULL,
	[ForceCensusSamplePercentage] [decimal](8, 4) NOT NULL,
 CONSTRAINT [PK_MedicareGlobalCalcDefault_id] PRIMARY KEY CLUSTERED 
(
	[MedicareGlobalCalcDefault_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


