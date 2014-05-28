CREATE TABLE [dbo].[StandardMailingStep](
	[StandardMailingStepID] [int] IDENTITY(1,1) NOT NULL,
	[StandardMethodologyID] [int] NOT NULL,
	[intSequence] [int] NOT NULL,
	[bitSurveyInLine] [bit] NOT NULL,
	[bitSendSurvey] [bit] NOT NULL,
	[intIntervalDays] [int] NOT NULL,
	[bitThankYouItem] [bit] NOT NULL,
	[strMailingStep_nm] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[bitFirstSurvey] [bit] NOT NULL,
	[OverRide_Langid] [int] NULL,
	[MMMailingStep_id] [int] NULL,
	[MailingStepMethod_id] [tinyint] NULL CONSTRAINT [DF__MAILINGST__Mail__16EEEF56]  DEFAULT (0),
	[ExpireInDays] [int] NULL CONSTRAINT [DF__MailingSt__Expi__23D4B47F]  DEFAULT (84),
	[ExpireFromStep] [int] NULL,
	[Quota_ID] [int] NULL,
	[QuotaStopCollectionAt] [int] NULL CONSTRAINT [DF__StandardM__Quota__65796029]  DEFAULT (0),
	[DaysInField] [int] NULL CONSTRAINT [DF__StandardM__DaysI__666D8462]  DEFAULT (0),
	[NumberOfAttempts] [int] NULL CONSTRAINT [DF__StandardM__Numbe__6761A89B]  DEFAULT (0),
	[WeekDay_Day_Call] [bit] NULL CONSTRAINT [DF__StandardM__WeekD__6855CCD4]  DEFAULT (0),
	[WeekDay_Eve_Call] [bit] NULL CONSTRAINT [DF__StandardM__WeekD__6949F10D]  DEFAULT (0),
	[Sat_Day_Call] [bit] NULL CONSTRAINT [DF__StandardM__Sat_D__6A3E1546]  DEFAULT (0),
	[Sat_Eve_Call] [bit] NULL CONSTRAINT [DF__StandardM__Sat_E__6B32397F]  DEFAULT (0),
	[Sun_Day_Call] [bit] NULL CONSTRAINT [DF__StandardM__Sun_D__6C265DB8]  DEFAULT (0),
	[Sun_Eve_Call] [bit] NULL CONSTRAINT [DF__StandardM__Sun_E__6D1A81F1]  DEFAULT (0),
	[CallBackOtherLang] [bit] NULL CONSTRAINT [DF__StandardM__CallB__6E0EA62A]  DEFAULT (0),
	[CallbackUsingTTY] [bit] NULL CONSTRAINT [DF__StandardM__Callb__6F02CA63]  DEFAULT (0),
	[AcceptPartial] [bit] NULL CONSTRAINT [DF__StandardM__Accep__6FF6EE9C]  DEFAULT (0),
	[SendEmailBlast] [bit] NULL CONSTRAINT [DF__StandardM__SendE__70EB12D5]  DEFAULT (0),
 CONSTRAINT [PK_StandardMailingStep] PRIMARY KEY CLUSTERED 
(
	[StandardMailingStepID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


