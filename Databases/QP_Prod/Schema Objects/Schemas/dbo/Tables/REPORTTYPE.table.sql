﻿CREATE TABLE [dbo].[REPORTTYPE](
	[REPORTTYPE_ID] [int] IDENTITY(1,1) NOT NULL,
	[STRREPORTTYPE_CD] [char](15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_REPORTTYPE] PRIMARY KEY CLUSTERED 
(
	[REPORTTYPE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]


