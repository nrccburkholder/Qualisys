CREATE TABLE [dbo].[ToBeSeeded](
	[Seed_id] [int] IDENTITY(1,1) NOT NULL,
	[Survey_id] [int] NULL,
	[IsSeeded] [bit] NULL,
	[datSeeded] [datetime] NULL,
	[SurveyType_id] [int] NULL,
	[YearQtr] [varchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED 
(
	[Seed_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]


