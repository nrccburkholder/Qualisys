USE [QP_Prod]
GO

/****** Object:  Table [dbo].[EligibleEncLog]    Script Date: 2/19/2015 2:06:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EligibleEncLog](
	[sampleset_id] [int] NOT NULL,
	[sampleunit_id] [int] NOT NULL,
	[pop_id] [int] NOT NULL,
	[enc_id] [int] NULL,
	[SampleEncounterDate] [datetime] NOT NULL,
	[SurveyType_id] [int] NOT NULL
) ON [PRIMARY]

GO

