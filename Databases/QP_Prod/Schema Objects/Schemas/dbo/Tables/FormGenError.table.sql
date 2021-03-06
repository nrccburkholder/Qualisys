﻿CREATE TABLE [dbo].[FormGenError](
	[FormGenError_id] [int] IDENTITY(1,1) NOT NULL,
	[ScheduledMailing_id] [int] NULL,
	[datGenerated] [datetime] NOT NULL,
	[FGErrorType_id] [int] NOT NULL,
 CONSTRAINT [PK_FORMGENERROR] PRIMARY KEY NONCLUSTERED 
(
	[FormGenError_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [FGPopTables]


