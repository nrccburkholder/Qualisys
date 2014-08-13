
/****** Object:  Table [dbo].[SurveySubTypes]    Script Date: 6/12/2014 12:13:56 PM ******/
/*CREATE_TABLE_SurveySubTypes_S2_16.1*/
SET ANSI_NULLS ON
GO

--drop table SurveySubTypes

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[SurveySubTypes](
	[SurveySubType_ID] [int] IDENTITY(1,1) NOT NULL,
	[SurveyType_ID] [int] NOT NULL,
	[SubType_NM] [varchar](50) NULL,
	[QuestionnaireType_ID] [smallint] NULL
 CONSTRAINT [PK_SurveySubTypes] PRIMARY KEY CLUSTERED 
(
	[SurveySubType_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SurveySubTypes]  WITH CHECK ADD  CONSTRAINT [FK_SurveySubTypes_SurveyType] FOREIGN KEY([SurveyType_ID])
REFERENCES [dbo].[SurveyType] ([SurveyType_id])
GO

ALTER TABLE [dbo].[SurveySubTypes] CHECK CONSTRAINT [FK_SurveySubTypes_SurveyType]
GO



