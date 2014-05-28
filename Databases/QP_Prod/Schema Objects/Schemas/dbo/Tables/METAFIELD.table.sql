﻿CREATE TABLE [dbo].[METAFIELD](
	[FIELD_ID] [int] IDENTITY(1,1) NOT NULL,
	[STRFIELD_NM] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[STRFIELD_DSC] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FIELDGROUP_ID] [int] NULL,
	[STRFIELDDATATYPE] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[INTFIELDLENGTH] [int] NULL,
	[STRFIELDEDITMASK] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[INTSPECIALFIELD_CD] [int] NULL,
	[STRFIELDSHORT_NM] [char](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BITSYSKEY] [bit] NOT NULL,
	[bitPhase1Field] [bit] NULL CONSTRAINT [DF__metafield__bitPh__67C004A0]  DEFAULT (0),
	[intAddrCleanCode] [int] NULL,
	[intAddrCleanGroup] [int] NULL,
	[bitPII] [bit] NULL,
 CONSTRAINT [PK_METAFIELD] PRIMARY KEY CLUSTERED 
(
	[FIELD_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_strFIELD_nm] UNIQUE NONCLUSTERED 
(
	[STRFIELD_NM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


