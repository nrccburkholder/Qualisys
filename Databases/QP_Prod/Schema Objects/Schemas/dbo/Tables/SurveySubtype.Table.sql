USE [QP_Prod]
GO
/****** Object:  Table [dbo].[SurveySubtype]    Script Date: 09/18/2014 15:04:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SurveySubtype](
	[SurveySubtype_id] [int] IDENTITY(1,1) NOT NULL,
	[Survey_id] [int] NULL,
	[Subtype_id] [int] NULL,
 CONSTRAINT [pk_SurveySubtype] PRIMARY KEY CLUSTERED 
(
	[SurveySubtype_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SurveySubtype]  WITH CHECK ADD  CONSTRAINT [fk_SurveySubtype_Subtype] FOREIGN KEY([Subtype_id])
REFERENCES [dbo].[Subtype] ([Subtype_id])
GO
ALTER TABLE [dbo].[SurveySubtype] CHECK CONSTRAINT [fk_SurveySubtype_Subtype]
GO
ALTER TABLE [dbo].[SurveySubtype]  WITH CHECK ADD  CONSTRAINT [fk_SurveySubtype_Survey] FOREIGN KEY([Survey_id])
REFERENCES [dbo].[SURVEY_DEF] ([SURVEY_ID])
GO
ALTER TABLE [dbo].[SurveySubtype] CHECK CONSTRAINT [fk_SurveySubtype_Survey]
GO
