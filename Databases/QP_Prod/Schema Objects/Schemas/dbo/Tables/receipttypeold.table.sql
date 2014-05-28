CREATE TABLE [dbo].[receipttypeold](
	[ReceiptType_id] [int] IDENTITY(1,1) NOT NULL,
	[ReceiptType_nm] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReceiptType_dsc] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bitUIDisplay] [bit] NULL,
	[TranslationCode] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED 
(
	[ReceiptType_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


