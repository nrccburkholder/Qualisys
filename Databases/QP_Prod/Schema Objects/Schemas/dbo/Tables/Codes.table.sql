﻿CREATE TABLE [dbo].[Codes](
	[Code] [int] IDENTITY(1,1) NOT NULL,
	[LangID] [int] NOT NULL,
	[Description] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Fielded] [int] NOT NULL,
 CONSTRAINT [PK_CODES] PRIMARY KEY CLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]


