﻿CREATE TABLE [dbo].[MAILINGSTE_09242009143737000](
	[MAILINGSTEP_ID] [int] IDENTITY(1,1) NOT NULL,
	[METHODOLOGY_ID] [int] NOT NULL,
	[SURVEY_ID] [int] NULL,
	[INTSEQUENCE] [int] NOT NULL,
	[SELCOVER_ID] [int] NULL,
	[BITSURVEYINLINE] [bit] NOT NULL,
	[BITSENDSURVEY] [bit] NOT NULL,
	[INTINTERVALDAYS] [int] NOT NULL,
	[BITTHANKYOUITEM] [bit] NOT NULL,
	[STRMAILINGSTEP_NM] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BITFIRSTSURVEY] [bit] NOT NULL,
	[OverRide_Langid] [int] NULL,
	[MMMailingStep_id] [int] NULL,
	[MailingStepMethod_id] [tinyint] NULL DEFAULT (0),
	[ExpireInDays] [int] NULL DEFAULT (84),
	[ExpireFromStep] [int] NULL,
 CONSTRAINT [PK_MAILING_09242009143737001] PRIMARY KEY CLUSTERED 
(
	[MAILINGSTEP_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]


