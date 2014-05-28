CREATE TABLE [dbo].[PU_Address](
	[Addr_ID] [int] IDENTITY(1,1) NOT NULL,
	[AddrLabel] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Addr1] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Addr2] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ST] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Country] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Zip] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TollFreePhone] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Fax] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Addr4HtmlMail] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Addr4TextMail] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone4Mail] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED 
(
	[Addr_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


