CREATE TABLE [dbo].[SurveyTypeDef](
	[SurveyTypeDef_id] [int] IDENTITY(1,1) NOT NULL,
	[SurveyTypeDef_dsc] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SurveyType_id] [int] NOT NULL,
	[intOrder] [int] NOT NULL,
 CONSTRAINT [PK__SurveyTypeDef__6D34B3F9] PRIMARY KEY CLUSTERED 
(
	[SurveyTypeDef_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


