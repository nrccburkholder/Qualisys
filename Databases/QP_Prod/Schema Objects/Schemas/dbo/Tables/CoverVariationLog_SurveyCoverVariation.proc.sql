USE [QP_Prod]
GO

/****** Object:  Table [dbo].[CoverVariationLog_SurveyCoverVariation]    Script Date: 11/14/2014 11:24:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CoverVariationLog_SurveyCoverVariation](
	[CV_RunDate] [datetime] NULL,
	[bitTP] [bit] NULL,
	[SurveyCoverVariation_id] [int] NULL,
	[CoverVariation_id] [int] NULL,
	[survey_id] [int] NULL,
	[cover_id] [int] NULL
) ON [PRIMARY]

GO

