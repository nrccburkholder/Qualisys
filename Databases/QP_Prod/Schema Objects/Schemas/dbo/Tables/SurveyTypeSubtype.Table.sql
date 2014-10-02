USE [QP_Prod]
GO
/****** Object:  Table [dbo].[SurveyTypeSubtype]    Script Date: 09/18/2014 15:04:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SurveyTypeSubtype](
	[SurveyTypeSubtype_id] [int] IDENTITY(1,1) NOT NULL,
	[SurveyType_id] [int] NULL,
	[Subtype_id] [int] NULL,
 CONSTRAINT [pk_SurveyTypeSubtype] PRIMARY KEY CLUSTERED 
(
	[SurveyTypeSubtype_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SurveyTypeSubtype]  WITH CHECK ADD  CONSTRAINT [fk_SurveyTypeSubtype_Subtype] FOREIGN KEY([Subtype_id])
REFERENCES [dbo].[Subtype] ([Subtype_id])
GO
ALTER TABLE [dbo].[SurveyTypeSubtype] CHECK CONSTRAINT [fk_SurveyTypeSubtype_Subtype]
GO
ALTER TABLE [dbo].[SurveyTypeSubtype]  WITH CHECK ADD  CONSTRAINT [fk_SurveyTypeSubtype_SurveyType] FOREIGN KEY([SurveyType_id])
REFERENCES [dbo].[SurveyType] ([SurveyType_ID])
GO
ALTER TABLE [dbo].[SurveyTypeSubtype] CHECK CONSTRAINT [fk_SurveyTypeSubtype_SurveyType]
GO
