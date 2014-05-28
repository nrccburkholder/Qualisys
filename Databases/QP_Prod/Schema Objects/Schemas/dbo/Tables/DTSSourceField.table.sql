﻿CREATE TABLE [dbo].[DTSSourceField](
	[DTSSourceField_id] [int] IDENTITY(1,1) NOT NULL,
	[DTSDestTable_id] [int] NOT NULL,
	[strField_nm] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[strFieldType] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[intFieldLength] [int] NULL,
	[intOrdinal] [int] NULL
) ON [PRIMARY]


