﻿CREATE TABLE [dbo].[USPSorig](
	[ZIP3_CD] [char](3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SCHEME] [char](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SCHEMELBL] [char](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AADC] [char](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AADCLBL] [char](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DIST] [int] NULL,
	[ADC] [char](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ADCLBL] [char](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_USPS] PRIMARY KEY CLUSTERED 
(
	[ZIP3_CD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]


