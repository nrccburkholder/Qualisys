USE [QP_Prod]
GO

/****** Object:  Table [dbo].[QuestionnaireTypes]    Script Date: 7/22/2014 8:32:33 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[QuestionnaireTypes](
	[QuestionnaireType_ID] [int] IDENTITY(1,1) NOT NULL,
	[SurveyType_ID] [int] NULL,
	[Description] [varchar](50) NULL,
 CONSTRAINT [PK_QuestionnaireTypes] PRIMARY KEY CLUSTERED 
(
	[QuestionnaireType_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[QuestionnaireTypes]  WITH CHECK ADD  CONSTRAINT [FK_QuestionnaireTypes_SurveyType] FOREIGN KEY([SurveyType_ID])
REFERENCES [dbo].[SurveyType] ([SurveyType_ID])
GO

ALTER TABLE [dbo].[QuestionnaireTypes] CHECK CONSTRAINT [FK_QuestionnaireTypes_SurveyType]
GO


