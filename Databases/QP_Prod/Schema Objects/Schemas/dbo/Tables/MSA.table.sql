﻿CREATE TABLE [dbo].[MSA](
	[MSA_ID] [int] IDENTITY(1,1) NOT NULL,
	[MSA_DESC] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_MSA] PRIMARY KEY CLUSTERED 
(
	[MSA_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]


