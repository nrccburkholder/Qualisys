﻿CREATE TABLE [dbo].[MM_EmailBlast_Options](
	[EmailBlast_ID] [int] IDENTITY(1,1) NOT NULL,
	[Value] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK10] PRIMARY KEY CLUSTERED 
(
	[EmailBlast_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


