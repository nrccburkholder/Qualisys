USE [QP_Prod]
GO

/****** Object:  Table [dbo].[CoverVariationLog_spCoverVariation]    Script Date: 11/14/2014 11:23:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CoverVariationLog_spCoverVariation](
	[CV_RunDate] [datetime] NULL,
	[bitTP] [bit] NULL,
	[survey_id] [int] NULL,
	[samplepop_id] [int] NULL,
	[CoverVariation_id] [int] NULL,
	[selcover_id] [int] NULL,
	[intFlag] [int] NULL
) ON [PRIMARY]

GO

