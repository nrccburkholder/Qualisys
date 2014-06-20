﻿CREATE TABLE [dbo].[PU_Log](
	[PU_ID] [int] NOT NULL,
	[DueDate] [datetime] NOT NULL,
	[SentDate] [datetime] NULL,
	[Status] [tinyint] NOT NULL DEFAULT (1),
	[PUReport_ID] [int] NULL,
 CONSTRAINT [PK_PU_Log] PRIMARY KEY CLUSTERED 
(
	[PU_ID] ASC,
	[DueDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

