CREATE TABLE [dbo].[MethodologyStepType](
	[MethodologyStepTypeId] [int] IDENTITY(1,1) NOT NULL,
	[bitSurveyInLine] [bit] NULL,
	[bitSendSurvey] [bit] NULL,
	[bitThankYouItem] [bit] NULL,
	[strMailingStep_nm] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MailingStepMethod_id] [int] NULL CONSTRAINT [DF__methodologyStepType__Mail__16EEEF56]  DEFAULT (0),
	[CoverLetterRequired] [bit] NULL,
	[ExpireInDays] [int] NULL CONSTRAINT [DF_MethodologyStepType_ExpireInDays]  DEFAULT (42),
	[Quota_ID] [int] NULL,
	[QuotaStopCollectionAt] [int] NULL CONSTRAINT [DF__methodolo__Quota__44035DC5]  DEFAULT (0),
	[DaysInField] [int] NULL CONSTRAINT [DF__methodolo__DaysI__44F781FE]  DEFAULT (0),
	[NumberOfAttempts] [int] NULL CONSTRAINT [DF__methodolo__Numbe__45EBA637]  DEFAULT (0),
	[WeekDay_Day_Call] [bit] NULL CONSTRAINT [DF__methodolo__WeekD__46DFCA70]  DEFAULT (0),
	[WeekDay_Eve_Call] [bit] NULL CONSTRAINT [DF__methodolo__WeekD__47D3EEA9]  DEFAULT (0),
	[Sat_Day_Call] [bit] NULL CONSTRAINT [DF__methodolo__Sat_D__48C812E2]  DEFAULT (0),
	[Sat_Eve_Call] [bit] NULL CONSTRAINT [DF__methodolo__Sat_E__49BC371B]  DEFAULT (0),
	[Sun_Day_Call] [bit] NULL CONSTRAINT [DF__methodolo__Sun_D__4AB05B54]  DEFAULT (0),
	[Sun_Eve_Call] [bit] NULL CONSTRAINT [DF__methodolo__Sun_E__4BA47F8D]  DEFAULT (0),
	[CallBackOtherLang] [bit] NULL CONSTRAINT [DF__methodolo__CallB__4C98A3C6]  DEFAULT (0),
	[CallbackUsingTTY] [bit] NULL CONSTRAINT [DF__methodolo__Callb__4D8CC7FF]  DEFAULT (0),
	[AcceptPartial] [bit] NULL CONSTRAINT [DF__methodolo__Accep__4E80EC38]  DEFAULT (0),
	[SendEmailBlast] [bit] NULL CONSTRAINT [DF__methodolo__SendE__4F751071]  DEFAULT (0)
) ON [PRIMARY]


