﻿CREATE TABLE [dbo].[QDECommentSelCodes](
	[Cmnt_id] [int] NOT NULL,
	[CmntCode_id] [int] NOT NULL,
 CONSTRAINT [PK_QDECommentSelCodes] PRIMARY KEY CLUSTERED 
(
	[Cmnt_id] ASC,
	[CmntCode_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

