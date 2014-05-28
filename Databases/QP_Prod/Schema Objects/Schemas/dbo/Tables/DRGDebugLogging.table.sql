﻿CREATE TABLE [dbo].[DRGDebugLogging](
	[DRGDebug_ID] [int] IDENTITY(1,1) NOT NULL,
	[Study_ID] [int] NULL,
	[DataFile_ID] [int] NULL,
	[Message] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DateStamp] [datetime] NULL CONSTRAINT [DF_DRGDebugLogging_DateStamp]  DEFAULT (getdate()),
 CONSTRAINT [PK_DRGDebugLogging] PRIMARY KEY CLUSTERED 
(
	[DRGDebug_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


