﻿CREATE TABLE [dbo].[FG_MailingWork](
	[STUDY_ID] [int] NULL,
	[SURVEY_ID] [int] NULL,
	[SAMPLEPOP_ID] [int] NULL,
	[SAMPLESET_ID] [int] NULL,
	[POP_ID] [int] NULL,
	[SCHEDULEDMAILING_ID] [int] NULL,
	[MAILINGSTEP_ID] [int] NULL,
	[METHODOLOGY_ID] [int] NULL,
	[OVERRIDEITEM_ID] [int] NULL,
	[POPTABLE_NM] [char](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ZIPFIELD_NM] [char](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LANGFIELD_NM] [char](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ZIP3_CD] [char](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LANGID] [int] NULL,
	[SELCOVER_ID] [int] NULL,
	[BITSURVEYINLINE] [bit] NOT NULL,
	[INTINTERVALDAYS] [int] NULL,
	[BITTHANKYOUITEM] [bit] NOT NULL,
	[BITFIRSTSURVEY] [bit] NOT NULL,
	[BITSENDSURVEY] [bit] NOT NULL,
	[NEXTMAILINGSTEP_ID] [int] NULL,
	[INTOFFSETDAYS] [int] NULL,
	[SENTMAIL_ID] [int] NULL,
	[QUESTIONFORM_ID] [int] NULL,
	[BATCH_ID] [int] NULL,
	[BITDONE] [bit] NOT NULL CONSTRAINT [DF_FG_MailingWork_BITDONE]  DEFAULT ((0)),
	[Priority_Flg] [tinyint] NULL,
	[Zip5] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Zip4] [varchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [FGPopTables]

