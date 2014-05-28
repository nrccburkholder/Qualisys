CREATE TABLE [dbo].[DTSPackage](
	[DTSPackage_id] [int] IDENTITY(1,1) NOT NULL,
	[datCreated] [datetime] NULL,
	[strPackage_nm] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DTSSourceType_id] [int] NULL,
	[strTextFileDelimiter] [varchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bitTextFileHeader] [bit] NULL,
	[strLoadDirectory] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bitVerifyFields] [bit] NULL,
	[strFieldLengths] [varchar](512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


