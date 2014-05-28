CREATE TABLE [dbo].[SampleUnitTree](
	[SampleUnit_ID] [int] NOT NULL,
	[Survey_ID] [int] NOT NULL,
	[RootSampleUnit_ID] [int] NOT NULL,
	[ParentSampleUnit_ID] [int] NULL,
	[Target] [int] NULL,
	[bitSuppress] [bit] NULL,
	[Tier] [tinyint] NOT NULL,
	[TreeOrder] [int] IDENTITY(1,1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SampleUnit_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


