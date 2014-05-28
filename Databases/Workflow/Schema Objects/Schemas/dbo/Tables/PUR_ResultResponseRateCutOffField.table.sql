CREATE TABLE [dbo].[PUR_ResultResponseRateCutOffField](
	[PUReport_ID] [int] NOT NULL,
	[Survey_ID] [int] NOT NULL,
	[CutOffTable] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CutOffField] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_PUR_ResultResponseRateCutOffField] PRIMARY KEY CLUSTERED 
(
	[PUReport_ID] ASC,
	[Survey_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


