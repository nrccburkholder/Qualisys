﻿CREATE TABLE [dbo].[QueryForList](
	[QueryForList_id] [int] IDENTITY(1,1) NOT NULL,
	[strQueryForList] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_QueryForList] PRIMARY KEY CLUSTERED 
(
	[QueryForList_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

