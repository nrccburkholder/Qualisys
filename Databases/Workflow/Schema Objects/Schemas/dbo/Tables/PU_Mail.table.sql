﻿CREATE TABLE [dbo].[PU_Mail](
	[PU_ID] [int] NOT NULL,
	[Format] [tinyint] NOT NULL,
	[ModifiedBy] [int] NULL,
	[DateModified] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[PU_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

