﻿CREATE TABLE [dbo].[DeleteKeysMasterTable](
	[Study_Id] [int] NOT NULL,
	[KeyColumnName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Study_Id] ASC,
	[KeyColumnName] ASC,
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


