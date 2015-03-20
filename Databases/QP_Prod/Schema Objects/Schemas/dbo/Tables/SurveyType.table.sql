CREATE TABLE [dbo].[SurveyType](
	[SurveyType_ID] [int] IDENTITY(1,1) NOT NULL,
	[SurveyType_dsc] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CAHPSType_id] [int] NULL,
	[SeedMailings] [bit] NULL,
	[SeedSurveyPercent] [int] NULL,
	[SeedUnitField] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SkipRepeatsScaleText] bit NOT NULL,
 CONSTRAINT [PK__SurveyType__6687B66A] PRIMARY KEY CLUSTERED 
(
	[SurveyType_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


