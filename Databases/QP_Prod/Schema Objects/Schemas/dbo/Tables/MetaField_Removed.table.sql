CREATE TABLE [dbo].[MetaField_Removed](
	[Field_id] [int] NULL,
	[strField_nm] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[strField_dsc] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FieldGroup_id] [int] NULL,
	[strFieldDataType] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[intFieldLength] [int] NULL,
	[strFieldEditMask] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[intSpecialField_cd] [int] NULL,
	[strFieldShort_nm] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bitSysKey] [bit] NULL,
	[bitPhase1Field] [bit] NULL,
	[intAddrCleanCode] [int] NULL,
	[intAddrCleanGroup] [int] NULL
) ON [PRIMARY]


