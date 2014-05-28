CREATE TABLE [dbo].[PCLCounts_log](
	[PCLCounts_ID] [int] IDENTITY(1,1) NOT NULL,
	[datCaptured] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[pclComplete_Total] [int] NULL,
	[pclNeeded_Total] [int] NULL,
	[Errors_Total] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[PCLCounts_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


