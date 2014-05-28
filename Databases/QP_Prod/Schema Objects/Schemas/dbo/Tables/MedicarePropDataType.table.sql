﻿CREATE TABLE [dbo].[MedicarePropDataType](
	[MedicarePropDataType_ID] [int] IDENTITY(1,1) NOT NULL,
	[MedicarePropDataType_nm] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_MedicarePropDataType] PRIMARY KEY CLUSTERED 
(
	[MedicarePropDataType_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


