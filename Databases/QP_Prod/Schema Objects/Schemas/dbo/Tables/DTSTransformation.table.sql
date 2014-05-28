CREATE TABLE [dbo].[DTSTransformation](
	[DTSTransformation_id] [int] IDENTITY(1,1) NOT NULL,
	[DTSPackage_id] [int] NULL,
	[strSource_nm] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[strSourceType] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[intSourceLength] [int] NULL,
	[strDestTable_nm] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[strDest_nm] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[strDestType] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[intDestLength] [int] NULL,
	[bitCopyColumn] [bit] NULL,
	[strScript] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


