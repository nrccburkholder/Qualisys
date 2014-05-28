﻿CREATE TABLE [dbo].[MM_EmailBlast](
	[MM_EmailBlast_ID] [int] IDENTITY(1,1) NOT NULL,
	[MAILINGSTEP_ID] [int] NULL,
	[EmailBlast_ID] [int] NULL,
	[DaysFromStepGen] [int] NULL,
	[DateSent] [datetime] NULL,
 CONSTRAINT [PK9] PRIMARY KEY CLUSTERED 
(
	[MM_EmailBlast_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


