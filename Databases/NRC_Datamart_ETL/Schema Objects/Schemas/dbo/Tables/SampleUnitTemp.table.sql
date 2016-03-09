USE [NRC_DataMart_ETL]
GO

/****** Object:  Table [dbo].[SampleUnitTemp]    Script Date: 3/9/2016 4:00:13 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SampleUnitTemp](
	[ExtractFileID] [int] NOT NULL,
	[SAMPLESET_ID] [int] NOT NULL,
	[SAMPLEUNIT_ID] [int] NOT NULL,
	[NumPatInFile] [int] NULL,
	[ineligibleCount] [int] NULL,
	[isCensus] [tinyint] NULL,
	[eligibleCount] [int] NULL
) ON [PRIMARY]

GO


