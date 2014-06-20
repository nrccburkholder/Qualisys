﻿CREATE TABLE [dbo].[TAG](
	[TAG_ID] [int] IDENTITY(1,1) NOT NULL,
	[TAG] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TAG_DSC] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_TAG] PRIMARY KEY CLUSTERED 
(
	[TAG_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

