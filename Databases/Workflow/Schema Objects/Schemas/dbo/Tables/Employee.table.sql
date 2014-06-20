﻿CREATE TABLE [dbo].[Employee](
	[EMPLOYEE_ID] [int] IDENTITY(1,1) NOT NULL,
	[STREMPLOYEE_FIRST_NM] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[STREMPLOYEE_LAST_NM] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[STREMPLOYEE_TITLE] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[STRNTLOGIN_NM] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[strPhoneExt] [char](5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[strEmail] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FullAccess] [bit] NULL,
	[Dashboard_FullAccess] [bit] NULL,
	[bitActive] [bit] NULL,
	[role_id] [int] NULL,
	[Country_id] [int] NOT NULL,
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
(
	[EMPLOYEE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

