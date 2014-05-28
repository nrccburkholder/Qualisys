﻿CREATE TABLE [dbo].[QSIDataResults](
	[Result_ID] [int] IDENTITY(1,1) NOT NULL,
	[Form_ID] [int] NOT NULL,
	[QstnCore] [int] NOT NULL,
	[ResponseValue] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Result_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]


