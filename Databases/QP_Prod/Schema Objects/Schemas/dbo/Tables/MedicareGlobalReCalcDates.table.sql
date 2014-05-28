CREATE TABLE [dbo].[MedicareGlobalReCalcDates](
	[MedicareGlobalReCalcDate_id] [int] IDENTITY(1,1) NOT NULL,
	[MedicareGlobalRecalcDefault_id] [int] NOT NULL,
	[ReCalcMonth] [int] NOT NULL,
 CONSTRAINT [PK_MedicareGlobalReCalcDate_id] PRIMARY KEY CLUSTERED 
(
	[MedicareGlobalReCalcDate_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


