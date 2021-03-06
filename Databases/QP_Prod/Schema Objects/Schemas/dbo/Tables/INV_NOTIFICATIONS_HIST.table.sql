﻿CREATE TABLE [dbo].[INV_NOTIFICATIONS_HIST](
	[INV_NOTIF_HIST_ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[INVOICE_NUMBER] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[INVOICE_DATE] [datetime] NULL,
	[INVOICE_AMOUNT] [numeric](12, 2) NULL,
	[BILL_TO_ID] [int] NULL,
	[INVOICE_BALANCE] [numeric](12, 2) NULL,
	[INVOICE_DUE_DATE] [datetime] NULL,
	[NOTIFICATION_DATE] [datetime] NULL,
	[CREATION_DATE] [datetime] NULL,
	[CREATED_BY] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LAST_UPDATE_DATE] [datetime] NULL,
	[LAST_UPDATED_BY] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [INV_NOTIF_HIST_PK] PRIMARY KEY CLUSTERED 
(
	[INV_NOTIF_HIST_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]


