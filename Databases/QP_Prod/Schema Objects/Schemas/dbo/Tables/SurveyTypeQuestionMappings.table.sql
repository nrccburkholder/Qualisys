CREATE TABLE [dbo].[SurveyTypeQuestionMappings](
	[SurveyType_id] [int] NOT NULL,
	[QstnCore] [int] NOT NULL,
	[intOrder] [int] NULL,
	[bitFirstOnForm] [bit] NULL,
	[bitExpanded] [bit] NOT NULL,
	[datEncounterStart_dt] [datetime] NULL,
	[datEncounterEnd_dt] [datetime] NULL,
	[SubType_ID] [int] NOT NULL,
	[isATA] [bit] NULL,
	[isMeasure] [bit] NULL,
 CONSTRAINT [PK_SurveyTypeQuestionMappings] PRIMARY KEY CLUSTERED 
(
	[SurveyType_id] ASC,
	[SubType_ID] ASC,
	[QstnCore] ASC,
	[bitExpanded] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SurveyTypeQuestionMappings] ADD  DEFAULT ((0)) FOR [bitExpanded]


