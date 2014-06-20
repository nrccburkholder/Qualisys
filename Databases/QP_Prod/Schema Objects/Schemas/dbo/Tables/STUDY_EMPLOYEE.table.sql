﻿CREATE TABLE [dbo].[STUDY_EMPLOYEE](
	[EMPLOYEE_ID] [int] NOT NULL,
	[STUDY_ID] [int] NOT NULL,
 CONSTRAINT [PK_STUDY_EMPLOYEE] PRIMARY KEY CLUSTERED 
(
	[EMPLOYEE_ID] ASC,
	[STUDY_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

