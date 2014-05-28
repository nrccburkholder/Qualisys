CREATE TABLE [dbo].[USPS](
	[ZIP3_CD] [char](3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SCHEME] [char](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SCHEMELBL] [char](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AADC] [char](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AADCLBL] [char](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DIST] [int] NULL,
	[ADC] [char](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ADCLBL] [char](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


