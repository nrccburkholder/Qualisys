/*
S8.US13	Create New Standard Methodology for ACO CAHPS
	As an Operations or Survey Management associate, I want the mail and phone steps to generate at the appropriate time, so that we can field according to the new schedule

T13.1	Add triggers to record the changes in the ChangeLog
T13.2	Update the existing methodology

Dave Gilsdorf

CREATE TRIGGER [dbo].[trg_Upd_dbo_StandardMailingStep] 
UPDATE StandardMailingStep
INSERT INTO ChangeLog
UPDATE MailingStep
*/
use qp_prod
go
begin tran
go
if exists (select * from sys.objects where type='tr' and name = 'trg_Upd_dbo_StandardMailingStep')
	drop trigger [dbo].[trg_Upd_dbo_StandardMailingStep] 
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
begin tran

-- updating the standard methodology
update sms 
set INTINTERVALDAYS=case intSequence 
						when 1 then 0 
						when 2 then 4 
						when 3 then 21
						when 4 then 20
					end
	,ExpireInDays=case intSequence
						when 1 then 82 
						when 2 then 82
						when 3 then 82
						when 4 then 32
					end
	,DaysInField = case when intSequence=4 then 29 else sms.daysinField end
--select sms.* 
from standardmailingstep sms
inner join standardmethodology sm on sms.StandardMethodologyID=sm.StandardMethodologyID
where strStandardMethodology_nm='ACO Mixed Mail-Phone'

-- updating existing surveys that use the standardmethodology (and explicitly inserting records into ChangeLog)
-- intIntervalDays:
insert into dbo.changelog (IDValue, IDName, Property, OldValue, NewValue, datChanged, ChangedBy, ActionType)
select ms.MailingStep_id, 'MethodologyStep', 'DaysSincePreviousStep', ms.INTINTERVALDAYS as oldValue
	, case intSequence	when 1 then 0 
						when 2 then 4 
						when 3 then 21
						when 4 then 20
					end as NewValue
	, getdate(), 'manual:'+system_user, 'U'
from mailingmethodology mm
inner join mailingstep ms on mm.methodology_id=ms.methodology_id
where mm.StandardMethodologyID=19

update ms 
set INTINTERVALDAYS=case intSequence 
						when 1 then 0 
						when 2 then 4 
						when 3 then 21
						when 4 then 20
					end
from mailingmethodology mm
inner join mailingstep ms on mm.methodology_id=ms.methodology_id
where mm.StandardMethodologyID=19

-- ExpireInDays:
insert into dbo.changelog (IDValue, IDName, Property, OldValue, NewValue, datChanged, ChangedBy, ActionType)
select ms.MailingStep_id, 'MethodologyStep', 'ExpirationDays', ms.ExpireInDays as oldValue
	, case intSequence	when 1 then 82 
						when 2 then 82
						when 3 then 82
						when 4 then 32
					end as NewValue
	, getdate(), 'manual:'+system_user, 'U'
from mailingmethodology mm
inner join mailingstep ms on mm.methodology_id=ms.methodology_id
where mm.StandardMethodologyID=19

update ms 
set ExpireInDays=case intSequence
						when 1 then 82 
						when 2 then 82
						when 3 then 82
						when 4 then 32
					end
-- select ms.*
from mailingmethodology mm
inner join mailingstep ms on mm.methodology_id=ms.methodology_id
where mm.StandardMethodologyID=19

-- DaysInField:
insert into dbo.changelog (IDValue, IDName, Property, OldValue, NewValue, datChanged, ChangedBy, ActionType)
select ms.MailingStep_id, 'MethodologyStep', 'DaysInField', ms.DaysInField as oldValue, 29 as NewValue
	, getdate(), 'manual:'+system_user, 'U'
from mailingmethodology mm
inner join mailingstep ms on mm.methodology_id=ms.methodology_id
where mm.StandardMethodologyID=19
and intSequence=4

update ms 
set DaysInField=29
-- select ms.*
from mailingmethodology mm
inner join mailingstep ms on mm.methodology_id=ms.methodology_id
where mm.StandardMethodologyID=19
and intSequence=4

rollback tran
commit tran

/*
MAILINGSTEP_ID	BITSURVEYINLINE		OverRide_Langid	
	
      select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='CoverLetterId'			-- SELCOVER_ID	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='DaysInField'			-- DaysInField	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='DaysSincePreviousStep'	-- INTINTERVALDAYS	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='ExpirationDays'			-- ExpireInDays	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='ExpireFromStepId'		-- ExpireFromStep	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='IsAcceptPartial'		-- AcceptPartial	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='IsCallBackOtherLang'	-- CallBackOtherLang	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='IsCallBackUsingTTY'		-- CallbackUsingTTY	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='IsEmailBlast'			-- SendEmailBlast	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='IsFirstSurvey'			-- BITFIRSTSURVEY	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='IsSaturdayDayCall'		-- Sat_Day_Call	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='IsSaturdayEveCall'		-- Sat_Eve_Call	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='IsSundayDayCall'		-- Sun_Day_Call	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='IsSundayEveCall'		-- Sun_Eve_Call	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='IsSurvey'				-- BITSENDSURVEY
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='IsThankYouLetter'		-- BITTHANKYOUITEM	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='IsWeekDayDayCall'		-- WeekDay_Day_Call	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='IsWeekDayEveCall'		-- WeekDay_Eve_Call	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='LinkedStepId'			-- MMMailingStep_id (?)
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='MethodologyId'			-- METHODOLOGY_ID	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='Name'					-- STRMAILINGSTEP_NM	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='NumberOfAttempts'		-- NumberOfAttempts	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='QuotaID'				-- Quota_ID	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='QuotaStopCollectionAt'	-- QuotaStopCollectionAt	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='SequenceNumber'			-- INTSEQUENCE	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='StepMethodId'			-- MailingStepMethod_id	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='SurveyId'				-- SURVEY_ID	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='VendorSurveyID'			-- Vendor_ID
*/
