USE [QP_Prod]
GO

/****** Object:  Table [dbo].[SurveyValidationProcsBySurveyType]    Script Date: 8/13/2014 1:58:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SurveyValidationProcsBySurveyType](
	[SurveyValidationProcsToSurveyType_id] [int] IDENTITY(1,1) NOT NULL,
	[SurveyValidationProcs_id] [int] NULL,
	[CAHPSType_ID] [int] NULL,
	[SubType_ID] [int] NULL
) ON [PRIMARY]

GO


