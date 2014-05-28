CREATE TABLE [dbo].[SamplingExclusionTypes](
	[SamplingExclusionType_ID] [int] IDENTITY(1,1) NOT NULL,
	[SamplingExclusionType_nm] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SamplingExclusionType_Desc] [varchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_SamplingExclusionTypes] PRIMARY KEY CLUSTERED 
(
	[SamplingExclusionType_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


