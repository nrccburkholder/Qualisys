CREATE TABLE [dbo].[PeriodDef](
	[PeriodDef_id] [int] IDENTITY(1,1) NOT NULL,
	[Survey_id] [int] NOT NULL,
	[Employee_id] [int] NOT NULL,
	[datAdded] [datetime] NOT NULL,
	[strPeriodDef_nm] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[intExpectedSamples] [int] NOT NULL,
	[DaysToSample] [int] NOT NULL,
	[datExpectedEncStart] [datetime] NULL,
	[datExpectedEncEnd] [datetime] NULL,
	[strDayOrder] [char](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MonthWeek] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SamplingMethod_id] [int] NOT NULL,
 CONSTRAINT [PK_PeriodDef] PRIMARY KEY CLUSTERED 
(
	[PeriodDef_id] ASC,
	[Survey_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


