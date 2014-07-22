USE [QP_Prod]
GO

/****** Object:  Table [dbo].[SurveySubTypes]    Script Date: 7/22/2014 8:35:21 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[SurveySubTypes](
	[SurveySubType_ID] [int] IDENTITY(1,1) NOT NULL,
	[SurveyType_ID] [int] NOT NULL,
	[SubType_NM] [varchar](50) NULL,
	[QuestionnaireType_ID] [smallint] NULL,
 CONSTRAINT [PK_SurveySubTypes] PRIMARY KEY CLUSTERED 
(
	[SurveySubType_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[SurveySubTypes]  WITH CHECK ADD  CONSTRAINT [FK_SurveySubTypes_SurveyType] FOREIGN KEY([SurveyType_ID])
REFERENCES [dbo].[SurveyType] ([SurveyType_ID])
GO

ALTER TABLE [dbo].[SurveySubTypes] CHECK CONSTRAINT [FK_SurveySubTypes_SurveyType]
GO


