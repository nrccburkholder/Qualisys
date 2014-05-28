CREATE TABLE [dbo].[ReceiptType](
	[ReceiptType_id] [int] IDENTITY(0,1) NOT NULL,
	[ReceiptType_nm] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReceiptType_dsc] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bitUIDisplay] [bit] NULL,
	[TranslationCode] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


