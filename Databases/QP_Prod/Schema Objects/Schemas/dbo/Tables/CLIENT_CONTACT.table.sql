﻿CREATE TABLE [dbo].[CLIENT_CONTACT](
	[CONTACT_ID] [int] IDENTITY(1,1) NOT NULL,
	[CLIENT_ID] [int] NOT NULL,
	[STRCONTACTNAME] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[STRCONTACTPHONE] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[STRCONTACTFAX] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[STRCONTACTTITLE] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[STRCONTACTADDR1] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[STRCONTACTADDR2] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[STRCONTACTCITY] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[STRCONTACTSTATE] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[STRCONTACTZIP] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[STRCONTACTEMAIL] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_CLIENT_CONTACT] PRIMARY KEY CLUSTERED 
(
	[CONTACT_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

