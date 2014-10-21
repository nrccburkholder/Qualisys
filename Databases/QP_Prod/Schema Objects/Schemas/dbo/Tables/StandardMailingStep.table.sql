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
go
CREATE TRIGGER [dbo].[trg_Upd_dbo_StandardMailingStep] 
   ON  [dbo].[StandardMailingStep] 
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON

/*
-- code to generate the following insert commands:

select '	if UPDATE('+name+')
		insert into dbo.ChangeLog (IDValue, IDName, Property, OldValue, NewValue, datChanged, ChangedBy, ActionType)
		select i.StandardMailingStepID, ''StandardMailingStep'', '''+name+''', d.'+name+', i.'+name+', getdate(), ''trg_Upd_dbo_StandardMailingStep:''+system_user, ''U''
		from INSERTED i inner join DELETED d on i.StandardMailingStepID = d.StandardMailingStepID
		where (d.'+name+' <> i.'+name+') '+
		case when is_nullable=1 then '
			or (d.'+name+' is null and i.'+name+' is not null) 
			or (d.'+name+' is not null and i.'+name+' is null)' 
			else '' 
		end + '

'
from sys.columns
where object_name(object_id)='StandardMailingStep'
and name in ('intSequence','bitSendSurvey','intIntervalDays','strMailingStep_nm','bitFirstSurvey','MailingStepMethod_id','ExpireInDays','ExpireFromStep','DaysInField','NumberOfAttempts','SendEmailBlast')
order by column_id
	
*/

	if UPDATE(intSequence)
		insert into dbo.ChangeLog (IDValue, IDName, Property, OldValue, NewValue, datChanged, ChangedBy, ActionType)
		select i.StandardMailingStepID, 'StandardMailingStep', 'intSequence', d.intSequence, i.intSequence, getdate(), 'trg_Upd_dbo_StandardMailingStep:'+system_user, 'U'
		from INSERTED i inner join DELETED d on i.StandardMailingStepID = d.StandardMailingStepID
		where (d.intSequence <> i.intSequence) 

	if UPDATE(bitSendSurvey)
		insert into dbo.ChangeLog (IDValue, IDName, Property, OldValue, NewValue, datChanged, ChangedBy, ActionType)
		select i.StandardMailingStepID, 'StandardMailingStep', 'bitSendSurvey', d.bitSendSurvey, i.bitSendSurvey, getdate(), 'trg_Upd_dbo_StandardMailingStep:'+system_user, 'U'
		from INSERTED i inner join DELETED d on i.StandardMailingStepID = d.StandardMailingStepID
		where (d.bitSendSurvey <> i.bitSendSurvey) 

	if UPDATE(intIntervalDays)
		insert into dbo.ChangeLog (IDValue, IDName, Property, OldValue, NewValue, datChanged, ChangedBy, ActionType)
		select i.StandardMailingStepID, 'StandardMailingStep', 'intIntervalDays', d.intIntervalDays, i.intIntervalDays, getdate(), 'trg_Upd_dbo_StandardMailingStep:'+system_user, 'U'
		from INSERTED i inner join DELETED d on i.StandardMailingStepID = d.StandardMailingStepID
		where (d.intIntervalDays <> i.intIntervalDays) 

	if UPDATE(strMailingStep_nm)
		insert into dbo.ChangeLog (IDValue, IDName, Property, OldValue, NewValue, datChanged, ChangedBy, ActionType)
		select i.StandardMailingStepID, 'StandardMailingStep', 'strMailingStep_nm', d.strMailingStep_nm, i.strMailingStep_nm, getdate(), 'trg_Upd_dbo_StandardMailingStep:'+system_user, 'U'
		from INSERTED i inner join DELETED d on i.StandardMailingStepID = d.StandardMailingStepID
		where (d.strMailingStep_nm <> i.strMailingStep_nm) 

	if UPDATE(bitFirstSurvey)
		insert into dbo.ChangeLog (IDValue, IDName, Property, OldValue, NewValue, datChanged, ChangedBy, ActionType)
		select i.StandardMailingStepID, 'StandardMailingStep', 'bitFirstSurvey', d.bitFirstSurvey, i.bitFirstSurvey, getdate(), 'trg_Upd_dbo_StandardMailingStep:'+system_user, 'U'
		from INSERTED i inner join DELETED d on i.StandardMailingStepID = d.StandardMailingStepID
		where (d.bitFirstSurvey <> i.bitFirstSurvey) 

	if UPDATE(MailingStepMethod_id)
		insert into dbo.ChangeLog (IDValue, IDName, Property, OldValue, NewValue, datChanged, ChangedBy, ActionType)
		select i.StandardMailingStepID, 'StandardMailingStep', 'MailingStepMethod_id', d.MailingStepMethod_id, i.MailingStepMethod_id, getdate(), 'trg_Upd_dbo_StandardMailingStep:'+system_user, 'U'
		from INSERTED i inner join DELETED d on i.StandardMailingStepID = d.StandardMailingStepID
		where (d.MailingStepMethod_id <> i.MailingStepMethod_id) 
			or (d.MailingStepMethod_id is null and i.MailingStepMethod_id is not null) 
			or (d.MailingStepMethod_id is not null and i.MailingStepMethod_id is null)

	if UPDATE(ExpireInDays)
		insert into dbo.ChangeLog (IDValue, IDName, Property, OldValue, NewValue, datChanged, ChangedBy, ActionType)
		select i.StandardMailingStepID, 'StandardMailingStep', 'ExpireInDays', d.ExpireInDays, i.ExpireInDays, getdate(), 'trg_Upd_dbo_StandardMailingStep:'+system_user, 'U'
		from INSERTED i inner join DELETED d on i.StandardMailingStepID = d.StandardMailingStepID
		where (d.ExpireInDays <> i.ExpireInDays) 
			or (d.ExpireInDays is null and i.ExpireInDays is not null) 
			or (d.ExpireInDays is not null and i.ExpireInDays is null)

	if UPDATE(ExpireFromStep)
		insert into dbo.ChangeLog (IDValue, IDName, Property, OldValue, NewValue, datChanged, ChangedBy, ActionType)
		select i.StandardMailingStepID, 'StandardMailingStep', 'ExpireFromStep', d.ExpireFromStep, i.ExpireFromStep, getdate(), 'trg_Upd_dbo_StandardMailingStep:'+system_user, 'U'
		from INSERTED i inner join DELETED d on i.StandardMailingStepID = d.StandardMailingStepID
		where (d.ExpireFromStep <> i.ExpireFromStep) 
			or (d.ExpireFromStep is null and i.ExpireFromStep is not null) 
			or (d.ExpireFromStep is not null and i.ExpireFromStep is null)

	if UPDATE(DaysInField)
		insert into dbo.ChangeLog (IDValue, IDName, Property, OldValue, NewValue, datChanged, ChangedBy, ActionType)
		select i.StandardMailingStepID, 'StandardMailingStep', 'DaysInField', d.DaysInField, i.DaysInField, getdate(), 'trg_Upd_dbo_StandardMailingStep:'+system_user, 'U'
		from INSERTED i inner join DELETED d on i.StandardMailingStepID = d.StandardMailingStepID
		where (d.DaysInField <> i.DaysInField) 
			or (d.DaysInField is null and i.DaysInField is not null) 
			or (d.DaysInField is not null and i.DaysInField is null)

	if UPDATE(NumberOfAttempts)
		insert into dbo.ChangeLog (IDValue, IDName, Property, OldValue, NewValue, datChanged, ChangedBy, ActionType)
		select i.StandardMailingStepID, 'StandardMailingStep', 'NumberOfAttempts', d.NumberOfAttempts, i.NumberOfAttempts, getdate(), 'trg_Upd_dbo_StandardMailingStep:'+system_user, 'U'
		from INSERTED i inner join DELETED d on i.StandardMailingStepID = d.StandardMailingStepID
		where (d.NumberOfAttempts <> i.NumberOfAttempts) 
			or (d.NumberOfAttempts is null and i.NumberOfAttempts is not null) 
			or (d.NumberOfAttempts is not null and i.NumberOfAttempts is null)

	if UPDATE(SendEmailBlast)
		insert into dbo.ChangeLog (IDValue, IDName, Property, OldValue, NewValue, datChanged, ChangedBy, ActionType)
		select i.StandardMailingStepID, 'StandardMailingStep', 'SendEmailBlast', d.SendEmailBlast, i.SendEmailBlast, getdate(), 'trg_Upd_dbo_StandardMailingStep:'+system_user, 'U'
		from INSERTED i inner join DELETED d on i.StandardMailingStepID = d.StandardMailingStepID
		where (d.SendEmailBlast <> i.SendEmailBlast) 
			or (d.SendEmailBlast is null and i.SendEmailBlast is not null) 
			or (d.SendEmailBlast is not null and i.SendEmailBlast is null)

END
go


