CREATE TABLE [dbo].[SamplingLog](
	[SampleSet_id] [int] NOT NULL,
	[StepName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Occurred] [datetime] NOT NULL,
	[SQLCode] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


