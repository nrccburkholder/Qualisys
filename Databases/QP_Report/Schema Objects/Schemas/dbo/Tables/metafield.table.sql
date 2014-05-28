CREATE TABLE [dbo].[metafield](
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
	[bitPhase1Field] [bit] NULL,
	[intAddrCleanCode] [int] NULL,
	[intAddrCleanGroup] [int] NULL
) ON [PRIMARY]


