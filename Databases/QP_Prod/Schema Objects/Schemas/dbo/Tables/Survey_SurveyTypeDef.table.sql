CREATE TABLE [dbo].[Survey_SurveyTypeDef](
	[Survey_id] [int] NOT NULL,
	[SurveyTypeDef_id] [int] NOT NULL,
 CONSTRAINT [PK_Survey_SurveyTypeDef] PRIMARY KEY CLUSTERED 
(
	[Survey_id] ASC,
	[SurveyTypeDef_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


