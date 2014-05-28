﻿CREATE TABLE [dbo].[DispositionListSurvey](
	[DispositionList_id] [int] NOT NULL,
	[Survey_id] [int] NOT NULL,
 CONSTRAINT [PK_DispositionListSurvey] PRIMARY KEY CLUSTERED 
(
	[DispositionList_id] ASC,
	[Survey_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_DispositionListSurvey] UNIQUE NONCLUSTERED 
(
	[Survey_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


