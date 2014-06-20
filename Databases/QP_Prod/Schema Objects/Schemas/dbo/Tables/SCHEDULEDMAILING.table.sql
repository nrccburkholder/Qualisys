﻿CREATE TABLE [dbo].[SCHEDULEDMAILING](
	[SCHEDULEDMAILING_ID] [int] IDENTITY(1,1) NOT NULL,
	[MAILINGSTEP_ID] [int] NULL,
	[SAMPLEPOP_ID] [int] NULL,
	[OVERRIDEITEM_ID] [int] NULL,
	[SENTMAIL_ID] [int] NULL,
	[METHODOLOGY_ID] [int] NULL,
	[DATGENERATE] [datetime] NOT NULL,
 CONSTRAINT [PK_SCHEDULEDMAILING] PRIMARY KEY CLUSTERED 
(
	[SCHEDULEDMAILING_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

