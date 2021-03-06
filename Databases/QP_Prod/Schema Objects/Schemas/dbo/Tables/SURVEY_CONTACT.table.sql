﻿CREATE TABLE [dbo].[SURVEY_CONTACT](
	[SURVEYCONTACT_ID] [int] IDENTITY(1,1) NOT NULL,
	[SURVEY_ID] [int] NOT NULL,
	[CONTACT_ID] [int] NOT NULL,
	[CONTACTTYPE_ID] [int] NULL,
 CONSTRAINT [PK_SURVEY_CONTACT] PRIMARY KEY CLUSTERED 
(
	[SURVEYCONTACT_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]


