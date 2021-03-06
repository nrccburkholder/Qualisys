﻿CREATE TABLE [dbo].[PCLGENRUN](
	[PCLGENRUN_ID] [int] IDENTITY(1,1) NOT NULL,
	[COMPUTER_NM] [varchar](16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[START_DT] [datetime] NOT NULL,
	[END_DT] [datetime] NULL,
	[PCLGenVersion] [varchar](25),
 CONSTRAINT [PK_PCLGENRUN] PRIMARY KEY CLUSTERED 
(
	[PCLGENRUN_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]


